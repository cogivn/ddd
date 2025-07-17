import '../utils/otp_validator.dart';

/// Value object representing a valid OTP verification code
class VerificationCode {
  /// The validated verification code
  final String value;
  
  /// Creates a verification code value object with validation
  /// 
  /// Throws [ArgumentError] if the verification code format is invalid
  factory VerificationCode(String value) {
    final cleanedValue = OtpValidator.format(value);
    if (!isValidVerificationCode(cleanedValue)) {
      throw ArgumentError('Invalid verification code format: $value');
    }
    return VerificationCode._internal(cleanedValue);
  }
  
  /// Internal constructor to create a verification code without validation
  const VerificationCode._internal(this.value);

  /// Validates a verification code format
  /// 
  /// Returns true if the format is valid, false otherwise
  static bool isValidVerificationCode(String value) {
    return OtpValidator.isValid(value);
  }
  
  @override
  String toString() => value;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationCode && other.value == value;
  }
  
  @override
  int get hashCode => value.hashCode;
}