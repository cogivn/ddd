import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/otp_verify_phone_body.dart';

/// Page for entering and verifying an OTP code
@RoutePage()
class OtpVerifyPhonePage extends ConsumerWidget {
  /// Page for entering and verifying an OTP code
  const OtpVerifyPhonePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const OtpVerifyPhoneBody(),
    );
  }
}
