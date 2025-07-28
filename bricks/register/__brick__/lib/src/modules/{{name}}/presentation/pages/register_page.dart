import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/appbar_action.dart';
import '../../application/register_notifier/register_notifier.dart';
import '../widgets/register_body.dart';

/// Registration process page with multi-step flow
///
/// This page manages the registration flow with multiple steps:
/// - Page 0: Terms & Conditions (RegisterTncPage)
/// - Page 1: Phone validation (OtpPhonePage)
/// - Page 2: OTP verification (OtpVerifyPhonePage)
/// - Page 3: Registration form (RegisterFormPage)
///
/// The AppBar title changes dynamically based on the current step.
@RoutePage()
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  // Define page indices as constants to avoid magic numbers
  static const int _pagePhoneValidation = 0;
  static const int _pageOtpVerification = 1;
  static const int _pageRegistrationForm = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState(_pagePhoneValidation);
    return Scaffold(
      appBar: BaseAppBar(
        leading: AppBarAction.back(onPressed: context.maybePop),
      ),
      body: ProviderScope(
        overrides: [
          registerProvider.overrideWith(
            () => getIt<RegisterNotifier>(),
          ),
        ],
        child: SafeArea(
          child: RegisterBody(
            onPageChanged: (index) => pageIndex.value = index,
          ),
        ),
      ),
    );
  }
}
