import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/converters/phone_number_converter.dart';
import '../../../../core/domain/value_objects/value_objects.dart';
import '../enums/otp_page_type.dart';
import '../value_objects/verification_code.dart';
import '../converters/verification_code_converter.dart';

part 'otp_request.freezed.dart';
part 'otp_request.g.dart';

/// Base class for all OTP-related requests
@freezed
sealed class OtpRequest with _$OtpRequest {
  const OtpRequest._();

  /// Creates a phone validation request
  const factory OtpRequest.phoneValidation({
    /// The phone number to validate
    @PhoneNumberConverter()
    @JsonKey(name: 'mobile_number')
    required PhoneNumber phoneNumber,

    /// Page type context for this request
    @JsonKey(name: 'page_type')
    required OtpPageType pageType,
  }) = PhoneValidationRequest;

  /// Creates an OTP verification request
  const factory OtpRequest.verify({
    /// The phone number to verify
    @JsonKey(name: 'mobile_no')
    @PhoneNumberConverter()
    required PhoneNumber phoneNumber,

    /// The verification code to verify
    @VerificationCodeConverter()
    @JsonKey(name: 'mobile_token')
    required VerificationCode verificationCode,

    /// Page type context for this request
    @JsonKey(name: 'page_type')
    required OtpPageType pageType,
  }) = OtpVerificationRequest;

  /// Creates an OTP resend request
  const factory OtpRequest.resend({
    /// The phone number to resend the OTP to
    @JsonKey(name: 'mobile_number')
    @PhoneNumberConverter()
    required PhoneNumber phoneNumber,

    /// Page type context for this request
    @JsonKey(name: 'page_type')
    required OtpPageType pageType,
  }) = OtpResendRequest;

  /// Creates an OtpRequest from JSON
  factory OtpRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestFromJson(json);
}