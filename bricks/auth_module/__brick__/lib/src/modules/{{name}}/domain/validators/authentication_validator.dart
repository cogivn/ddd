import 'package:flutter/foundation.dart';

import '../../../../core/domain/constants/auth_validation_keys.dart';
import '../../../../core/domain/value_objects/value_objects.dart';

/// Context object that holds the data to be validated for authentication
///
/// This class encapsulates all form input values that need validation during
/// the authentication flow, providing a clean way to pass validation data.
/// 
/// Follows MCP-ddd-domain-layer: Use context objects for validation data
@visibleForTesting
class AuthValidationContext {
  /// Creates a validation context for authentication forms
  /// 
  /// [phone] The phone number entered by the user
  /// [password] The password entered by the user
  /// [formType] The type of form being validated (default: login)
  const AuthValidationContext({
    required this.phone,
    required this.password,
    this.formType = 'login',
  });

  /// Phone number to be validated
  final String phone;
  
  /// Password to be validated
  final String password;
  
  /// The type of form being validated (login/register)
  final String formType;
}

/// Validator for authentication form inputs
///
/// This utility class provides static methods to validate user input
/// during the authentication process. It follows a functional approach
/// with pure validation functions that don't maintain state.
///
/// Follows MCP-ddd-domain-layer: Implement domain validators for business rules
/// Follows MCP-ddd-validation: Use static methods for pure validation functions
class AuthenticationValidator {
  /// Private constructor to prevent instantiation
  const AuthenticationValidator._();

  /// Returns list of error field keys based on validation context
  ///
  /// Performs all validations based on the provided context and returns
  /// a list of field keys that failed validation.
  ///
  /// [context] The validation context containing all form values
  /// 
  /// Returns a list of field keys that failed validation
  static List<String> getErrorFields(AuthValidationContext context) {
    return AuthValidationKeys.loginFields
        .where((fieldKey) => _isFieldInvalid(fieldKey, context))
        .toList();
  }

  /// Determines if a field is invalid based on its key and validation context
  ///
  /// [fieldKey] The key of the field to validate
  /// [context] The validation context containing all form values
  /// 
  /// Returns true if the field is invalid, false otherwise
  static bool _isFieldInvalid(String fieldKey, AuthValidationContext context) {
    return switch (fieldKey) {
      AuthValidationKeys.phone => _isPhoneInvalid(context.phone),
      AuthValidationKeys.password => _isPasswordInvalid(context.password),
      _ => false,
    };
  }

  /// Checks if the phone number is invalid
  ///
  /// [phone] The phone number to validate
  /// 
  /// Returns true if phone is invalid, false otherwise
  static bool _isPhoneInvalid(String phone) {
    if (phone.isEmpty) {
      return true;
    }
    
    return !PhoneNumber.isValid(phone);
  }

  /// Checks if the password is invalid
  ///
  /// [password] The password to validate
  /// 
  /// Returns true if password is invalid, false otherwise
  static bool _isPasswordInvalid(String password) {
    return !Password.isValid(password);
  }

  /// Checks if a login form is valid based on context
  ///
  /// [context] The validation context containing all form values
  /// 
  /// Returns true if all validations pass, false otherwise
  static bool isLoginFormValid(AuthValidationContext context) {
    return getErrorFields(context).isEmpty;
  }
  
  /// Checks if a field should be validated based on form type
  ///
  /// [fieldKey] The key of the field to check
  /// 
  /// Returns true if the field should be validated, false otherwise
  static bool isFieldRequired(String fieldKey) {
    return AuthValidationKeys.loginFields.contains(fieldKey);
  }
}
