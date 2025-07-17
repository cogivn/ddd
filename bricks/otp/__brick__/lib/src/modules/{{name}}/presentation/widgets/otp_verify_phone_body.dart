import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/size_x.dart';
import '../../../../common/widgets/widgets.dart';
import '../../application/otp_notifier/otp_notifier.dart';
import '../../domain/enums/otp_page_type.dart';
import '../../domain/utils/otp_validator.dart';
import '../extensions/pinput_x.dart';
import '../hooks/otp_hooks.dart';

/// Body widget for the OTP verification page.
/// Displays OTP input fields, countdown timer for resend,
/// and confirm button for verification.
class OtpVerifyPhoneBody extends HookConsumerWidget {
  /// Body widget for the OTP verification page.
  /// Displays OTP input fields, countdown timer for resend,
  /// and confirm button for verification.
  const OtpVerifyPhoneBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useOtpVerify(ref);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.ss, vertical: 24.ss),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _VerificationInstructions(
              phoneNumber: state.phoneNumber,
              pageType: state.pageType,
            ),
            24.verticalSpace,
            _OtpInputFields(
              controller: state.otpController,
              focusNode: state.focusNode,
              error: state.error.value,
            ),
            32.verticalSpace,
            _ResendCodeSection(
              controller: state.countdownController,
              onResend: () => _handleResendOtp(
                ref,
                state.countdownController,
                state.phoneNumber,
                state.pageType,
              ),
            ),
            24.verticalSpace,
            SolidButton(
              text: context.s.confirm,
              isLoading: state.isLoading,
              onPressed: () => _handleVerifyOtp(
                context: context,
                ref: ref,
                otpCode: state.otpController.text,
                errorState: state.error,
                phoneNumber: state.phoneNumber,
                pageType: state.pageType,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Display instructions for OTP verification
class _VerificationInstructions extends StatelessWidget {
  const _VerificationInstructions({
    required this.phoneNumber, 
    required this.pageType,
  });

  final String phoneNumber;
  final OtpPageType pageType;

  @override
  Widget build(BuildContext context) {
    // Get appropriate title and instructions based on page type
    String instructions = context.s.otp_verification_instructions;
    
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodyMedium,
        children: [
          TextSpan(
            text: instructions,
          ),
          TextSpan(text: '\n\n'),
          TextSpan(
            text: phoneNumber,
            style: context.textTheme.regular.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// OTP input fields using Pinput
class _OtpInputFields extends ConsumerWidget {
  const _OtpInputFields({
    required this.controller,
    required this.focusNode,
    this.error,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Pinput.builder(
          length: 4,
          controller: controller,
          focusNode: focusNode,
          crossAxisAlignment: CrossAxisAlignment.center,
          builder: (_, pinState) => _PinItem(state: pinState),
          pinputAutovalidateMode: PinputAutovalidateMode.disabled,
          separatorBuilder: (_) => const SizedBox(width: 20),
          onChanged: ref.read(otpProvider.notifier).setVerificationCode,
        ),
        if (error != null) ...[
          8.verticalSpace,
          Text(
            error!,
            style: context.textTheme.bodySmall.copyWith(
              color: ColorName.textError,
            ),
          ),
        ],
      ],
    );
  }
}

class _PinItem extends StatelessWidget {
  const _PinItem({required this.state});

  final PinItemState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.ss,
      height: 56.ss,
      child: Center(
        child: Column(
          children: [
            Expanded(child: _PinValue(state: state)),
            _PinCursor(state: state),
          ],
        ),
      ),
    );
  }
}

class _PinValue extends StatelessWidget {
  const _PinValue({required this.state});

  final PinItemState state;

  @override
  Widget build(BuildContext context) {
    return Text(
      state.value,
      textScaler: TextScaler.noScaling,
      style: context.textTheme.regular.copyWith(
        color: state.type.maybeWhen(
          error: () => ColorName.textError,
          orElse: () => null,
        ),
        fontSize: 32.fss,
      ),
    );
  }
}

class _PinCursor extends StatelessWidget {
  const _PinCursor({required this.state});

  final PinItemState state;

  @override
  Widget build(BuildContext context) {
    return state.type.maybeWhen(
      error: () => const _Cursor(color: ColorName.textError),
      focused: () => const _AnimatedCursor(
        cursor: _Cursor(color: ColorName.primary),
      ),
      orElse: () => const _Cursor(),
    );
  }
}

class _Cursor extends StatelessWidget {
  const _Cursor({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 56.ss,
        height: 2.ss,
        decoration: BoxDecoration(
          color: color ?? ColorName.line,
        ),
      ),
    );
  }
}

class _AnimatedCursor extends HookWidget {
  final Widget? cursor;

  const _AnimatedCursor({required this.cursor});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 450),
    );

    useEffect(() {
      animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animationController.repeat(reverse: true);
        }
      });
      animationController.forward();
      return null;
    }, []);

    return FadeTransition(
      opacity: animationController,
      child: cursor,
    );
  }
}

/// Resend code section with countdown timer
class _ResendCodeSection extends StatelessWidget {
  const _ResendCodeSection({
    required this.controller,
    required this.onResend,
  });

  final CountdownController controller;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Countdown(
        seconds: 60,
        controller: controller,
        builder: (context, remaining) {
          final isCompleted = controller.isCompleted;
          return FlatButton(
            text: context.s.otp_resend_code_with_timer(remaining.toInt()),
            onPressed: isCompleted ? onResend : null,
            isEnabled: isCompleted,
          );
        },
      ),
    );
  }
}

// Helper functions for OTP verification logic
void _handleVerifyOtp({
  required BuildContext context,
  required WidgetRef ref,
  required String otpCode,
  required ValueNotifier<String?> errorState,
  required String phoneNumber,
  required OtpPageType pageType,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  if (_validateOtp(context, otpCode, errorState)) {
    ref.read(otpProvider.notifier).verifyOtp(
          phoneNumber,
          otpCode,
          pageType: pageType,
        );
  }
}

void _handleResendOtp(
  WidgetRef ref,
  CountdownController controller,
  String phoneNumber,
  OtpPageType pageType,
) {
  controller.restart();
  ref.read(otpProvider.notifier).resendOtp(
        phoneNumber,
        pageType: pageType,
      );
}

bool _validateOtp(
  BuildContext context,
  String otp,
  ValueNotifier<String?> errorState,
) {
  if (!OtpValidator.isValidWithLength(otp, 4)) {
    errorState.value = context.s.otp_invalid_code;
    return false;
  }
  return true;
}
