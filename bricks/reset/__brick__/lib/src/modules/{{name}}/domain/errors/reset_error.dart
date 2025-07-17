import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../constants/reset_validation_keys.dart';

part 'reset_error.freezed.dart';

/// Domain-specific error types for Reset Password process
///
/// This sealed class defines a hierarchy of error types that can occur during
/// the password reset process. It handles various failure scenarios including
/// API errors, database errors, validation errors, and unexpected errors.
/// 
/// Follows MCP-ddd-domain-layer: Define domain-specific error types
/// Follows MCP-ddd-error-handling: Use sealed classes for error hierarchies
@freezed
sealed class ResetError with _$ResetError {
  const ResetError._();

  /// Error related to API operations
  /// 
  /// Represents errors that occur during communication with the backend API,
  /// such as network failures, server errors, or invalid responses.
  /// 
  /// [error] Contains the detailed API error information
  const factory ResetError.api(ApiError error) = ResetApiError;

  /// Error related to Database operations
  /// 
  /// Represents errors that occur when interacting with local storage
  /// or database operations.
  /// 
  /// [message] A human-readable description of the database error
  const factory ResetError.db(String message) = ResetDbError;

  /// Unknown or unexpected errors
  /// 
  /// Represents errors that don't fit into other categories or
  /// unexpected exceptions that occur during the reset process.
  /// 
  /// [message] A human-readable description of the unknown error
  const factory ResetError.unknown(String message) = ResetUnknownError;

  /// Error when input validation fails
  /// 
  /// Represents validation errors for user input during the reset process,
  /// such as invalid password format or mismatched password confirmation.
  /// 
  /// [cases] A list of validation error keys identifying which validations failed
  const factory ResetError.input(List<String> cases) = ResetInputError;

  /// Gets the user-friendly error message associated with this error
  /// 
  /// Translates internal error representations into human-readable messages
  /// that can be displayed to the user in the UI.
  /// 
  /// [context] The build context used for localization
  /// [key] Optional specific error key to match against (for validation errors)
  /// [includeOtherIssues] Whether to include messages for non-input errors
  /// 
  /// Returns a localized error message string, or null if no message applies
  String? getMessage(
    BuildContext context, {
    String? key,
    bool includeOtherIssues = false,
  }) {
    return switch (this) {
      ResetInputError(cases: final cases) => cases.contains(key)
          ? switch (key) {
              ResetValidationKeys.password =>
                context.s.error_invalid_password,
              ResetValidationKeys.confirmPassword =>
                context.s.reset_passwords_do_not_match,
              _ => context.s.reset_generic_input_error,
            }
          : null,
      ResetDbError(message: final msg) when includeOtherIssues => msg,
      ResetApiError(error: final err) when includeOtherIssues => err.message,
      ResetUnknownError(message: final msg) when includeOtherIssues => msg,
      _ => null,
    };
  }
}