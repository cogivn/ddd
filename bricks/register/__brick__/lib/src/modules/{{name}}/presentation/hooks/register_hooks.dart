import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../otp/application/otp_notifier/otp_notifier.dart';
import '../../application/register_notifier/register_notifier.dart';
import '../../domain/constants/register_validation_keys.dart';

/// Model class encapsulating all state and behavior for Register form
///
/// This model is returned by the [useRegisterForm] hook and contains everything
/// needed to render and interact with the registration form UI.
class RegisterFormModel {
  /// Creates a model containing all state for registration form
  ///
  /// All parameters are required as they represent crucial state for the registration process
  const RegisterFormModel({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isFormValid,
    required this.isLoading,
    required this.phoneNumber,
    required this.onSubmit,
    required this.passwordError,
    required this.confirmPasswordError,
  });

  /// Controller for the password input field
  final TextEditingController passwordController;

  /// Controller for the confirm password input field
  final TextEditingController confirmPasswordController;

  /// Whether the form input is valid for submission
  final bool isFormValid;

  /// Whether a registration request is in progress
  final bool isLoading;

  /// The phone number that was previously validated
  final String phoneNumber;

  /// Function to submit the form
  final VoidCallback onSubmit;

  /// Function to get localized password error message using a BuildContext
  final String? passwordError;

  /// Function to get localized confirm password error message using a BuildContext
  final String? confirmPasswordError;
}

/// Custom hook that manages register form state and validation
///
/// This hook centralizes all logic related to the registration form, including:
/// - Form validation
/// - Error handling
/// - Form submission
/// - Controller management
///
/// @param ref Riverpod reference to access state providers
/// @return [RegisterFormModel] containing all state and functions for the UI
RegisterFormModel useRegisterForm(WidgetRef ref) {
  // Watch state from providers to trigger rebuilds when they change
  final context = useContext();
  final otpState = ref.watch(otpProvider);
  final registerNotifier = ref.read(registerProvider.notifier);

  // Extract register input state
  final input = ref.watch(registerProvider.select((s) => s.input));

  // Form controllers
  final passwordController = useTextEditingController();
  final cPasswordController = useTextEditingController();

  // Form states
  final phone = otpState.input.phone;
  final verificationCode = otpState.input.verificationCode ?? '';

  // Set phone and verification code in the register state
  useEffect(() {
    Future.microtask(() {
      registerNotifier.setPhone(phone, verificationCode);
    });
    return null;
  }, [phone, verificationCode]);

  // Handle text field changes and validate
  useEffect(() {
    // Define listeners for password and confirm password fields
    void onPasswordChanged() {
      if (passwordController.text != input.password) {
        registerNotifier.onPasswordChanged(passwordController.text);
      }
    }

    void onConfirmPasswordChanged() {
      if (cPasswordController.text != input.cPassword) {
        registerNotifier.onConfirmPasswordChanged(cPasswordController.text);
      }
    }

    // Add listeners for both controllers
    passwordController.addListener(onPasswordChanged);
    cPasswordController.addListener(onConfirmPasswordChanged);

    return () {
      // Clean up listeners
      passwordController.removeListener(onPasswordChanged);
      cPasswordController.removeListener(onConfirmPasswordChanged);
    };
  }, [passwordController, cPasswordController, input]);

  // Return model with all the required state and functions
  return RegisterFormModel(
    passwordController: passwordController,
    confirmPasswordController: cPasswordController,
    isFormValid: ref.watch(registerProvider.select((s) {
      return s.input.isValid() && !s.hasErrors;
    })),
    isLoading: ref.watch(registerProvider.select((s) => s.isLoading)),
    phoneNumber: phone,
    onSubmit: registerNotifier.register,
    passwordError: ref.watch(registerProvider.select((s) {
      final pwdKey = RegisterValidationKeys.password;
      return s.status.whenOrNull(
        error: (err) => err.getMessage(context, key: pwdKey),
      );
    })),
    confirmPasswordError: ref.watch(registerProvider.select((s) {
      final cPwdKey = RegisterValidationKeys.confirmPassword;
      return s.status.whenOrNull(
        error: (err) => err.getMessage(
          context,
          includeOtherIssues: true,
          key: cPwdKey,
        ),
      );
    })),
  );
}
