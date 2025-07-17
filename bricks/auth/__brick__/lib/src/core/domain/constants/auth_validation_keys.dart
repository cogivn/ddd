/// Constants used for validation in the authentication flow
///
/// This class defines keys used to identify validation errors and field groupings
/// for different authentication forms.
///
/// Follows MCP-ddd-domain-layer: Use constants for validation keys
class AuthValidationKeys {
  /// Private constructor to prevent instantiation
  const AuthValidationKeys._();

  // Field validation keys
  /// Key for phone field validation errors
  static const String phone = 'phone';

  /// Key for password field validation errors
  static const String password = 'password';

  // Field groupings
  /// List of login form fields requiring validation
  static const List<String> loginFields = [
    phone,
    password,
  ];
}
