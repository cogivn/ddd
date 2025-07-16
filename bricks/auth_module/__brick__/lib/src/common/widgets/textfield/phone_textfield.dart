import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizing/sizing.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart'; // Import for localization extensions
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'input_decoration.dart';
import 'textfield.dart';

/// A specialized text field for phone number input with automatic formatting.
///
/// This widget extends [AppTextField] to provide phone number specific functionality
/// like automatic spacing, phone icon, and validation. It's designed to match
/// the Android XML PhoneSpaceEditText implementation.
///
/// The phone number is automatically formatted with spaces according to
/// the selected format pattern (Hong Kong format by default).
class PhoneTextField extends StatelessWidget {
  /// Creates a phone text field with automatic formatting
  ///
  /// The [label] is displayed as the field label or placeholder.
  /// The [isEnabled] flag determines if the field is interactive.
  /// The [error] displays validation error messages below the field.
  const PhoneTextField({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.maxLength = 9,
    this.isEnabled = true,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.validator,
    this.autovalidateMode,
    this.showValidationIcon = false,
    this.readOnly = false,
    this.autoFocus = true,
    this.onTap,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.isValidated = false,
  });

  /// The label text displayed for this field
  final String label;
  
  /// Optional hint text displayed when the field is empty
  final String? hint;
  
  /// Optional error message displayed below the field
  final String? error;
  
  /// Maximum length of the phone number (default is 9)
  final int maxLength;
  
  /// Whether the text field is enabled and interactive
  final bool isEnabled;
  
  /// Whether the text field is read-only
  final bool readOnly;
  
  /// Callback triggered when the phone number changes (with formatting)
  final ValueChanged<String>? onChanged;
  
  /// Controller for the text field
  final TextEditingController? controller;
  
  /// Focus node for controlling the focus state
  final FocusNode? focusNode;
  
  /// Validator function for form validation
  final FormFieldValidator<String>? validator;
  
  /// Auto-validation mode for forms
  final AutovalidateMode? autovalidateMode;
  
  /// Whether to show validation icon when the input is valid
  final bool showValidationIcon;
  
  /// Callback triggered when the field is tapped
  final GestureTapCallback? onTap;
  
  /// Action button to display on the keyboard
  final TextInputAction textInputAction;
  
  /// Callback triggered when the user submits the field
  final ValueChanged<String>? onSubmitted;
  
  /// Whether the phone number has been validated
  final bool isValidated;

  /// Whether to auto-focus this field when displayed
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    final effectiveHint = hint;
    
    // Use dimmer colors for text and icons when disabled
    final textColor = ColorName.textPrimary;
    final iconColor = isEnabled ? ColorName.textPrimary : ColorName.textSecondary.withValues(alpha: 0.7);
        
    final decoration = UnderlineInputDecoration.styleFrom(
      context,
      labelText: label,
      helperText: null,
      hintText: effectiveHint,
      errorText: error,
      prefixIcon: Icon(Icons.phone, color: iconColor),
      suffixIcon: isValidated ? 
        const Icon(Icons.check_circle, color: Colors.green) :
        (showValidationIcon ? const Icon(Icons.error_outline, color: ColorName.textError) : null),
      fillColor: isEnabled ? Colors.transparent : ColorName.backgroundDisabled.withValues(alpha: .3),
      disabledColor: ColorName.line.withValues(alpha: .5),
      borderColor: ColorName.line,
    );

    // Create custom text style with appropriate dimming when disabled
    final textStyle = context.textTheme.medium.copyWith(
      fontSize: 16.fss,
      color: textColor,
    );

    return AppTextField(
      label: label,
      hint: effectiveHint,
      error: error,
      autoFocus: autoFocus,
      isEnabled: isEnabled,
      readOnly: readOnly,
      maxLength: maxLength,
      keyboardType: TextInputType.number,
      focusNode: focusNode,
      controller: controller,
      style: textStyle, // Apply the custom text style
      validator: validator ?? ((value) => _defaultValidator(context, value)),
      autovalidateMode: autovalidateMode,
      onTap: onTap,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        PhoneInputFormatter(defaultCountryCode: 'HK'),
      ],
      onChanged: onChanged,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: decoration,
    );
  }
  
  /// Default validator for phone input if none provided
  String? _defaultValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.s.common_phone_required;
    }
    
    return null;
  }
}