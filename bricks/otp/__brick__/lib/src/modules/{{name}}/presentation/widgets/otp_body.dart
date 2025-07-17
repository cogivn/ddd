import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/otp_notifier/otp_notifier.dart';
import '../../domain/enums/otp_page_type.dart';
import 'otp_phone_body.dart';
import 'otp_verify_phone_body.dart';

/// Main body widget that handles the OTP flow using PageView
class OtpBody extends HookConsumerWidget {
  /// Creates the main OTP flow body with the specified page type
  ///
  /// The [pageType] parameter determines the context in which the OTP flow is used
  /// Default is [OtpPageType.registration]
  const OtpBody({
    super.key,
    required this.pageType,
    this.instruction,
  });

  /// The context in which this OTP flow is being used
  final OtpPageType pageType;
  final String? instruction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize page controller with physics that prevent manual swiping
    final pageController = usePageController();

    // Watch phone validation state to trigger navigation
    ref.listen(otpProvider.select((s) => s.status), (previous, current) {
      current.whenOrNull(
        phoneValidated: (_) {
          // Animate to verification page when phone is validated
          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        codeVerified: (_) => context.maybePop(true),
      );
    });

    return PageView(
      // Disable manual page swiping
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        // Phone input page
        OtpPhoneBody(pageType: pageType, instruction: instruction),
        // OTP verification page
        const OtpVerifyPhoneBody(),
      ],
    );
  }
}
