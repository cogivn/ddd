import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/constants/auth_validation_keys.dart';
import '../../../../core/domain/errors/api_error.dart';

part 'auth_error.freezed.dart';

/// Domain-specific error types for Authentication
///
/// This sealed class defines a hierarchy of error types that can occur during
/// the authentication process. It handles various failure scenarios including
/// API errors, validation errors, and unexpected errors.
///
/// Follows MCP-ddd-domain-layer: Define domain-specific error types
@freezed
sealed class AuthError with _$AuthError {
  const AuthError._();

  /// Error related to an invalid phone number
  ///
  /// [message] A human-readable description of the phone validation error
  const factory AuthError.phone(String message) = InvalidPhone;
  
  /// Error related to an invalid password
  ///
  /// [message] A human-readable description of the password validation error
  const factory AuthError.password(String message) = InvalidPassword;
  
  /// Error related to API operations
  ///
  /// [error] Contains the detailed API error information
  const factory AuthError.api(ApiError error) = ApiAuthError;
  
  /// Unknown or unexpected errors
  ///
  /// [message] A human-readable description of the unknown error
  const factory AuthError.unexpected(String message) = UnexpectedAuthError;

  /// Gets the user-friendly error message associated with this error
  ///
  /// Translates internal error representations into human-readable messages
  /// that can be displayed to the user in the UI.
  ///
  /// [context] The build context used for localization
  /// [key] Optional specific error key to match against (for validation errors)
  /// [includeOtherIssues] Whether to include messages for non-field errors
  ///
  /// Returns a localized error message string, or null if no message applies
  String? getMessage(
    BuildContext context, {
    String? key,
    bool includeOtherIssues = false,
  }) {
    return switch (this) {
      InvalidPhone(message: final message) =>
        key == AuthValidationKeys.phone ? message : null,
      InvalidPassword(message: final message) =>
        key == AuthValidationKeys.password ? message : null,
      ApiAuthError(error: final error) =>
        includeOtherIssues ? error.message : null,
      UnexpectedAuthError(message: final message) =>
        includeOtherIssues ? message : null,
    };
  }
}
