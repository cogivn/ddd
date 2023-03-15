import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../application/cubit/{{name.snakeCase()}}_cubit.dart';
import '../widgets/{{name.snakeCase()}}_body.dart';

class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> getIt<{{name.pascalCase()}}Cubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: const {{name.pascalCase()}}Body(),
      ),
    );
  }
}
