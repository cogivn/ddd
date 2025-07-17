import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import '../../domain/errors/reset_error.dart';
import '../../domain/models/reset_request.dart';
import '../../domain/repositories/reset_repository.dart';
import '../../domain/validators/reset_validator.dart';

part 'reset_notifier.freezed.dart';
part 'reset_state.dart';

// Follows MCP-ddd-application-layer: Use Provider for dependency injection
@ProviderFor(ResetNotifier)
final resetProvider = AutoDisposeNotifierProvider<ResetNotifier, ResetState>(
  () => getIt<ResetNotifier>(),
);

// Follows MCP-ddd-application-layer: Keep notifier and state in same file
@injectable
class ResetNotifier extends AutoDisposeNotifier<ResetState> {
  final ResetRepository _repository;
  final String _instanceId = const Uuid().v4();
  CancelToken? _cancelToken;

  ResetNotifier(this._repository) {
    logger.d('[ResetNotifier] Created new instance $_instanceId');
  }

  @override
  ResetState build() {
    ref.onDispose(() {
      logger.d('[ResetNotifier] Disposed instance $_instanceId');
      _cancelOngoingRequests();
    });
    return const ResetState();
  }

  /// Cancels any ongoing API requests
  void _cancelOngoingRequests() {
    if (_cancelToken != null) {
      logger.d('[ResetNotifier] Cancelling requests for instance $_instanceId');
      _cancelToken?.cancel('Notifier was disposed');
      _cancelToken = null;
    }
  }

  /// Creates a new cancel token for API requests
  CancelToken _createCancelToken() {
    _cancelOngoingRequests();
    _cancelToken = CancelToken();
    logger.d(
        '[ResetNotifier] Created new cancel token for instance $_instanceId');
    return _cancelToken!;
  }

  /// Initialize the notifier - called when first created
  void initialize() {
    logger.d('[ResetNotifier] Initializing $_instanceId');
    // Nothing to initialize yet
  }

  /// Sets phone number and verification code from OTP flow
  void setPhone(String phone, String verificationCode) {
    state = state.copyWith(
      input: state.input.copyWith(
        verificationCode: verificationCode,
        phone: phone,
      ),
    );
    logger.d('[ResetNotifier] setPhone $_instanceId');
  }

  /// Handle password input change
  void onPasswordChanged(String password) {
    state = state.copyWith(
      input: state.input.copyWith(password: password),
    );
  }

  /// Handle confirm password input change
  void onConfirmPasswordChanged(String confirmPassword) {
    state = state.copyWith(
      input: state.input.copyWith(confirmPassword: confirmPassword),
    );
  }

  /// Resets password with validated input
  Future<void> resetPassword() async {
    // Validate input first
    if (!state.input.isValid()) {
      state = state.onValidationErrors(state.input.getErrorCase());
      return;
    }

    state = state.loading;

    try {
      final request = ResetPasswordRequest(
        phoneNumber: PhoneNumber(state.input.phone),
        mobileToken: state.input.verificationCode,
        password: state.input.password,
      );

      final result = await _repository.resetPassword(
        request,
        token: _createCancelToken(),
      );

      state = result.fold(state.onSuccess, state.onApiError);
    } catch (e) {
      logger.e('[ResetNotifier] Password reset failed: ${e.toString()}');
      state = state.onError(ResetError.unknown(e.toString()));
    }
  }
}
