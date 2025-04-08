import 'package:flutter/material.dart';
{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/{{name.snakeCase()}}_cubit/{{name.snakeCase()}}_cubit.dart';{{/is_bloc}}
{{#is_riverbloc}}import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/{{name.snakeCase()}}_cubit/{{name.snakeCase()}}_cubit.dart';{{/is_riverbloc}}
{{#is_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/{{name.snakeCase()}}_notifier/{{name.snakeCase()}}_notifier.dart';{{/is_riverpod}}

class {{name.pascalCase()}}Body extends {{#is_bloc}}StatelessWidget{{/is_bloc}}{{^is_bloc}}ConsumerWidget{{/is_bloc}} {
  const {{name.pascalCase()}}Body({super.key});

  @override
  Widget {{#is_bloc}}build(BuildContext context){{/is_bloc}}{{^is_bloc}}build(BuildContext context, WidgetRef ref){{/is_bloc}} {
    {{#is_riverpod}}final state = ref.watch({{name.camelCase()}}Provider);{{/is_riverpod}}
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('{{name.pascalCase()}}'),
          const SizedBox(height: 20),
          {{#is_riverpod}}if (state.isLoading)
            const CircularProgressIndicator(),{{/is_riverpod}}
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              {{#is_bloc}}context.read<{{name.pascalCase()}}Cubit>().get();{{/is_bloc}}
              {{#is_riverbloc}}ref.read({{name.camelCase()}}Provider.bloc).get();{{/is_riverbloc}}
              {{#is_riverpod}}ref.read({{name.camelCase()}}Provider.notifier).get();{{/is_riverpod}}
            },
            child: const Text('Load Data'),
          ),
        ],
      ),
    );
  }
}
