part of '../pages/auth_page.dart';

/// AuthBody widget serves as the main container for the authentication UI
/// Following the widget modularization pattern from Flutter guidance
/// by breaking complex UI into separate internal widgets (_LoginHeader, _LoginForm, _SignUpSection)
class AuthBody extends HookConsumerWidget {
  const AuthBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          // Login form using form hook for state management
          const _LoginForm(),
          // Signup section as a separate component for better maintainability
          const _SignUpSection(),
        ],
      ),
    );
  }
}

/// Private internal widget for the login header section
/// Following the principle of breaking UI into smaller, focused components
/// This improves maintainability and makes the code easier to understand
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Using localization for text content
        Text(
          context.s.auth_login_title,
          style: context.textTheme.bold.copyWith(
            color: ColorName.secondary,
            fontSize: 28.sp,
          ),
        ),
        // Using LayoutBuilder for responsive design
        // This follows the Flutter guidance on creating adaptive UI
        LayoutBuilder(
          builder: (ctx, constraint) => Container(
            width: constraint.maxWidth * .6,
            color: ColorName.secondary,
            height: 3.h,
          ),
        ),
      ],
    );
  }
}

/// Login form component that manages user input and validation
/// Uses HookConsumerWidget for state management with hooks and provider
/// This follows the Flutter guidance on state management
class _LoginForm extends HookConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using custom hook for form state management
    // This aligns with the "Parent-Managed State" pattern from Flutter guidance
    final formModel = useAuthForm(ref);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Using custom form field components for consistent UI and behavior
        // This follows the "Composition over Inheritance" principle
        PhoneTextField(
          autoFocus: false,
          label: context.s.auth_phone_label,
          hint: context.s.auth_phone_hint,
          error: formModel.phoneError,
          controller: formModel.phoneController,
          focusNode: formModel.phoneFocus,
          onChanged: formModel.onPhoneChanged,
          isEnabled: !formModel.isLoading,
          textInputAction: TextInputAction.next,
          // Improving user experience with focus management
          onSubmitted: (_) => formModel.passwordFocus.requestFocus(),
        ),
        PasswordTextField(
          label: context.s.auth_password_label,
          hint: context.s.auth_password_hint,
          error: formModel.passwordError,
          controller: formModel.passwordController,
          focusNode: formModel.passwordFocus,
          onChanged: formModel.onPasswordChanged,
          isEnabled: !formModel.isLoading,
          textInputAction: TextInputAction.done,
        ),
        12.verticalSpace,
        FlatButton(
          alignment: Alignment.centerRight,
          text: context.s.auth_forgot_password,
          color: ColorName.textSecondary,
          textStyle: context.textTheme.forgotPasswordStyle,
          onPressed: () {
            // Navigate to reset password page
            //TODO context.pushRoute(ResetRoute());
          },
        ),
        30.verticalSpace,
        // Action button with loading state handling
        // This demonstrates handling different UI states in a widget
        SolidButton(
          text: context.s.auth_login_button,
          onPressed: formModel.onLogin,
          isLoading: formModel.isLoading,
          isEnabled: true,
        ),
      ],
    );
  }
}

/// Sign up section component
/// Extracted as a separate widget to improve code organization
/// This follows the "Extract Widget Method Pattern" from Flutter guidance
class _SignUpSection extends StatelessWidget {
  const _SignUpSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        text: context.s.auth_signup_prompt,
        textAlign: TextAlign.center,
        color: ColorName.textSecondary,
        textStyle: context.textTheme.signupPromptStyle,
        //TODO: onPressed: () => context.pushRoute(RegisterRoute()),
      ),
    );
  }
}
