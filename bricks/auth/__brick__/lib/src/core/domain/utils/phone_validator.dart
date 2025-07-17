/// Utilities for phone number validation
class PhoneValidator {
  /// Validates an international phone number
  ///
  /// Returns true if the phone number is valid
  static bool isValidInternational(String value) {
    final cleanValue = cleanPhoneNumber(value);
    if (cleanValue.isEmpty) return false;
    // Check for international format with reasonable length
    // Most international numbers are between 8 and 15 digits excluding country code
    return RegExp(r'^\+?[0-9]{8}$').hasMatch(cleanValue);
  }

  /// Validates a local phone number (8-11 digits)
  ///
  /// Returns true if the phone number is a valid local number
  static bool isValidLocal(String value) {
    if (value.isEmpty) return false;
    
    // Local numbers are 8-11 digits without country code
    final cleanNumber = value.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^[0-9]{8,11}$').hasMatch(cleanNumber);
  }

  /// Validates a Hong Kong phone number
  ///
  /// Returns true if the phone number is a valid Hong Kong number
  static bool isValidHongKong(String value) {
    if (value.isEmpty) return false;
    // Hong Kong phone numbers are 8 digits
    // And typically start with 2, 3, 5, 6, 8, or 9
    final cleanNumber = value.replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.length != 8) return false;
    return RegExp(r'^[235689]\d{7}$').hasMatch(cleanNumber);
  }

  /// Cleans a phone number by removing non-numeric characters except +
  static String cleanPhoneNumber(String value) {
    return value.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Formats a phone number for display
  ///
  /// Adds proper spacing and formatting based on number type
  static String format(String value) {
    if (value.isEmpty) return value;
    
    // Clean the number first
    final clean = cleanPhoneNumber(value);
    
    // If it's a Hong Kong number (8 digits)
    if (clean.length == 8) {
      return '${clean.substring(0, 4)} ${clean.substring(4)}';
    }
    
    // If it has country code with +
    if (clean.startsWith('+')) {
      if (clean.length > 4) {
        // Format with spaces after country code
        return '${clean.substring(0, 3)} ${clean.substring(3)}';
      }
    }
    
    // Default return with + if not present
    return clean.startsWith('+') ? clean : '+$clean';
  }
}