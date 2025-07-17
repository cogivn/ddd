import '../constants/delete_account_validation_keys.dart';

/// Context object that holds the data to be validated for delete account process
///
/// This class encapsulates all form input values that need validation during
/// the account deletion flow, providing a clean way to pass validation data.
///
/// Follows MCP-ddd-domain-layer: Use context objects for validation data
class DeleteAccountValidationContext {
  /// Creates a validation context for account deletion form
  ///
  /// [reason] The reason provided by the user for account deletion
  const DeleteAccountValidationContext({
    required this.reason,
    required this.confirmReason,
  });

  /// Reason for account deletion to be validated
  final String reason;
  final String confirmReason;
}

/// Validator for delete account form inputs
///
/// This utility class provides methods to validate user input
/// during the account deletion process. It follows a functional approach
/// with pure validation functions that don't maintain state.
///
/// Follows MCP-ddd-domain-layer: Implement domain validators for business rules
/// Follows MCP-ddd-validation: Use static methods for pure validation functions
class DeleteAccountValidator {
  // Private constructor to prevent instantiation
  const DeleteAccountValidator();

  /// Validates if reason is not empty and meets minimum length
  ///
  /// Basic validation to ensure a reason was provided and meets minimum requirements.
  ///
  /// [reason] The reason to validate
  ///
  /// Returns true if reason is valid, false otherwise
  bool validateReason(String reason) {
    // Reason must not be empty and must be at least 5 characters long
    return reason.isNotEmpty && reason.length >= 20;
  }

  /// Validates if confirm reason is DELETE or not
  ///
  /// This is a specific validation to ensure the user
  /// confirms the deletion action by providing the correct confirmation reason.
  bool validateConfirmReason(String confirmReason) {
    return confirmReason == 'DELETE';
  }

  /// Gets all validation error field keys
  ///
  /// Performs all validations and returns a list of field keys
  /// that failed validation. This is used to highlight specific
  /// form fields that need correction.
  ///
  /// [context] The validation context containing all form values
  ///
  /// Returns a list of field keys that failed validation
  List<String> validate(DeleteAccountValidationContext context) {
    final List<String> errorFields = [];

    // Validate reason
    if (!validateReason(context.reason)) {
      errorFields.add(DeleteAccountValidationKeys.reason);
    }

    // Validate confirm reason
    if (!validateConfirmReason(context.confirmReason)) {
      errorFields.add(DeleteAccountValidationKeys.confirmReason);
    }

    return errorFields;
  }
}
