import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../modules/app/app_router.dart';
import '../../domain/entities/user.dart';
import '../../domain/errors/api_error.dart';

/// Event bus for authentication-related events
/// 
/// This class provides a way to broadcast authentication events
/// to various parts of the application. This decouples the
/// error handling from UI navigation concerns.
@lazySingleton
class AuthEventBus {
  final AppRouter _router;
  
  // Stream controllers for different authentication events
  final StreamController<ApiError?> _unauthorizedController = StreamController.broadcast();
  // Controller for authentication success events (login/registration only)
  final StreamController<User> _authenticatedController = StreamController.broadcast();
  // Controller for user profile updates (when user data changes)
  final StreamController<User> _userUpdatedController = StreamController.broadcast();

  AuthEventBus(this._router);
  
  /// Stream of unauthorized events (401 errors)
  /// 
  /// Components can listen to this stream to respond to 401 unauthorized
  /// errors, such as by navigating to the login screen.
  /// The stream provides the error message associated with the 401 error.
  Stream<ApiError?> get onUnauthorized => _unauthorizedController.stream;
  
  /// Stream of authentication success events
  ///
  /// Components can listen to this stream to respond when a user
  /// is successfully authenticated, such as after registration or login.
  /// This should NOT be used for profile updates.
  Stream<User> get onAuthenticated => _authenticatedController.stream;
  
  /// Stream of user profile update events
  ///
  /// Components can listen to this stream to respond when user data
  /// is updated, such as after profile changes. This should NOT trigger
  /// authentication state changes, only user data updates.
  Stream<User> get onUserUpdated => _userUpdatedController.stream;
  
  /// Notifies all listeners about an unauthorized access attempt
  /// 
  /// @param message The error message to show to the user
  void notifyUnauthorized([ApiError? error]) {
    _unauthorizedController.add(error);
  }
  
  /// Notifies all listeners about successful authentication
  ///
  /// @param user The authenticated user
  /// @note Use this ONLY for full authentication events (login, registration)
  void notifyAuthenticated(User user) {
    _authenticatedController.add(user);
  }
  
  /// Notifies all listeners about user profile updates
  ///
  /// @param user The updated user data
  /// @note Use this for profile updates where authentication status doesn't change
  void notifyUserUpdated(User user) {
    _userUpdatedController.add(user);
  }

  /// check whether the current router is auth page or not
  ///
  /// @returns true if the current route is an auth page
  bool isAuthPage() => _router.current.name == AuthRoute.name;
  
  /// Disposes all controllers
  /// 
  /// This should be called when the app is shutting down
  void dispose() {
    _unauthorizedController.close();
    _authenticatedController.close();
    _userUpdatedController.close();
  }
}