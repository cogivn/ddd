import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/otp_page_type.dart';
import '../widgets/otp_phone_body.dart';

/// Page for entering and validating a phone number for OTP
@RoutePage()
class OtpPhonePage extends ConsumerWidget {
  /// Creates an OTP phone input page
  /// 
  /// The [pageType] parameter determines the context in which the OTP flow is used
  /// Default is [OtpPageType.registration]
  const OtpPhonePage({
    super.key,
    this.pageType = OtpPageType.registration,
  });

  /// The context in which this OTP flow is being used
  final OtpPageType pageType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OtpPhoneBody(pageType: pageType);
  }
}
