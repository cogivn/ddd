import 'dart:async';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../../generated/l10n.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/domain/value_objects/value_objects.dart';
import '../../domain/entities/mobile_verification.dart';
import '../../domain/entities/otp_verification.dart';
import '../../domain/enums/otp_page_type.dart';
import '../../domain/errors/otp_error.dart';
import '../../domain/models/otp_request.dart';
import '../../domain/repositories/otp_repository.dart';
import '../../domain/value_objects/verification_code.dart';

part 'otp_notifier.freezed.dart';
part 'otp_state.dart';

// Please note that when the [otpProvider] widget is used in the widget tree,
// it lacks the post-verification function. If you require the post-verification
// function, consider using the [OtpPage] widget, which provides the
// [otpProvider] with the post-verification function.

// OR override the provider with a custom function using
// otpProvider.overrideWith(() => getIt<OtpNotifier>(param1: PostVerificationParam(function: yourFunction)));
// with your own risk.
@ProviderFor(OtpNotifier)
final otpProvider = AutoDisposeNotifierProvider<OtpNotifier, OtpState>(
  () => getIt<OtpNotifier>(param1: const PostVerificationParam()),
);

/// Factory parameter for post-verification function
class PostVerificationParam {
  /// The function to call after OTP verification
  ///
  /// This function should be created using [PostVerificationFactory] to ensure
  /// proper dependency injection and avoid capturing unnecessary dependencies.
  final PostVerificationFunction? function;
  /// The custom verify OTP function to override default verify logic
  final VerifyOtpFunction? customVerifyOtpFunction;

  const PostVerificationParam({this.function, this.customVerifyOtpFunction});
}

@injectable
class OtpNotifier extends AutoDisposeNotifier<OtpState> {
  final OtpRepository _repository;
  CancelToken? _cancelToken;
  final String _instanceId = const Uuid().v4();

  /// Creates a new OTP notifier with optional post-verification function
  ///
  /// The [param] contains an optional [PostVerificationFunction] that will be called
  /// after successful OTP verification. The function should be created using
  /// [PostVerificationFactory] to ensure proper dependency injection.
  @factoryMethod
  static OtpNotifier create(
    OtpRepository repository, {
    @factoryParam PostVerificationParam? param,
  }) {
    final notifier = OtpNotifier._(repository);
    // Set the post-verification function if provided
    notifier.setPostVerificationFunction(param?.function);
    // Set the custom verify OTP function if provided
    notifier.setVerifyOtpFunction(param?.customVerifyOtpFunction);
    return notifier;
  }

  OtpNotifier._(this._repository) {
    logger.d('[OtpNotifier] Created new instance $_instanceId');
  }

  @override
  OtpState build() {
    logger.d('[OtpNotifier] Build called for instance $_instanceId');

    ref.onDispose(() {
      logger.d('[OtpNotifier] Disposing instance $_instanceId');
      // Cancel any ongoing requests when the notifier is disposed
      _cancelOngoingRequests();
      setPostVerificationFunction(null);
      setVerifyOtpFunction(null);
    });

    return const OtpState();
  }

  /// Cancels any ongoing API requests
  void _cancelOngoingRequests() {
    if (_cancelToken != null) {
      logger.d('[OtpNotifier] Cancelling requests for instance $_instanceId');
      _cancelToken?.cancel('Notifier was disposed');
      _cancelToken = null;
    }
  }

  /// Creates a new cancel token for API requests
  CancelToken _createCancelToken() {
    _cancelOngoingRequests();
    _cancelToken = CancelToken();
    logger.d('[OtpNotifier] Created new cancel token '
        'for instance $_instanceId');
    return _cancelToken!;
  }

  /// Resets the OTP state to initial values
  void resetOtpState() {
    state = state.reset();
  }

  /// Sets the phone number in the state and clears any previous error
  void setPhoneNumber(String phoneNumber) {
    state = state.onSetPhone(phoneNumber);
  }

  /// Sets the verification code in the state and clears any previous error
  void setVerificationCode(String code) {
    // Use Future.microtask to avoid updating state during build phase
    Future.microtask(() {
      state = state.onSetVerificationCode(code);
    });
  }

  /// Sets the page type in the state
  void setPageType(OtpPageType pageType) {
    state = state.onSetPageType(pageType);
  }

  /// Sets a post-verification function that will be called after successful OTP verification
  ///
  /// The function will be passed to the repository and called after OTP verification succeeds.
  /// It can modify the verification result or perform additional operations.
  void setPostVerificationFunction(PostVerificationFunction? function) {
    logger.d('[OtpNotifier] Setting post-verification '
        'function for instance $_instanceId');
    _repository.setPostVerificationFunction(function);
  }

  /// Sets a custom verify OTP function that will be called instead of the default logic
  void setVerifyOtpFunction(VerifyOtpFunction? function) {
    _repository.setVerifyOtpFunction(function);
  }

  /// Validates a phone number and requests an OTP code
  Future<void> validatePhoneNumber(
    String phoneNumberStr, {
    required OtpPageType pageType,
  }) async {
    logger.d('[OtpNotifier] validatePhoneNumber '
        'called on instance $_instanceId');
    try {
      // Update phone number and page type in state
      setPhoneNumber(phoneNumberStr);
      setPageType(pageType);

      // Create domain value object
      final phoneNumber = PhoneNumber(phoneNumberStr);

      // Update state to validating phone
      state = state.onValidatePhoneStart();

      // Create domain request model with page type
      final request = OtpRequest.phoneValidation(
        phoneNumber: phoneNumber,
        pageType: pageType,
      );

      final response = await _repository.validatePhone(
        request,
        token: _createCancelToken(),
      );

      state = response.fold(state.onPhoneValidated, state.onApiError);
    } catch (e) {
      logger.e('[OtpNotifier] Error in validatePhoneNumber: $e');
      // Handle validation errors from value objects
      state = state.onPhoneError(S.current.otp_error_invalid_phone);
    }
  }

  /// Verifies an OTP code for a given phone number
  Future<void> verifyOtp(
    String phoneNumberStr,
    String verificationCodeStr, {
    required OtpPageType pageType,
  }) async {
    try {
      // Create domain value objects
      final phoneNumber = PhoneNumber(phoneNumberStr);
      final verificationCode = VerificationCode(verificationCodeStr);

      // Update state to verifying code
      state = state.onVerifyCodeStart();

      // Create domain request model with page type
      final request = OtpRequest.verify(
        phoneNumber: phoneNumber,
        verificationCode: verificationCode,
        pageType: pageType,
      );

      final response = await _repository.verifyOtp(
        request,
        token: _createCancelToken(),
      );

      state = response.fold(state.onCodeVerified, state.onApiError);
    } catch (e) {
      // Handle validation errors from value objects
      state = state.onCodeError(S.current.otp_error_code_invalid);
    }
  }

  /// Resends an OTP code to the given phone number
  Future<void> resendOtp(
    String phoneNumberStr, {
    required OtpPageType pageType,
  }) async {
    try {
      // Create domain value object
      final phoneNumber = PhoneNumber(phoneNumberStr);
      setPageType(pageType);

      // Update state to resending
      state = state.onResendStart();

      // Create domain request model with page type
      final request = OtpRequest.resend(
        phoneNumber: phoneNumber,
        pageType: pageType,
      );

      final response = await _repository.resendOtp(
        request,
        token: _createCancelToken(),
      );

      state = response.fold(state.onResendSuccess, state.onApiError);
    } catch (e) {
      // Handle validation errors from value objects
      state = state.onApiError(
        ApiError.internal(S.current.otp_error_server),
      );
    }
  }
}
