import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../application/reset_notifier/reset_notifier.dart';
import '../widgets/reset_body.dart';

/// Reset password flow page with multi-step process
///
/// This page manages the reset password flow with multiple steps:
/// - Page 0: Phone input and validation
/// - Page 1: Otp verification
/// - Page 1: Password reset form
///
/// The AppBar title changes dynamically based on the current step.
@RoutePage()
class ResetPage extends HookConsumerWidget {
  /// Creates a new instance of ResetPage
  const ResetPage({super.key});

  // Define page indices as constants to avoid magic numbers
  static const int _pagePhoneValidation = 0;
  static const int _pageOtpVerification = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState(_pagePhoneValidation);
    return Scaffold(
      appBar: BaseAppBar(
        titleText: _getTitleForPage(context, pageIndex.value),
        leading: BackButton(
          onPressed: context.maybePop,
        ),
      ),
      body: ProviderScope(
        overrides: [
          resetProvider.overrideWith(
            () => getIt<ResetNotifier>(),
          ),
        ],
        child: SafeArea(
          child: ResetBody(
            onPageChanged: (index) => pageIndex.value = index,
          ),
        ),
      ),
    );
  }

  /// Returns the appropriate localized title based on the current page index
  ///
  /// - For Phone validation page: "Reset Password"
  /// - For Password reset page: "Create New Password"
  String? _getTitleForPage(BuildContext context, int pageIndex) {
    return switch (pageIndex) {
      _pagePhoneValidation => context.s.reset_password,
      _pageOtpVerification => context.s.otp_verification,
      _ => null,
    };
  }
}