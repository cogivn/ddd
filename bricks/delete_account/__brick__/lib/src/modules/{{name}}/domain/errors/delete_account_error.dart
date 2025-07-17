import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../constants/delete_account_validation_keys.dart';

part 'delete_account_error.freezed.dart';


/// Domain-specific error types for Delete Account process
///
/// This sealed class defines a hierarchy of error types that can occur during
/// the account deletion process. It handles various failure scenarios including
/// API errors, database errors, validation errors, and unexpected errors.
///
/// Follows MCP-ddd-domain-layer: Define domain-specific error types
/// Follows MCP-ddd-error-handling: Use sealed classes for error hierarchies
@freezed
sealed class DeleteAccountError with _$DeleteAccountError {
  const DeleteAccountError._();

  /// Error related to API operations
  ///
  /// Represents errors that occur during communication with the backend API,
  /// such as network failures, server errors, or invalid responses.
  ///
  /// [error] Contains the detailed API error information
  const factory DeleteAccountError.api(ApiError error) = DeleteAccountApiError;

  /// Error related to Database operations
  ///
  /// Represents errors that occur when interacting with local storage
  /// or database operations.
  ///
  /// [message] A human-readable description of the database error
  const factory DeleteAccountError.db(String message) = DeleteAccountDbError;

  /// Unknown or unexpected errors
  ///
  /// Represents errors that don't fit into other categories or
  /// unexpected exceptions that occur during the delete account process.
  ///
  /// [message] A human-readable description of the unknown error
  const factory DeleteAccountError.unknown(String message) =
      DeleteAccountUnknownError;

  /// Error when input validation fails
  ///
  /// Represents validation errors for user input during the delete account process,
  /// such as empty reason or reason too short.
  ///
  /// [cases] A list of validation error keys identifying which validations failed
  const factory DeleteAccountError.input(List<String> cases) =
      DeleteAccountInputError;

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
      DeleteAccountInputError(cases: final cases) => cases.contains(key)
          ? switch (key) {
              DeleteAccountValidationKeys.reason =>
                context.s.delete_account_reason_invalid,
              _ => null,
            }
          : null,
      DeleteAccountApiError(error: final error) =>
        includeOtherIssues ? error.message : null,
      DeleteAccountDbError(message: final message) =>
        includeOtherIssues ? message : null,
      DeleteAccountUnknownError(message: final message) =>
        includeOtherIssues ? message : null,
    };
  }
}