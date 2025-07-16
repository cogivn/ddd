import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../domain/models/auth_request.dart';
import '../dtos/user_dto.dart';

part 'auth_client.g.dart';

@RestApi()
@injectable
abstract class AuthClient {
  @factoryMethod
  factory AuthClient(Dio dio) = _AuthClient;

  @POST('/member_account/login')
  Future<SingleApiResponse<UserDTO>> login(
    @Body() LoginRequest loginRequest, {
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Updates user profile information
  ///
  /// Calls the `/member_account/update` endpoint with form data containing profile updates
  /// Returns a response containing the updated user data
  ///
  /// [request] The update profile request containing fields to update
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Follows MCP-ddd-infrastructure-layer: Use Retrofit for API client definitions
  @PUT('/member_account/update')
  Future<NoDataApiResponse> updateProfile(
    @Body() UpdateProfileRequest request, {
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Updates the user's phone number
  ///
  /// Calls the `/member_account/update` endpoint with the new phone number
  /// Returns a response containing the access token user data
  /// /// [request] The update profile request containing the new phone number
  /// /// [cancelToken] Optional token to cancel the request
  /// /// Follows MCP-ddd-infrastructure-layer: Use Retrofit for API client definitions
  @PUT('/member_account/update')
  Future<SingleApiResponse<UserDTO>> updatePhoneNumber(
    @Body() UpdateProfileRequest request, {
    @CancelRequest() CancelToken? cancelToken,
    @Query('ig_auth_handler') bool? ignoreAuthHandler,
  });

  /// Retrieves detailed information about the member's account
  ///
  /// Calls the `/member_account/detail` endpoint to fetch current user account details
  /// Returns a response containing the complete user data
  ///
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Follows MCP-ddd-infrastructure-layer: Use Retrofit for API client definitions
  @GET('/member_account/detail')
  Future<SingleApiResponse<UserDTO>> getMemberAccountDetail({
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Registers a new push notification token for the user
  ///
  /// Calls the `/push/reg_token` endpoint with the provided token
  /// Returns a response containing the registration status
  /// [request] The request data containing the push token
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Follows MCP-ddd-infrastructure-layer: Use Retrofit for API client definitions
  @POST('/push/reg_token')
  Future<NoDataApiResponse> registerPushToken(
    @Body() Map<String, dynamic> request, {
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Logs out the user by calling the `/member_account/logout` endpoint
  ///
  /// Returns a response indicating the logout status
  ///
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Follows MCP-ddd-infrastructure-layer: Use Retrofit for API client definitions
  @POST('/member_account/logout')
  Future<NoDataApiResponse> logout({
    @CancelRequest() CancelToken? cancelToken,
  });
}
