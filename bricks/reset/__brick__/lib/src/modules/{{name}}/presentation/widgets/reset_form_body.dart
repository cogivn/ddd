import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/widgets.dart';
import '../hooks/reset_hooks.dart';

class ResetFormBody extends HookConsumerWidget {
  const ResetFormBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the reset form hook to get all required form state
    final formModel = useResetPasswordForm(ref);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title and instructions
          Text(
            context.s.reset_create_new_password,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            context.s.reset_password_instructions,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Form fields and submit button
          _ResetForm(formModel: formModel),
        ],
      ),
    );
  }
}

/// Internal widget that encapsulates the reset password form fields and submission button
///
/// This follows the project pattern of separating the form fields and submission logic
/// into a dedicated internal widget.
class _ResetForm extends StatelessWidget {
  const _ResetForm({required this.formModel});

  /// The model containing all state and callbacks for the form
  final ResetPasswordFormModel formModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Password field
        PasswordTextField(
          label: context.s.reset_password,
          hint: context.s.reset_password_hint,
          controller: formModel.passwordController,
          error: formModel.passwordError,
          onChanged: formModel.onPasswordChanged,
          onEditingComplete: FocusScope.of(context).nextFocus,
        ),
        const SizedBox(height: 16),

        // Confirm password field
        PasswordTextField(
          label: context.s.reset_confirm_password,
          hint: context.s.reset_confirm_password_hint,
          controller: formModel.confirmPasswordController,
          error: formModel.confirmPasswordError,
          onChanged: formModel.onConfirmPasswordChanged,
        ),
        const SizedBox(height: 32),

        // Submit button
        SolidButton(
          text: context.s.reset_submit,
          onPressed: formModel.onSubmit,
          isLoading: formModel.isLoading,
        ),
      ],
    );
  }
}
