import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}.dart';

abstract class {{name.pascalCase()}}Repository {
 Future<Result<I{{name.pascalCase()}},ApiError>> getById(int id, {CancelToken? token});
}

