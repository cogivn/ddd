import 'package:flutter/material.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/theme/text_theme_interfaces.dart';

/// Text styles extension for the Auth module
extension AuthTextStyles on TextThemeFactory {
  /// Style for the forgot password text button
  TextStyle get forgotPasswordStyle => medium.copyWith(
        color: ColorName.textSecondary,
        fontSize: 14,
      );

  /// Style for the signup prompt text button
  TextStyle get signupPromptStyle => medium.copyWith(
        color: ColorName.textSecondary,
        fontSize: 14,
        height: 1.5,
      );
}