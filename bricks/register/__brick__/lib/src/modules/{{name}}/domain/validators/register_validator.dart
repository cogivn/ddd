import 'package:flutter/foundation.dart';

import '../../../../core/domain/value_objects/value_objects.dart';
import '../constants/register_validation_keys.dart';

/// Service for validating registration-related data with structured validation context
class RegisterValidator {
  /// Private constructor to prevent instantiation
  const RegisterValidator._();

  /// Returns list of error field keys based on validation context
  static List<String> getErrorFields(RegisterValidationContext context) {
    return RegisterValidationKeys.fields
        .where((fieldKey) => _isFieldInvalid(fieldKey, context))
        .toList();
  }

  /// Determines if a field is invalid based on its key and validation context
  static bool _isFieldInvalid(String fieldKey, RegisterValidationContext context) {
    return switch (fieldKey) {
      RegisterValidationKeys.password => _isPasswordInvalid(context.password),
      RegisterValidationKeys.confirmPassword => _isConfirmPasswordInvalid(context.password, context.confirmPassword),
      _ => false,
    };
  }

  /// Checks if the password is invalid
  static bool _isPasswordInvalid(String password) {
    return !Password.isValid(password);
  }

  /// Checks if the confirm password matches the original password
  static bool _isConfirmPasswordInvalid(String password, String confirmPassword) {
    return password != confirmPassword;
  }

  /// Checks if a registration form is valid based on context
  static bool isRegisterFormValid(RegisterValidationContext context) {
    return getErrorFields(context).isEmpty;
  }
}

/// A class to hold registration validation context information
@visibleForTesting
class RegisterValidationContext {
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterValidationContext({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}