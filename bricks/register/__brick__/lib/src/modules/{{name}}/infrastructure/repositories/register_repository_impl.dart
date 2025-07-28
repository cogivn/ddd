import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';


import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../domain/repositories/register_repository.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../core/domain/entities/user.dart';

import '../../domain/models/register_request.dart';
import '../service/register_client.dart';

@LazySingleton(
  as: RegisterRepository,
  env: AppEnvironment.environments,
)
class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterClient _client;

  const RegisterRepositoryImpl(this._client);

  @override
  Future<ResultDart<User, ApiError>> register(
    RegisterRequest request, {
    CancelToken? token,
  }) async {
    try {
      return _client.register(request, cancelToken: token)
          .tryGet((response) => response.data);
    } catch (e) {
      return Failure(
        ApiError.server(
          message: e.toString(),
          code: 500,
        ),
      );
    }
  }

  // @override
  // Future<ResultDart<Supportive, ApiError>> getSupportiveByKey(String key) async {
  //   try {
  //     // Query the Isar database for supportive content with the given key
  //     final supportive = await _isar.supportive
  //         .filter()
  //         .keyEqualTo(key)
  //         .findFirst();
  //
  //     if (supportive == null) {
  //       return Failure(
  //         ApiError.server(
  //           message: 'Supportive content not found for key: $key',
  //           code: 404,
  //         ),
  //       );
  //     }
  //
  //     return Success(Supportive.fromIsar(supportive));
  //   } catch (e) {
  //     return Failure(
  //       ApiError.server(
  //         message: 'Error retrieving supportive content: $e',
  //         code: 500,
  //       ),
  //     );
  //   }
  // }
}