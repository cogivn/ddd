import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/reset_notifier/reset_notifier.dart';
import '../widgets/reset_form_body.dart';


class ResetFormPage extends HookConsumerWidget {
  /// Creates a new instance of ResetPasswordPage
  const ResetFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the reset state to determine if we're in a loading or successful state
    ref.listen(resetProvider, (previous, now) {
      now.status.whenOrNull(success: context.maybePop);
    });

    return const ResetFormBody();
  }
}
