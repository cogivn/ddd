import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizing/sizing.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/size_x.dart';
import '../../../../common/widgets/widgets.dart';
import '../../domain/enums/otp_page_type.dart';
import '../hooks/otp_hooks.dart';

/// Body widget for the OTP phone verification page
/// Uses hooks for state management and side effects
class OtpPhoneBody extends HookConsumerWidget {
  /// Creates the OTP phone input body with the specified page type
  ///
  /// The [pageType] parameter determines the context in which the OTP flow is used
  /// Default is [OtpPageType.registration]
  const OtpPhoneBody({
    super.key,
    required this.pageType,
    this.instruction,
  });

  /// The context in which this OTP flow is being used
  final OtpPageType pageType;
  final String? instruction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use custom hook to manage state and side effects with the specified page type
    final state = useOtpPhone(ref, pageType: pageType);
    final defaultMsg = context.s.otp_phone_verification_instructions;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.ss, vertical: 24.ss),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PhoneInstructions(
            pageType: pageType,
            instruction: instruction ?? defaultMsg,
          ),
          24.0.verticalSpace,
          PhoneTextField(
            controller: state.phoneController,
            label: context.s.otp_phone_number,
            error: state.phoneError.value,
            onChanged: state.validatePhone,
          ),
          32.0.verticalSpace,
          SolidButton(
            text: context.s.otp_send_code,
            isLoading: state.isLoading,
            isEnabled: state.isButtonEnabled.value,
            onPressed: state.onSubmit,
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying phone verification instructions
class _PhoneInstructions extends StatelessWidget {
  const _PhoneInstructions({
    required this.pageType,
    required this.instruction,
  });

  /// The context in which this OTP flow is being used
  final OtpPageType pageType;
  final String instruction;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textTheme.medium,
        children: [TextSpan(text: instruction)],
      ),
    );
  }
}
