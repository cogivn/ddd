/// Constants defining the keys used for form validation in the Reset module
///
/// This class provides a centralized location for all validation keys used 
/// throughout the reset password flow. These keys are used to identify which
/// form fields have validation errors and to match error messages with the
/// appropriate form fields.
///
/// Follows MCP-ddd-domain-layer: Use constants for domain-specific string values
/// Follows MCP-ddd-validation: Centralize validation keys in constants
class ResetValidationKeys {
  // Private constructor to prevent instantiation
  ResetValidationKeys._();

  /// Key for phone number field validation
  /// 
  /// Used to identify validation errors related to the phone number input field,
  /// such as empty phone number or invalid format.
  static const String phone = 'phone';

  /// Key for password field validation
  /// 
  /// Used to identify validation errors related to the password input field,
  /// such as insufficient length, missing required characters, or invalid format.
  static const String password = 'password';

  /// Key for confirm password field validation
  /// 
  /// Used to identify validation errors related to the confirm password input field,
  /// such as when it doesn't match the original password field.
  static const String confirmPassword = 'confirmPassword';
}