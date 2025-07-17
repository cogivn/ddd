import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/errors/api_error.dart';

part 'otp_error.freezed.dart';

/// Domain-specific error types for OTP validation and verification
@freezed
sealed class OtpError with _$OtpError {
  const OtpError._();

  /// Error related to phone number validation
  const factory OtpError.phone(String message) = PhoneError;

  /// Error related to verification code validation
  const factory OtpError.verification(String message) = VerificationError;

  /// Error from API operations
  const factory OtpError.api(ApiError error) = OtpApiError;

  /// Unknown or unexpected errors
  const factory OtpError.unknown(String message) = UnknownError;

  String get message {
    return switch (this) {
      PhoneError(message: final msg) => msg,
      VerificationError(message: final msg) => msg,
      OtpApiError(error: final err) => err.message,
      UnknownError(message: final msg) => msg,
    };
  }
}
