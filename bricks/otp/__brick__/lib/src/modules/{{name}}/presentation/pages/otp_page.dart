import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../application/otp_notifier/otp_notifier.dart';
import '../../domain/enums/otp_page_type.dart';
import '../../domain/repositories/otp_repository.dart';
import '../widgets/otp_body.dart';

/// Main OTP flow page with PageView for phone input and verification
@RoutePage()
class OtpPage extends ConsumerWidget {
  /// Creates an OTP flow page for various contexts (registration, password reset, etc.).
  ///
  /// Parameters:
  /// [pageType] - Specifies the OTP flow context (e.g., registration, password reset, update info, card binding). Defaults to registration.
  /// [instructions] - Optional instructions string to display to the user.
  /// [onPostVerification] - Optional callback executed after successful OTP verification, allowing custom post-processing of the verification result.
  /// [onVerifyOtp] - Optional custom function to override the default OTP verification logic. If provided, this function will be called instead of the default API call, but state/status updates remain unchanged. Useful for integrating with external SDKs, testing, or custom flows.
  const OtpPage({
    super.key,
    this.pageType = OtpPageType.registration,
    this.instructions,
    this.onPostVerification,
    this.onVerifyOtp,
  });

  /// Specifies the OTP flow context (registration, password reset, etc.)
  final OtpPageType pageType;

  /// Optional instructions string to display to the user
  final String? instructions;

  /// Callback executed after successful OTP verification for custom post-processing
  final PostVerificationFunction? onPostVerification;

  /// Custom function to override the default OTP verification logic
  /// If provided, this will be used instead of the default API call
  final VerifyOtpFunction? onVerifyOtp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        // Override the OTP notifier provider with the current page type
        otpProvider.overrideWith(
          () => getIt<OtpNotifier>(
            param1: PostVerificationParam(
              function: onPostVerification,
              customVerifyOtpFunction: onVerifyOtp,
            ),
          ),
        ),
      ],
      child: Scaffold(
        appBar: BaseAppBar(
          titleText: context.s.otp_phone_verification,
          leading: AutoLeadingButton(),
        ),
        body: SafeArea(
          child: OtpBody(
            pageType: pageType,
            instruction: instructions,
          ),
        ),
      ),
    );
  }
}
