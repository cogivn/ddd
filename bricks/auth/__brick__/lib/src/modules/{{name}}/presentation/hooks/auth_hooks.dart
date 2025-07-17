import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/domain/constants/auth_validation_keys.dart';
import '../../application/auth_notifier/auth_notifier.dart';

/// Model class encapsulating all state and behavior for Auth login form
///
/// This model is returned by the [useAuthForm] hook and contains everything
/// needed to render and interact with the login form UI.
class AuthFormModel {
  /// Creates a model containing all state for auth login form
  ///
  /// All parameters are required as they represent crucial state for the login process
  const AuthFormModel({
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocus,
    required this.passwordFocus,
    required this.isFormValid,
    required this.isLoading,
    required this.onLogin,
    required this.phoneError,
    required this.passwordError,
    required this.onPhoneChanged,
    required this.onPasswordChanged,
  });

  /// Controller for the phone input field
  final TextEditingController phoneController;

  /// Controller for the password input field
  final TextEditingController passwordController;

  /// Focus node for the phone input field
  final FocusNode phoneFocus;

  /// Focus node for the password input field
  final FocusNode passwordFocus;

  /// Whether the form input is valid for submission
  final bool isFormValid;

  /// Whether an authentication request is in progress
  final bool isLoading;

  /// Function to submit the form
  final VoidCallback onLogin;

  /// Error message for the phone field, or null if no error
  final String? phoneError;

  /// Error message for the password field, or null if no error
  final String? passwordError;

  /// Callback for when the phone field value changes
  final Function(String) onPhoneChanged;

  /// Callback for when the password field value changes
  final Function(String) onPasswordChanged;
}

/// Custom hook that manages auth login form state and validation
///
/// This hook centralizes all logic related to the login form, including:
/// - Form validation
/// - Error handling
/// - Form submission
/// - Controller management
///
/// @param ref Riverpod reference to access state providers
/// @return [AuthFormModel] containing all state and functions for the UI
AuthFormModel useAuthForm(WidgetRef ref) {
  // Watch state from providers to trigger rebuilds when they change
  final context = useContext();
  final authState = ref.watch(authProvider);
  final authNotifier = ref.read(authProvider.notifier);

  // Create and manage text editing controllers and focus nodes
  // Create controllers without initial text to avoid recreation on every build
  final phoneController = useTextEditingController();
  final passwordController = useTextEditingController();
  final phoneFocus = useFocusNode();
  final passwordFocus = useFocusNode();

  // Sync controllers with state when state changes externally
  useEffect(() {
    phoneController.text = authState.input.phone;
    passwordController.text = authState.input.password;

    return null;
  }, [authState.input.phone, authState.input.password]);

  // Get error messages for each field using the utility methods
  final phoneError = ref.watch(authProvider.select((s) {
    return s.status.whenOrNull(
      error: (error) => error.getMessage(
        context,
        key: AuthValidationKeys.phone,
      ),
    );
  }));

  final passwordError = ref.watch(authProvider.select((s) {
    return s.status.whenOrNull(
      error: (error) => error.getMessage(
        context,
        key: AuthValidationKeys.password,
        includeOtherIssues: true,
      ),
    );
  }));

  return AuthFormModel(
    phoneController: phoneController,
    passwordController: passwordController,
    phoneFocus: phoneFocus,
    passwordFocus: passwordFocus,
    isFormValid: !authState.input.getErrorCase().isNotEmpty,
    isLoading: authState.isLoading,
    onLogin: authNotifier.login,
    phoneError: phoneError,
    passwordError: passwordError,
    onPhoneChanged: authNotifier.setPhone,
    onPasswordChanged: authNotifier.setPassword,
  );
}
