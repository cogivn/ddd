import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../otp/application/otp_notifier/otp_notifier.dart';
import '../../../otp/domain/enums/otp_page_type.dart';
import '../../../otp/presentation/pages/otp_phone_page.dart';
import '../../../otp/presentation/pages/otp_verify_phone_page.dart';
import '../../application/register_notifier/register_notifier.dart';
import '../pages/register_form_page.dart';
import '../pages/register_tnc_page.dart';

class RegisterBody extends HookConsumerWidget {
  const RegisterBody({
    super.key,
    required this.onPageChanged,
  });

  /// Callback triggered when the page index changes
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    useEffect(() {
      Future.microtask(ref.read(registerProvider.notifier).initialize);
      return null;
    }, []);
    // Watch OTP state for navigation
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
        // Phone validation page
        const OtpPhonePage(pageType: OtpPageType.registration),
        // OTP verification page
        const OtpVerifyPhonePage(),
        // Registration form
        const RegisterFormPage(),
      ],
    );
  }
}
