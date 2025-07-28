import 'package:flutter/foundation.dart';
import '../../../../../../generated/l10n.dart';
import '../constants/auth_validation_keys.dart';

/// Represents a validated password in the domain
@immutable
class Password {
  /// The validated password value
  final String value;

  /// Minimum length requirement for passwords
  static const int minLength = 8;
  
  /// Maximum length requirement for passwords
  static const int maxLength = 15;

  /// Private constructor to enforce validation through factory constructor
  const Password._internal(this.value);

  /// Creates a new [Password] if the provided value is valid
  ///
  /// Throws [ArgumentError] if the password is invalid
  factory Password(String value) {
    if (!Password.isValid(value)) {
      throw ArgumentError(
        S.current.error_invalid_password,
        AuthValidationKeys.password,
      );
    }
    return Password._internal(value);
  }

  /// Checks if the provided string is a valid password
  static bool isValid(String value) {
    // Fallback: Global best practices (no MCP rule found)
    // 8-15 chars, at least one uppercase, one lowercase, one digit, symbols allowed
    final RegExp pattern = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,15}');
    return pattern.hasMatch(value);
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return isValid(password) && password == confirmPassword;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Password && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  // We don't include the actual password in toString for security reasons
  @override
  String toString() => 'Password(*****)';
}
