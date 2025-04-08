import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/{{name.snakeCase()}}_cubit/{{name.snakeCase()}}_cubit.dart';
{{/is_bloc}}{{#is_riverbloc}}import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverbloc/riverbloc.dart';
import '../../application/{{name.snakeCase()}}_cubit/{{name.snakeCase()}}_cubit.dart';
{{/is_riverbloc}}{{#is_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/{{name.snakeCase()}}_notifier/{{name.snakeCase()}}_notifier.dart';
{{/is_riverpod}}
import '../../../../common/extensions/build_context_dialog.dart';
import '../widgets/{{name.snakeCase()}}_body.dart';

@RoutePage()
{{#is_bloc}}class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<{{name.pascalCase()}}Cubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<{{name.pascalCase()}}Cubit, {{name.pascalCase()}}State>(
          listener: (context, state) => state.status
              .whenOrNull(error: (error) => context.showApiError(error)),
          child: const {{name.pascalCase()}}Body(),
        ),
      ),
    );
  }
}{{/is_bloc}}{{#is_riverbloc}}class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      {{name.camelCase()}}Provider,
      (_, current) => current.status
          .whenOrNull(error: (error) => context.showApiError(error)),
    );
    return Scaffold(
      appBar: AppBar(),
      body: const {{name.pascalCase()}}Body(),
    );
  }
}{{/is_riverbloc}}{{#is_riverpod}}class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      {{name.camelCase()}}Provider,
      (_, current) => current.status
          .whenOrNull(error: (error) => context.showApiError(error)),
    );
    return Scaffold(
      appBar: AppBar(),
      body: const {{name.pascalCase()}}Body(),
    );
  }
}{{/is_riverpod}}