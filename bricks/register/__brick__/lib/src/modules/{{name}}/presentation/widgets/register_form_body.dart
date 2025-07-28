import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizing/sizing.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/size_x.dart';
import '../../../../common/widgets/widgets.dart';
import '../hooks/register_hooks.dart';

class RegisterFormBody extends HookConsumerWidget {
  const RegisterFormBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the custom hook for form state management
    final formModel = useRegisterForm(ref);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(32.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LastStepMessage(),
            16.verticalSpace,
            const _RegisterHeader(),
            30.verticalSpace,
            _RegisterForm(formModel: formModel),
          ],
        ),
      ),
    );
  }
}

class _LastStepMessage extends StatelessWidget {
  const _LastStepMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.s.register_last_step_message,
        textAlign: TextAlign.center,
        style: context.textTheme.medium.copyWith(
          fontSize: 16.fss,
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.s.register_title,
          style: context.textTheme.bold.copyWith(
            color: ColorName.secondary,
            fontSize: 28.fss,
          ),
        ),
        LayoutBuilder(
          // Follows MCP-DART-LAMBDA-001: Short widget builders
          builder: (ctx, constraint) => Container(
            width: constraint.maxWidth * .6,
            color: ColorName.secondary,
            height: 3.ss,
          ),
        ),
      ],
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({required this.formModel});

  final RegisterFormModel formModel;

  // Keep this as a named method since it contains multiple operations
  void _handleSubmit() {
    // Dismiss keyboard before submission
    FocusManager.instance.primaryFocus?.unfocus();
    // Execute the form submission
    formModel.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone number display
          _PhoneNumberDisplay(phoneNumber: formModel.phoneNumber),
          20.verticalSpace,

          // Password fields
          PasswordTextField(
            autoFocus: true,
            controller: formModel.passwordController,
            label: context.s.register_password,
            hint: context.s.auth_password_hint,
            helper: context.s.error_invalid_password,
            isEnabled: !formModel.isLoading,
            textInputAction: TextInputAction.next,
            error: formModel.passwordError,
            // Follows MCP-DART-LAMBDA-001: Use arrow functions for focus management
            onEditingComplete: FocusScope.of(context).nextFocus,
          ),
          16.verticalSpace,

          // Confirm password field
          PasswordTextField(
            autoFocus: true,
            controller: formModel.confirmPasswordController,
            label: context.s.register_confirm_password,
            hint: context.s.auth_confirm_password_hint,
            isEnabled: !formModel.isLoading,
            textInputAction: TextInputAction.done,
            error: formModel.confirmPasswordError,
            onEditingComplete: _handleSubmit,
          ),
          30.verticalSpace,

          // Register button
          SolidButton(
            text: context.s.register_submit,
            // Follows MCP-DART-LAMBDA-001: Direct method reference when signatures match
            onPressed: _handleSubmit,
            isLoading: formModel.isLoading,
          ),
        ],
      ),
    );
  }
}

class _PhoneNumberDisplay extends HookWidget {
  const _PhoneNumberDisplay({required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final phoneController = useTextEditingController(text: phoneNumber);

    return PhoneTextField(
      label: context.s.common_phone_label,
      controller: phoneController,
      readOnly: true,
      isEnabled: false,
      autoFocus: false,
      isValidated: true, // Show validation check mark
    );
  }
}
