import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../otp/application/otp_notifier/otp_notifier.dart';
import '../../../otp/domain/enums/otp_page_type.dart';
import '../../../otp/presentation/pages/otp_phone_page.dart';
import '../../../otp/presentation/pages/otp_verify_phone_page.dart';
import '../pages/reset_form_page.dart';

/// Body component that manages the reset password flow with a PageView
class ResetBody extends HookConsumerWidget {
  /// Creates a new instance of ResetBody
  ///
  /// [onPageChanged] is called when the page index changes
  const ResetBody({
    super.key,
    required this.onPageChanged,
  });

  /// Callback for when the page index changes
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controller for PageView
    final pageController = usePageController();

    ref.listen(
      otpProvider.select((s) => s.status),
          (previous, current) {
        current.whenOrNull(
          phoneValidated: (_) {
            // When phone is validated, go to verify page
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          codeVerified: (_) {
            // When code is verified, go to registration form
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        );
      },
    );

    return PageView(
      controller: pageController,
      // Disable manual swiping
      physics: const NeverScrollableScrollPhysics(),
      // Use the built-in onPageChanged callback
      onPageChanged: onPageChanged,
      children: [
        // Phone input page using OTP module with forgotPassword page type
        const OtpPhonePage(pageType: OtpPageType.forgotPassword),
        // Phone validation page
        const OtpVerifyPhonePage(),
        // Password reset page
        const ResetFormPage(),
      ],
    );
  }
}
