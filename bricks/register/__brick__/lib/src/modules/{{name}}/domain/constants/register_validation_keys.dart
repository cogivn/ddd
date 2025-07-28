/// Keys for validation fields in the registration process
class RegisterValidationKeys {
  static const String password = 'password';
  static const String confirmPassword = 'confirmPassword';

  /// List of all fields to validate during registration
  static const List<String> fields = [
    password,
    confirmPassword,
  ];
}