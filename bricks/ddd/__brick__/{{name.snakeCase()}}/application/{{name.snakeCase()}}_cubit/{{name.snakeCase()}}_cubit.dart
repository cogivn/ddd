import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:injectable/injectable.dart';
{{#is_bloc}}import 'package:bloc/bloc.dart';{{/is_bloc}}{{#is_riverpod}}import 'package:riverbloc/riverbloc.dart';{{/is_riverpod}}

import '../../../../common/utils/getit_utils.dart';
import '../../../../common/mixin/cancelable_base_bloc.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../domain/entities/{{name.snakeCase()}}.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';

part '{{name.snakeCase()}}_state.dart';
part '{{name.snakeCase()}}_cubit.freezed.dart';
part '{{name.snakeCase()}}_cubit.g.dart';

{{#is_riverpod}}final {{name.camelCase()}}Provider = BlocProvider<{{name.pascalCase()}}Cubit, {{name.pascalCase()}}State>((_) {
  return getIt<{{name.pascalCase()}}Cubit>();
});{{/is_riverpod}}

@injectable
class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> with CancelableBaseBloc {
  final {{name.pascalCase()}}Repository _repository;

  {{name.pascalCase()}}Cubit(this._repository) : super(const {{name.pascalCase()}}State());

  get() async {
    emit(state.loading);
    final response = await _repository.getById(1, token: cancelToken);
    response.fold(
      (result) => emit(state.onLoaded(result)),
      (error) => emit(state.onError(error)),
    );
  }
}