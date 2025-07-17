part of 'otp_notifier.dart';

// Define input data class for OTP flow
@freezed
abstract class OtpInput with _$OtpInput {
  const factory OtpInput({
    @Default('') String phone,
    String? verificationCode,
    @Default(OtpPageType.registration) OtpPageType pageType,
  }) = _OtpInput;
}


@freezed
abstract class OtpStatus with _$OtpStatus {
  // Initial state when the flow starts
  const factory OtpStatus.initial() = _InitialStatus;

  // User is on phone input screen
  const factory OtpStatus.phoneInput(OtpInput data) = _PhoneInputStatus;

  // User is on OTP verification screen and actively inputting code
  const factory OtpStatus.codeInput(OtpInput data) = _CodeInputStatus;

  // User has entered code and it's being validated
  const factory OtpStatus.verifyingCode() = _VerifyingCodeStatus;

  // Loading states for API calls
  const factory OtpStatus.validatingPhone() = _ValidatingPhoneStatus;

  const factory OtpStatus.resendingCode() = _ResendingCodeStatus;

  // Success states
  const factory OtpStatus.phoneValidated(MobileVerification data) =
      _PhoneValidatedStatus;

  const factory OtpStatus.codeVerified(OtpVerification data) =
      _CodeVerifiedStatus;

  // Error states
  const factory OtpStatus.error(OtpError err) = _ErrorStatus;
}

@freezed
abstract class OtpState with _$OtpState {
  const OtpState._();

  const factory OtpState({
    @Default(_InitialStatus()) OtpStatus status,
    @Default(OtpInput()) OtpInput input,
  }) = _OtpState;
}

extension OtpStateX on OtpState {
  // Status checking helpers
  bool get isInitial => status is _InitialStatus;

  bool get isPhoneInput => status is _PhoneInputStatus;

  bool get isCodeInput => status is _CodeInputStatus;

  bool get isValidatingPhone => status is _ValidatingPhoneStatus;

  bool get isVerifyingCode => status is _VerifyingCodeStatus;

  bool get isResendingCode => status is _ResendingCodeStatus;

  bool get isPhoneValidated => status is _PhoneValidatedStatus;

  bool get isCodeVerified => status is _CodeVerifiedStatus;

  bool get isError => status is _ErrorStatus;

  // General loading state check
  bool get isLoading => isValidatingPhone || isVerifyingCode || isResendingCode;

  // Get verification result if available
  OtpVerification? get verificationResult => status.maybeWhen(
    codeVerified: (verification) => verification,
    orElse: () => null,
  );

  // Phone input phase
  OtpState onSetPhone(String phone) {
    final newInput = input.copyWith(phone: phone);
    return copyWith(
      status: OtpStatus.phoneInput(newInput),
      input: newInput,
    );
  }

  // OTP code input phase
  OtpState onSetVerificationCode(String code) {
    final newInput = input.copyWith(verificationCode: code);
    return copyWith(
      status: OtpStatus.codeInput(newInput),
      input: newInput,
    );
  }

  // Page type setting
  OtpState onSetPageType(OtpPageType pageType) => copyWith(
        input: input.copyWith(pageType: pageType),
      );

  OtpState onValidatePhoneStart() => copyWith(
        status: const OtpStatus.validatingPhone(),
      );

  OtpState onPhoneValidated(MobileVerification data) => copyWith(
      status: OtpStatus.phoneValidated(data),
      input: input.copyWith(verificationCode: data.mobileToken));

  OtpState onPhoneError(String message) => copyWith(
        status: OtpStatus.error(OtpError.phone(message)),
      );

  OtpState onVerifyCodeStart() => copyWith(
        status: const OtpStatus.verifyingCode(),
      );

  OtpState onCodeVerified(OtpVerification data) => copyWith(
        status: OtpStatus.codeVerified(data),
      );

  OtpState onCodeError(String message) => copyWith(
        status: OtpStatus.error(OtpError.verification(message)),
      );

  // Resend functionality
  OtpState onResendStart() => copyWith(
        status: const OtpStatus.resendingCode(),
      );

  OtpState onResendSuccess(MobileVerification data) {
    final newInput = input.copyWith(verificationCode: data.mobileToken);
    return copyWith(status: OtpStatus.codeInput(newInput), input: newInput);
  }

  // API error handling
  OtpState onApiError(ApiError error) => copyWith(
        status: OtpStatus.error(OtpError.api(error)),
      );

  // Access current page type
  OtpPageType? get currentPageType => input.pageType;

  // Reset to initial state
  OtpState reset() => const OtpState();
}
