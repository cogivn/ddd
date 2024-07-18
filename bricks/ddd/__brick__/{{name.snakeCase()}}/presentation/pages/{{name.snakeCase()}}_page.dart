import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/{{name.snakeCase()}}_cubit/{{name.snakeCase()}}_cubit.dart';{{/is_bloc}}
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
        body: const {{name.pascalCase()}}Body(),
      ),
    );
  }
}{{/is_bloc}}{{^is_bloc}}class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const {{name.pascalCase()}}Body(),
    );
  }
}{{/is_bloc}}