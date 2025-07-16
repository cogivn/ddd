import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart'; // Import for localization extensions
import 'input_decoration.dart';
import 'textfield.dart';

/// A specialized text field for password input with visibility toggle
///
/// This widget extends the functionality of a standard text field to provide
/// secure password entry with a toggle to show/hide the entered text.
/// It follows the design system's styling guidelines with an underline style
/// and handles all password-specific behaviors automatically.
///
/// The [label] is displayed as the field label or placeholder.
/// The [showPasswordIcon] and [hidePasswordIcon] can be customized for the visibility toggle.
/// The [prefixIcon] allows customizing the icon displayed at the start of the field.
/// The [error] displays validation error messages below the field.
///
/// Example usage:
/// ```dart
/// PasswordTextField(
///   label: 'Password',
///   helper: 'At least 8 characters with 1 number',
///   onChanged: (value) => passwordController.onPasswordChanged(value),
///   error: state.passwordError,
///   showPasswordIcon: Icon(Icons.visibility_outlined),
///   hidePasswordIcon: Icon(Icons.visibility_off_outlined),
/// )
/// ```
class PasswordTextField extends HookWidget {
  /// Creates a password text field with toggle visibility functionality
  ///
  /// The [label] parameter is required and displayed as the field label.
  /// Other parameters provide customization options for the field's appearance and behavior.
  const PasswordTextField({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.helper,
    this.showPasswordIcon,
    this.hidePasswordIcon,
    this.prefixIcon,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.keyboardType,
    this.onChanged,
    this.cursorColor,
    this.isEnabled = true,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.onTapOutside,
    this.validator,
    this.autovalidateMode,
    this.onEditingComplete,
  });

  /// The label text displayed for this field
  final String label;

  /// Optional hint text displayed when the field is empty
  final String? hint;

  /// Optional helper text displayed below the field
  final String? helper;

  /// Optional error message displayed below the field
  final String? error;

  /// Whether the field is enabled and interactive
  final bool isEnabled;

  /// Whether to auto-focus this field when displayed
  final bool autoFocus;

  /// Custom icon for the "show password" state (password is hidden)
  final Widget? showPasswordIcon;

  /// Custom icon for the "hide password" state (password is visible)
  final Widget? hidePasswordIcon;

  /// Custom icon displayed at the start of the text field
  final Widget? prefixIcon;

  /// Focus node for controlling the focus state
  final FocusNode? focusNode;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Callback triggered when the user submits the field
  final ValueChanged<String>? onSubmitted;

  /// Action button to display on the keyboard
  final TextInputAction textInputAction;

  /// Callback triggered when the text changes
  final ValueChanged<String>? onChanged;

  /// Keyboard type to display for this field
  final TextInputType? keyboardType;

  /// Color of the text cursor
  final Color? cursorColor;

  /// Callback when user taps outside the field
  final TapRegionCallback? onTapOutside;

  /// Validator function for form validation
  final FormFieldValidator<String>? validator;

  /// Auto-validation mode for forms
  final AutovalidateMode? autovalidateMode;
  
  /// Callback triggered when editing is complete (e.g. user presses "next" or "done")
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);

    // Use localized hint text if no custom hint is provided
    final effectiveHint = hint;

    // Default prefix icon is a lock
    final defaultPrefixIcon = const Icon(Icons.lock, color: ColorName.textPrimary);

    final decoration = UnderlineInputDecoration.styleFrom(
      context,
      labelText: label,
      helperText: helper,
      helperMaxLines: 2,
      hintText: effectiveHint,
      errorText: error,
      prefixIcon: Focus(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        child: prefixIcon ?? defaultPrefixIcon,
      ),
      fillColor: isEnabled
          ? Colors.transparent
          : ColorName.backgroundDisabled.withValues(alpha: .3),
      disabledColor: ColorName.line.withValues(alpha: .5),
      borderColor: ColorName.line,
      suffixIcon: Focus(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        child: _SuffixIcon(
          obscureText: obscureText,
          showPasswordIcon: showPasswordIcon,
          hidePasswordIcon: hidePasswordIcon,
          context: context,
        ),
      ),
    );

    return AppTextField(
      label: label,
      hint: effectiveHint,
      error: error,
      helper: helper,
      autoFocus: autoFocus,
      keyboardType: keyboardType ?? TextInputType.visiblePassword,
      onChanged: onChanged,
      obscureText: obscureText.value,
      obscuringCharacter: '●',
      focusNode: focusNode,
      controller: controller,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      onTapOutside: onTapOutside,
      maxLines: 1,
      isEnabled: isEnabled,
      cursorColor: cursorColor ?? ColorName.primary,
      decoration: decoration,
      validator: validator ?? (value) => _defaultValidator(context, value),
      autovalidateMode: autovalidateMode,
    );
  }

  /// Default validator for password input if none provided
  String? _defaultValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.s.common_password_required;
    }

    return null;
  }
}

/// Private widget to handle the password visibility toggle button
class _SuffixIcon extends StatelessWidget {
  const _SuffixIcon({
    required this.obscureText,
    required this.context,
    this.showPasswordIcon,
    this.hidePasswordIcon,
  });

  /// State notifier for password visibility
  final ValueNotifier<bool> obscureText;

  /// Build context for localization
  final BuildContext context;

  /// Icon shown when password is hidden (to show the password)
  final Widget? showPasswordIcon;

  /// Icon shown when password is visible (to hide the password)
  final Widget? hidePasswordIcon;

  @override
  Widget build(BuildContext context) {
    final defaultShowIcon =
        const Icon(Icons.visibility_outlined, color: ColorName.textSecondary);
    final defaultHideIcon = const Icon(Icons.visibility_off_outlined,
        color: ColorName.textSecondary);

    final suffixIcon = obscureText.value
        ? (showPasswordIcon ?? defaultShowIcon)
        : (hidePasswordIcon ?? defaultHideIcon);

    // Get localized accessibility label based on current state
    final String tooltipText = obscureText.value
        ? context.s.common_password_show
        : context.s.common_password_hide;

    return IconButton(
      onPressed: () => obscureText.value = !obscureText.value,
      icon: suffixIcon,
      tooltip: tooltipText,
      focusColor: ColorName.primary.withValues(alpha: 0.1),
      hoverColor: ColorName.primary.withValues(alpha: 0.05),
      splashColor: ColorName.primary.withValues(alpha: 0.1),
    );
  }
}
