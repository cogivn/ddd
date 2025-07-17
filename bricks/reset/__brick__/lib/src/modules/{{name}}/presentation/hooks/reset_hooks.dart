import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../otp/application/otp_notifier/otp_notifier.dart';
import '../../application/reset_notifier/reset_notifier.dart';
import '../../domain/constants/reset_validation_keys.dart';

/// Model class encapsulating all state and behavior for Reset Password form
///
/// This model is returned by the [useResetPasswordForm] hook and contains everything
/// needed to render and interact with the password reset form UI.
class ResetPasswordFormModel {
  /// Creates a model containing all state for reset password form
  ///
  /// All parameters are required as they represent crucial state for the reset password process
  const ResetPasswordFormModel({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isFormValid,
    required this.isLoading,
    required this.phoneNumber,
    required this.onSubmit,
    required this.passwordError,
    required this.confirmPasswordError,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  /// Controller for the password input field
  final TextEditingController passwordController;

  /// Controller for the confirm password input field
  final TextEditingController confirmPasswordController;

  /// Whether the form input is valid for submission
  final bool isFormValid;

  /// Whether a password reset request is in progress
  final bool isLoading;

  /// The phone number that was previously validated
  final String phoneNumber;

  /// Function to submit the form
  final VoidCallback onSubmit;

  /// Function to get localized password error message using a BuildContext
  final String? passwordError;

  /// Function to get localized confirm password error message using a BuildContext
  final String? confirmPasswordError;

  /// Callback for when the password field value changes
  final Function(String) onPasswordChanged;

  /// Callback for when the confirm password field value changes
  final Function(String) onConfirmPasswordChanged;
}

/// Custom hook that manages reset password form state and validation
///
/// This hook centralizes all logic related to the password reset form, including:
/// - Form validation
/// - Error handling
/// - Form submission
/// - Controller management
///
/// @param ref Riverpod reference to access state providers
/// @return [ResetPasswordFormModel] containing all state and functions for the UI
ResetPasswordFormModel useResetPasswordForm(WidgetRef ref) {
  // Watch state from providers to trigger rebuilds when they change
  final context = useContext();
  final otpState = ref.watch(otpProvider.select((s) => s.input));
  final resetState = ref.watch(resetProvider);
  final resetNotifier = ref.read(resetProvider.notifier);

  // Form controllers
  final passwordController = useTextEditingController();
  final confirmPasswordController = useTextEditingController();

  // Form states
  final phone = otpState.phone;
  final verificationCode = otpState.verificationCode ?? '';

  // Set phone and verification code in the reset state
  useEffect(() {
    Future.microtask(() {
      resetNotifier.setPhone(phone, verificationCode);
    });
    return null;
  }, [phone, verificationCode]);

  // Handle text field changes and validate
  useEffect(() {
    // Define listeners for password and confirm password fields
    void onPasswordChanged() {
      if (passwordController.text != resetState.input.password) {
        resetNotifier.onPasswordChanged(passwordController.text);
      }
    }

    void onConfirmPasswordChanged() {
      if (confirmPasswordController.text != resetState.input.confirmPassword) {
        resetNotifier.onConfirmPasswordChanged(confirmPasswordController.text);
      }
    }

    // Add listeners
    passwordController.addListener(onPasswordChanged);
    confirmPasswordController.addListener(onConfirmPasswordChanged);

    // Clean up
    return () {
      passwordController.removeListener(onPasswordChanged);
      confirmPasswordController.removeListener(onConfirmPasswordChanged);
    };
  }, []);

  return ResetPasswordFormModel(
    passwordController: passwordController,
    confirmPasswordController: confirmPasswordController,
    isFormValid: ref.watch(resetProvider.select((s) {
      return s.input.isValid() && !s.hasErrors;
    })),
    isLoading: ref.watch(resetProvider.select((s) => s.isLoading)),
    phoneNumber: phone,
    onSubmit: resetNotifier.resetPassword,
    passwordError: ref.watch(resetProvider.select((s) {
      return s.status.maybeWhen(
        error: (error) => error.getMessage(
          context,
          key: ResetValidationKeys.password,
        ),
        orElse: () => null,
      );
    })),
    confirmPasswordError: ref.watch(resetProvider.select((s) {
      return s.status.maybeWhen(
        error: (error) => error.getMessage(
          context,
          key: ResetValidationKeys.confirmPassword,
        ),
        orElse: () => null,
      );
    })),
    onPasswordChanged: resetNotifier.onPasswordChanged,
    onConfirmPasswordChanged: resetNotifier.onConfirmPasswordChanged,
  );
}
