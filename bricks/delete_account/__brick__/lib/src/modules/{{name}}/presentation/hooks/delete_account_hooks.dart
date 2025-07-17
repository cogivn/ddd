import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/delete_account_notifier/delete_account_notifier.dart';
import '../../domain/constants/delete_account_validation_keys.dart';

/// Model class encapsulating all state and behavior for Delete Account form
///
/// This model is returned by the [useDAReasonForm] hook and contains everything
/// needed to render and interact with the delete account form UI.
///
/// Follows MCP-ddd-presentation-layer: Encapsulate form state in models
class DAReasonModel {
  /// Creates a model containing all state for delete account form
  ///
  /// All parameters are required as they represent crucial state for the delete account process
  const DAReasonModel({
    required this.controller,
    required this.isFormValid,
    required this.reasonError,
    required this.onReasonChanged,
  });

  /// Controller for the reason input field
  final TextEditingController controller;

  /// Whether the form input is valid for submission
  final bool isFormValid;

  /// Error message for the reason field, or null if no error
  final String? reasonError;

  /// Callback to handle reason text changes
  final ValueChanged<String> onReasonChanged;
}

/// Custom hook that manages delete account form state and validation
///
/// This hook centralizes all logic related to the delete account form, including:
/// - Form validation
/// - Error handling
/// - Form submission
/// - Controller management
///
/// Follows MCP-ddd-presentation-layer: Use hooks for UI state management
/// Follows MCP-ddd-presentation-layer: Separate state management from UI
///
/// @param ref Riverpod reference to access state providers
/// @return [DAReasonModel] containing all state and functions for the UI
DAReasonModel useDAReasonForm(WidgetRef ref) {
  // Watch state from providers to trigger rebuilds when they change
  final context = useContext();
  final notifier = ref.read(deleteAccountProvider.notifier);

  // Create and manage text editing controllers
  final reasonController = useTextEditingController();

  // Return the model with all required properties
  return DAReasonModel(
    controller: reasonController,
    isFormValid: ref.watch(deleteAccountProvider.select((s) {
      return s.input.isReasonValid() && !s.hasErrors;
    })),
    onReasonChanged: notifier.onReasonChanged,
    reasonError: ref.watch(deleteAccountProvider.select((s) {
      return s.status.whenOrNull(
        error: (error) => error.getMessage(
          context,
          key: DeleteAccountValidationKeys.reason,
        ),
      );
    })),
  );
}

/// Model class encapsulating all state and behavior for Delete Account form
///
/// This model is returned by the [useDAConfirmReasonForm] hook and contains everything
/// needed to render and interact with the delete account form UI.
///
/// Follows MCP-ddd-presentation-layer: Encapsulate form state in models
class DAConfirmReasonModel {
  /// Creates a model containing all state for delete account form
  ///
  /// All parameters are required as they represent crucial state for the delete account process
  const DAConfirmReasonModel({
    required this.controller,
    required this.isValid,
    required this.isLoading,
    required this.onSubmit,
    required this.reasonError,
    required this.onConfirmReasonChanged,
  });

  /// Controller for the reason input field
  final TextEditingController controller;

  /// Whether the form input is valid for submission
  final bool isValid;

  /// Whether the form is loading
  final bool isLoading;

  /// Function to call when the form should be submitted
  final Future<void> Function() onSubmit;

  /// Error message for the reason field, or null if no error
  final String? reasonError;

  /// Callback to handle reason text changes
  final ValueChanged<String> onConfirmReasonChanged;
}

/// Custom hook that manages delete account form state and validation
DAConfirmReasonModel useDAConfirmReasonForm(WidgetRef ref) {
  // Watch state from providers to trigger rebuilds when they change
  final context = useContext();
  final notifier = ref.read(deleteAccountProvider.notifier);

  // Create and manage text editing controllers
  final reasonController = useTextEditingController();

  // Return the model with all required properties
  return DAConfirmReasonModel(
    controller: reasonController,
    isValid: ref.watch(deleteAccountProvider.select((s) {
      return s.input.isConfirmReasonValid() && !s.hasErrors;
    })),
    onSubmit: notifier.submit,
    isLoading: ref.watch(deleteAccountProvider.select((s) => s.isLoading)),
    onConfirmReasonChanged: notifier.onConfirmReasonChanged,
    reasonError: ref.watch(deleteAccountProvider.select((s) {
      return s.status.whenOrNull(
        error: (error) => error.getMessage(
          context,
          key: DeleteAccountValidationKeys.reason,
        ),
      );
    })),
  );
}
