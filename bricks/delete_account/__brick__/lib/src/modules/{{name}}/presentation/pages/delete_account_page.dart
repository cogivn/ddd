import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../widgets/confirm_delete_account_body.dart';
import '../widgets/delete_account_body.dart';

@RoutePage()
class DeleteAccountPage extends HookConsumerWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController();
    final index = useState(0);
    return Scaffold(
      appBar: BaseAppBar(
        titleText: switch (index.value) {
          1 => context.s.delete_account_confirm,
          _ => context.s.settings_account_management,
        },
        leading: const AutoLeadingButton(),
      ),
      body: DeleteAccountPageController(
        controller: controller,
        child: SafeArea(
          child: PageView(
            controller: controller,
            onPageChanged: (value) => index.value = value,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const DeleteAccountBody(),
              const ConfirmDeleteAccountBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteAccountPageController extends InheritedWidget {
  const DeleteAccountPageController({
    super.key,
    required super.child,
    required this.controller,
  });

  final PageController controller;

  static PageController of(BuildContext context) {
    final DeleteAccountPageController? result = context
        .dependOnInheritedWidgetOfExactType<DeleteAccountPageController>();
    assert(result != null, 'No DeleteAccountPageController found in context');
    return result!.controller;
  }

  @override
  bool updateShouldNotify(covariant DeleteAccountPageController oldWidget) {
    return oldWidget.controller != controller;
  }
}
