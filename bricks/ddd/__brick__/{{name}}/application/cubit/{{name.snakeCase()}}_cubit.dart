import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../domain/entities/{{name.snakeCase()}}.dart';
import '../../../../common/utils/cancelable_base_bloc.dart';
import '../../domain/interfaces/{{name.snakeCase()}}_interface.dart';

part '{{name.snakeCase()}}_state.dart';
part '{{name.snakeCase()}}_cubit.freezed.dart';
part '{{name.snakeCase()}}_cubit.g.dart';

@injectable
class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> with CancelableBaseBloc {
  final I{{name.pascalCase()}}Repository _repository;
  {{name.pascalCase()}}Cubit(this._repository) : super(const {{name.pascalCase()}}State());

  get() async {
    emit(state.loading);
    final response = await _repository.getById(1, token: cancelToken);
    response.fold(
      (l) => emit(state.onError(l)),
      (r) => emit(state.onLoaded(r)),
    );
  }
}