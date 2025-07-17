import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../domain/models/reset_request.dart';
import '../dtos/reset_dto.dart';


part 'reset_client.g.dart';

// Follows MCP-ddd-infrastructure-layer: API client with Retrofit annotations
@RestApi()
@injectable
abstract class ResetClient {
  // Follows MCP-ddd-infrastructure-layer: Use factory constructor with DI
  @factoryMethod
  factory ResetClient(Dio dio) = _ResetClient;
  
  // Follows MCP-ddd-api-client: Use proper HTTP method annotation with form submission
  @FormUrlEncoded()
  @POST('/member_account/resetPassword')
  Future<SingleApiResponse<ResetDto>> resetPassword(
   @Body() ResetPasswordRequest request,
    @CancelRequest() CancelToken? cancelToken,
  );
}