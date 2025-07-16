import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../generated/l10n.dart';
import '../../../../common/extensions/int_duration.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/application/events/auth_event_bus.dart';
import '../../../../core/domain/constants/auth_validation_keys.dart';
import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/domain/value_objects/value_objects.dart';
import '../../../../core/infrastructure/datasources/local/storage.dart';
import '../../domain/errors/auth_error.dart';
import '../../domain/interfaces/auth_repository.dart';
import '../../domain/models/auth_request.dart';
import '../../domain/validators/authentication_validator.dart';

part 'auth_notifier.freezed.dart';
part 'auth_notifier.g.dart';
part 'auth_state.dart';

/// Provider for authentication state management
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => getIt<AuthNotifier>(),
);

final userProvider = Provider<User?>(
  (ref) {
    final authState = ref.watch(authProvider);
    return authState.user;
  },
);

@riverpod
Future<bool> isLoggedIn(Ref ref) async {
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(authProvider.select((s) => s.status)).maybeWhen(
        authenticated: (user) => true,
        orElse: () => false,
      );
}

@injectable
class AuthNotifier extends Notifier<AuthState> {
  final AuthRepository _repository;
  final AuthEventBus _authEventBus;

  // Stream subscriptions for auth events
  StreamSubscription? _authenticatedSubscription;
  StreamSubscription? _userUpdatedSubscription;
  StreamSubscription? _unauthorizedSubscription;

  AuthNotifier(this._repository, this._authEventBus);

  @override
  AuthState build() {
    // Schedule the authentication check to run after initialization
    // This pattern allows the build method to return synchronously while still
    // triggering the async authentication check
    Future.microtask(() async {
      await _checkExistingAuthentication();
      _setupEventListeners();
    });

    // Dispose subscriptions when notifier is disposed
    ref.onDispose(_disposeSubscriptions);

    return const AuthState();
  }

  /// Check if user is already authenticated from local storage
  Future<void> _checkExistingAuthentication() async {
    // Follows MCP-ddd-repository-pattern: Use repository for authentication checks
    logger.i('[AuthNotifier] Checking existing authentication');
    final isAuthenticated = await _repository.isLoggedIn();

    if (isAuthenticated) {
      // If user is authenticated, get current user from storage
      // This is safe because isLoggedIn() ensures both user data and token exist
      final currentUser = await _repository.getUser();

      /// refreshing the user data in background.
      /// Will be notified by the event bus
      _repository.me();
      if (currentUser != null) {
        logger.i('[AuthNotifier] User is already authenticated');
        state = state.onAuthenticated(currentUser);
      }
    } else {
      logger.i('[AuthNotifier] User is not authenticated');
      // User is not authenticated, ensure state reflects this
      // The isLoggedIn function already handles clearing partial authentication data
      state = const AuthState();
    }
  }

  /// Check if user is already authenticated from local storage
  Future<bool> isLoggedIn() async {
    return await _repository.isLoggedIn();
  }

  /// Setup event listeners for authentication and user updates
  void _setupEventListeners() {
    // Listen for authentication success events (login/registration)
    // Follows MCP-ddd-application-layer: Process domain events in application layer
    _authenticatedSubscription =
        _authEventBus.onAuthenticated.listen(_handleAuthenticationEvent);

    // Listen for user profile update events
    // Follows MCP-ddd-architecture-overview: Maintain separation of concerns
    _userUpdatedSubscription =
        _authEventBus.onUserUpdated.listen(_handleUserUpdatedEvent);

    // Listen for authentication failure events
    _unauthorizedSubscription = _authEventBus.onUnauthorized.listen((_) {
      logger.i('[AuthNotifier] User is unauthorized');
      // Reset entire state including input fields when unauthorized
      if (!_authEventBus.isAuthPage()) state = AuthState();
    });
  }

  /// Handle authentication event (login/registration)
  void _handleAuthenticationEvent(User user) async {
    logger.i('[AuthNotifier] Received authentication '
        'success event for user: ${user.id}');

    // Use repository to save user data and access token
    // Follows MCP-ddd-repository-pattern: Use repository for data persistence
    _repository.saveUserData(user);
    // The router will be notified by the event bus and wait for
    // the revalidation success before call the pop action
    await 100.milliseconds.delay;
    // Update auth state to authenticated
    state = state.onAuthenticated(user);
  }

