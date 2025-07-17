import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../domain/models/delete_account_request.dart';

part 'delete_account_client.g.dart';

/// API client for delete account operations using Retrofit
///
/// Follows MCP-ddd-infrastructure-layer: API client with Retrofit annotations
@RestApi()
@injectable
abstract class DeleteAccountClient {
  /// Creates a new instance of DeleteAccountClient
  ///
  /// [dio] The Dio instance used for API calls
  /// 
  /// Follows MCP-ddd-infrastructure-layer: Use factory constructor with DI
  @factoryMethod
  factory DeleteAccountClient(Dio dio) = _DeleteAccountClient;
  
  /// Deletes the user account
  ///
  /// [request] Contains the reason for account deletion
  /// [cancelToken] Optional token to cancel the request
  /// 
  /// Follows MCP-ddd-api-client: Use proper HTTP method annotation with form submission
  @PUT('/member_account/delete_account')
  Future<NoDataApiResponse> deleteAccount(
    @Body() DeleteAccountRequest request,
    @CancelRequest() CancelToken? cancelToken,
  );
}