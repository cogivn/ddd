import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizing/sizing.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/utils/html_utils.dart';
import '../../../../common/widgets/button/solid_button.dart';
import '../../../../common/widgets/sliver_footer.dart';
import '../../../../common/widgets/textfield/input_decoration.dart';
import '../hooks/delete_account_hooks.dart';
import '../pages/delete_account_page.dart';

class DeleteAccountBody extends HookConsumerWidget {
  const DeleteAccountBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = DeleteAccountPageController.of(context);
    final state = useDAReasonForm(ref);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: const SizedBox(height: 26)),
        SliverToBoxAdapter(child: _DeleteInstruction()),
        SliverToBoxAdapter(
          child: _Textfield(
            controller: state.controller,
            onChanged: state.onReasonChanged,
            error: state.reasonError,
          ),
        ),
        SliverFooter(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SolidButton(
              isEnabled: state.isFormValid,
              margin: EdgeInsets.all(26.ss),
              text: context.s.delete_continue,
              onPressed: () {
                controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class _DeleteInstruction extends StatelessWidget {
  const _DeleteInstruction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.ss),
      child: HtmlUtils.standard(
          data: context.s.delete_account_notice,
          config: HtmlRenderConfig(
            shrinkWrap: true,
            style: {
              'h4': Style.fromTextStyle(
                context.textTheme.regular.copyWith(
                  fontSize: 18.fss,
                ),
              ).copyWith(
                padding: HtmlPaddings.only(bottom: 10),
                margin: Margins.zero,
              ),
              'p': Style.fromTextStyle(
                context.textTheme.regular.copyWith(
                  fontSize: 15.fss,
                  color: ColorName.textSecondary,
                ),
              ).copyWith(
                padding: HtmlPaddings.symmetric(vertical: 10),
                margin: Margins.zero,
              ),
              'ul': Style.fromTextStyle(
                context.textTheme.regular.copyWith(
                  fontSize: 15.fss,
                  color: ColorName.textSecondary,
                ),
              ).copyWith(
                padding: HtmlPaddings.symmetric(horizontal: 10),
                margin: Margins.zero,
                listStyleType: ListStyleType.disc,
              ),
              'li': Style.fromTextStyle(
                context.textTheme.regular.copyWith(
                  fontSize: 15.fss,
                  color: ColorName.textSecondary,
                ),
              ).copyWith(
                padding: HtmlPaddings.only(bottom: 10),
                margin: Margins.zero,
                listStyleType: ListStyleType.disc,
              ),
            },
          )),
    );
  }
}

class _Textfield extends StatelessWidget {
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
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 26, top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.s.delete_account_reason_label,
            style: context.textTheme.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            style: context.textTheme.medium.copyWith(fontSize: 15.fss),
            onChanged: onChanged,
            controller: controller,
            decoration: UnderlineInputDecoration.styleFrom(
              context,
              errorText: error,
              hintText: context.s.delete_account_reason_hint,
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
