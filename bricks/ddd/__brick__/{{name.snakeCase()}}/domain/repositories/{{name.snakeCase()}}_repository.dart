import 'package:dio/dio.dart';
import 'package:dart_result/dart_result.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}.dart';

abstract class {{name.pascalCase()}}Repository {
  Future<DartResult<{{name.pascalCase()}}, ApiError>> getById(int id, {CancelToken? token});
}

