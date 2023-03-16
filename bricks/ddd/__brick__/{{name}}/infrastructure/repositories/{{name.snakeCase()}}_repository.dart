import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/interfaces/{{name.snakeCase()}}_interface.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}.dart';

@LazySingleton(
  as: I{{name.pascalCase()}}Repository,
  env: AppEnvironment.environments,
)
class {{name.pascalCase()}}Repository implements I{{name.pascalCase()}}Repository {
  @override
  Future<Either<ApiError, I{{name.pascalCase()}}>> getById(int id, {CancelToken? token}) async {
    // TODO: implement getById
    throw UnimplementedError();
  }
}