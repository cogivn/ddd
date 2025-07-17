import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizing/sizing.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/textfield/input_decoration.dart';
import '../../../../common/widgets/widgets.dart';
import '../hooks/delete_account_hooks.dart';

/// Widget for confirming account deletion
///
/// This widget displays a confirmation screen with a button that triggers
/// the account deletion process.
///
/// Follows MCP-ddd-presentation-layer: Build UI based on state from application layer
class ConfirmDeleteAccountBody extends HookConsumerWidget {
  /// Default constructor
  const ConfirmDeleteAccountBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a reason text controller
    final state = useDAConfirmReasonForm(ref);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: const _Instruction()),
        SliverToBoxAdapter(
          child: _Textfield(
            controller: state.controller,
            onChanged: state.onConfirmReasonChanged,
            error: state.reasonError,
          ),
        ),
        SliverFooter(
          child: _Submit(
            isLoading: state.isLoading,
            onPressed: state.onSubmit,
            isEnabled: state.isValid,
          ),
        )
      ],
    );
  }
}

class _Instruction extends StatelessWidget {
  const _Instruction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.ss, vertical: 16.ss),
      child: Text(
        context.s.delete_account_reason_title,
        style: context.textTheme.medium,
      ),
    );
  }
}

class _Textfield extends HookWidget {
  const _Textfield({
    required this.controller,
    this.onChanged,
    this.error,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final focus = useFocusNode();
    useEffect(() {
      focus.requestFocus();
      return focus.dispose;
    }, []);
    return Padding(
      padding: EdgeInsets.only(left: 26.ss, right: 26.ss),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.s.delete_account_reason_confirm_title,
            style: context.textTheme.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            autofocus: true,
            focusNode: focus,
            style: context.textTheme.medium.copyWith(fontSize: 15.fss),
            decoration: UnderlineInputDecoration.styleFrom(
              context,
              errorText: error,
              hintText: context.s.delete_account_type_delete,
              hintStyle: context.textTheme.medium.copyWith(
                color: ColorName.textUnselected,
                fontSize: 15.fss,
              ),
              disabledColor: ColorName.line.withValues(alpha: .5),
              borderColor: ColorName.line,
            ),
          ),
        ],
      ),
    );
  }
}

class _Submit extends StatelessWidget {
  const _Submit({
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SolidButton(
        isLoading: isLoading,
        margin: EdgeInsets.all(26.ss),
        text: context.s.delete_account_confirm,
        onPressed: onPressed,
        isEnabled: isEnabled,
      ),
    );
  }
}
