import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/interfaces/{{name.snakeCase()}}_interface.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}.dart';
import '../../../{{name.snakeCase()}}/infrastructure/models/{{name.snakeCase()}}_model.dart';

@alpha
@LazySingleton(as: I{{name.pascalCase()}}Repository)
class {{name.pascalCase()}}MockupRepository implements I{{name.pascalCase()}}Repository {
  @override
  Future<Result<I{{name.pascalCase()}},ApiError>> getById(int id, {CancelToken? token}) async {
    return Result.success(const {{name.pascalCase()}}Model());
  }
}