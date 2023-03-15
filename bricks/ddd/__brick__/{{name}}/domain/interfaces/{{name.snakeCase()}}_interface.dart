import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}.dart';

abstract class I{{name.pascalCase()}}Repository {
 Future<Either<ApiError, I{{name.pascalCase()}}>> getById(int id, {CancelToken? token});
}

