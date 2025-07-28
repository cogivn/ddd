import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../constants/register_validation_keys.dart';

part 'register_error.freezed.dart';

/// Domain-specific error types for Register process
@freezed
sealed class RegisterError with _$RegisterError {
  const RegisterError._();

  /// Error related to API operations
  const factory RegisterError.api(ApiError error) = RegisterApiError;

  /// Error related to Database operations
  const factory RegisterError.db(String message) = RegisterDbError;

  /// Unknown or unexpected errors
  const factory RegisterError.unknown(String message) = RegisterUnknownError;

  /// Error when input validation fails
  const factory RegisterError.input(List<String> cases) = RegisterInputError;

  /// Gets the error message associated with this error
  String? getMessage(
    BuildContext context, {
    String? key,
    bool includeOtherIssues = false,
  }) {
    return switch (this) {
      RegisterInputError(cases: final cases) => cases.contains(key)
          ? switch (key) {
              RegisterValidationKeys.password =>
                context.s.error_invalid_password,
              RegisterValidationKeys.confirmPassword =>
                context.s.register_passwords_do_not_match,
              _ => context.s.register_generic_input_error,
            }
          : null,
      RegisterDbError(message: final msg) when includeOtherIssues => msg,
      RegisterApiError(error: final err) when includeOtherIssues => err.message,
      RegisterUnknownError(message: final msg) when includeOtherIssues => msg,
      _ => null,
    };
  }
}