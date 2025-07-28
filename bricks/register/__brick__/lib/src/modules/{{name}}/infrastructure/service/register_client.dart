import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../auth/infrastructure/dtos/user_dto.dart';
import '../../domain/models/register_request.dart';

part 'register_client.g.dart';

@RestApi()
@injectable
abstract class RegisterClient {
  @factoryMethod
  factory RegisterClient(Dio dio) = _RegisterClient;

  @POST('/member_account/register')
  Future<SingleApiResponse<UserDTO>> register(
    @Body() RegisterRequest request, {
    @CancelRequest() CancelToken? cancelToken,
  });
}