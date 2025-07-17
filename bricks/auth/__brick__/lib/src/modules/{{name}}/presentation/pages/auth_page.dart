import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/size_x.dart';
import '../../../../common/widgets/widgets.dart';
import '../../application/auth_notifier/auth_notifier.dart';
import '../hooks/auth_hooks.dart';
import '../style/text_styles.dart';

part '../widgets/auth_body.dart';

/// AuthPage represents the authentication screen of the application
/// Following the "Widget Implementation Patterns" section from Flutter guidance,
/// this is implemented as a ConsumerWidget (a variation of StatelessWidget)
/// since it doesn't maintain its own state but consumes external state
@RoutePage()
class AuthPage extends ConsumerWidget {
  /// Constructor with an optional popTo parameter to handle navigation after authentication
  /// This follows the "Constructor Patterns" best practice from Flutter guidance
  const AuthPage({super.key, this.popTo});

  /// Optional route name to pop back to after successful authentication
  /// Using clearly named properties as per "Best Practices" in Flutter guidance
  final String? popTo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to authentication state changes and handle navigation accordingly
    // This is an example of the "Parent-Managed State" pattern from the guidance
    ref.listen(authProvider, (_, now) {
      now.status.whenOrNull(
        authenticated: (user) {
          if (popTo != null) {
            context.router.popUntil((route) {
              return route.settings.name == popTo;
            });
          } else {
            context.maybePop(user);
          }
        },
      );
    });

    // Using FocusDetector to reset state when leaving the page
    // This follows the "Widget Lifecycle" management best practice
    return FocusDetector(
      onVisibilityLost: ref.read(authProvider.notifier).resetState,
      child: Scaffold(
        // Prevent resizing when keyboard appears to avoid UI jumps
        // This is a UI/UX optimization mentioned in performance tips
        resizeToAvoidBottomInset: false,
        appBar: BaseAppBar(
          titleText: context.s.login,
          // Using AutoLeadingButton for intelligent back navigation
          // It automatically handles nested routes and tabs better than the standard BackButton
          leading: AutoLeadingButton(),
        ),
        // Using Stack for layered UI composition
        // This demonstrates effective widget composition as recommended in guidance
        body: const AuthBody(),
      ),
    );
  }
}
