/// Utility class for validating OTP codes
class OtpValidator {
  /// Validates if the given OTP is a valid numeric code
  ///
  /// Returns true if the OTP contains only digits and has the expected length
  static bool isValidWithLength(String otp, int length) {
    if (otp.isEmpty || otp.length != length) {
      return false;
    }

    // Check if the OTP contains only numeric characters
    final otpRegex = RegExp(r'^[0-9]+$');
    return otpRegex.hasMatch(otp);
  }

  /// Validates if the given OTP is a valid 6-digit code
  ///
  /// Returns true if the OTP contains only digits and is 4 characters long
  static bool isValid(String otp) {
    return isValidWithLength(otp, 4);
  }
  
  /// Formats the OTP code by removing any non-digit characters
  /// 
  /// This helps normalize input by stripping spaces, dashes, or other separators
  /// that users might enter when inputting OTP codes.
  /// 
  /// Returns a clean string containing only digits
  static String format(String otp) {
    // Remove all non-digit characters
    return otp.replaceAll(RegExp(r'[^0-9]'), '');
  }
}