  /// Handle user profile update event
  void _handleUserUpdatedEvent(User user) {
    logger.i('[AuthNotifier] Received user profile update '
        'event for user: ${user.id}');

    // Use repository to save updated user data
    // Follows MCP-ddd-repository-pattern: Use repository for data persistence
    // _repository.saveUserData(user);

    // Update only user data without changing authentication status
    // This maintains the current authentication state while updating user info
    final currentState = state;
    if (currentState.isAuthenticated) {
      state = currentState.copyWith(user: user);
      logger.i(
          '[AuthNotifier] Updated user data while maintaining authenticated state');
    } else {
      logger.w('[AuthNotifier] Received user update while not authenticated');
    }
  }

  /// Dispose all subscriptions
  void _disposeSubscriptions() {
    _authenticatedSubscription?.cancel();
    _authenticatedSubscription = null;

    _userUpdatedSubscription?.cancel();
    _userUpdatedSubscription = null;

    _unauthorizedSubscription?.cancel();
    _unauthorizedSubscription = null;

    logger.i('[AuthNotifier] Authentication subscriptions disposed');
  }

  /// Updates the phone input value
  void setPhone(String value) {
    state = state.updatePhone(value);
  }

  /// Updates the password input value
  void setPassword(String value) {
    state = state.updatePassword(value);
  }

  /// Logs in the user with the current input values
  Future<void> login() async {
    // Validate inputs first
    if (!state.input.isValid()) {
      // Get all validation errors and update state
      final errors = state.input.getErrorCase();
      state = state.onValidationErrors(errors);
      return;
    }

    try {
      // Set loading state
      state = state.loading;

      // Create domain value objects from validated inputs
      final phoneNumber = PhoneNumber(state.input.phone);
      final password = Password(state.input.password);

      // Create login request domain model
      final loginRequest = LoginRequest(
        mobileNumber: phoneNumber,
        password: password,
        pushToken: Storage.pushToken ?? '',
      );

      // Call repository login method with the request model
      final result = await _repository.login(loginRequest);

      // Handle result
      result.fold((user) {
        // Notify other components about successful authentication
        // The state will be updated by the onAuthenticated listener
        _authEventBus.notifyAuthenticated(user);
      }, (error) => state = state.onApiError(error));
    } on ArgumentError catch (e) {
      // Determine if this is a phone or password validation error
      final message = e.message.toString();
      final phoneKey = AuthValidationKeys.phone;
      final passwordKey = AuthValidationKeys.password;
      if (e.name?.contains(phoneKey) ?? false) {
        state = state.onInvalidPhone(message);
      } else if (e.name?.contains(passwordKey) ?? false) {
        state = state.onInvalidPassword(message);
      } else {
        // Unknown validation error
        state = state.onError(AuthError.unexpected(message));
      }
    } catch (e) {
      state = state.onError(AuthError.unexpected(e.toString()));
    }
  }

  /// Logs out the user
  Future<void> logout() async {
    // Follows MCP-ddd-repository-pattern: Use repository for data operations
    await _repository.logout();
    _authEventBus.notifyUnauthorized();
    logger.i('[AuthNotifier] User logged out successfully');
  }

  /// Resets the form input state to initial values only if user is not authenticated
  ///
  /// This method should be called when a user leaves the auth page without completing login
  /// to ensure the form is cleared and ready for the next attempt. If the user is already
  /// authenticated, this method will not modify the state.
  ///
  /// Follows MCP-ddd-application-layer: Implement reset mechanism for form state cleanup
  void resetState() {
    // Only reset state if the user is not authenticated
    if (!state.isAuthenticated) {
      logger.i('[AuthNotifier] Resetting auth form input state');

      // Reset to initial unauthenticated state with empty inputs
      state = state.copyWith(
        status: const AuthStatus.unauthenticated(),
        input: const AuthInput(),
      );
    } else {
      logger.d('[AuthNotifier] Skip resetting auth state '
          '- user is authenticated');
    }
  }
}
