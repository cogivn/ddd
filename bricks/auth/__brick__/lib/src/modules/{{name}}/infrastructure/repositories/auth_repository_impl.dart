import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/application/events/auth_event_bus.dart';
import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/domain/services/auth_service.dart';
import '../../../../core/infrastructure/datasources/local/storage.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../domain/interfaces/auth_repository.dart';
import '../../domain/models/auth_request.dart';
import '../dtos/user_dto.dart';
import '../service/auth_client.dart';

@LazySingleton(as: AuthRepository, env: AppEnvironment.environments)
class AuthRepositoryImpl implements AuthRepository {
  final AuthClient _client;
  final AuthEventBus _authEventBus;
  final AuthService _authService;

  const AuthRepositoryImpl(
    this._client,
    this._authEventBus,
    this._authService,
  );

  @override
  Future<ResultDart<User, ApiError>> login(
    LoginRequest request, {
    CancelToken? token,
  }) async {
    return _client.login(request, cancelToken: token).tryGet((response) async {
      if (request.pushToken.isNotNullOrEmpty) {
        await Storage.setLastRegisteredPushToken(request.pushToken);
      }
      return response.data;
    });
  }

  @override
  Future<ResultDart<User, ApiError>> updateProfile(
    UpdateProfileRequest request, {
    bool? ignoreAuthHandler,
    CancelToken? token,
  }) async {
    // Follows MCP-ddd-infrastructure-layer: Use repository implementation
    // to transform between domain and infrastructure layers
    logger.i('[AuthRepository] Updating user profile');
    // Call the API endpoint
    final result = await _client
        .updateProfile(request, cancelToken: token)
        .tryGet((response) => response);

    return result.toAsyncResult().flatMap((_) async {
      logger.i('[AuthRepository] User profile updated successfully');
      return await me(token: token);
    });
  }

  @override
  Future<ResultDart<User, ApiError>> me({
    CancelToken? token,
  }) async {
    // Follows MCP-ddd-infrastructure-layer: Use repository implementation
    // to transform between domain and infrastructure layers
    logger.i('[AuthRepository] Fetching member account details');

    // Call the API endpoint
    final result = await _client
        .getMemberAccountDetail(cancelToken: token)
        .tryGet((response) => response.data);

    return result.toAsyncResult().map((user) async {
      // If successful, update the stored user data with fresh data from server
      await saveUserData(user);
      _authEventBus.notifyUserUpdated(user);
      logger.i('[AuthRepository] Member account details fetched and saved');
      return user;
    });
  }

  @override
  Future<void> saveUserData(User user) async {
    // Follows MCP-ddd-infrastructure-layer: Handle local storage
    // in repository implementations
    logger.i('[AuthRepository] Saving user data to storage '
        'for user: ${user.id}');
    await Storage.setUser(user.toJson());
  }

  @override
  Future<void> saveAccessToken(String token) async {
    // Follows MCP-ddd-infrastructure-layer: Handle local storage
    // in repository implementations
    logger.i('[AuthRepository] Saving access token to secure storage');
    await Storage.setAccessToken(token);
  }

  @override
  Future<User?> getUser() async {
    // Follows MCP-ddd-infrastructure-layer: Handle local storage
    // in repository implementations
    logger.i('[AuthRepository] Retrieving user data from storage');
    if (!await isLoggedIn()) {
      return null;
    }
    return UserDTO.fromJson(Storage.user);
  }

  @override
  Future<ResultDart<bool, ApiError>> registerPushToken({
    required String pushToken,
    CancelToken? token,
  }) async {
    final request = {
      'push_token': pushToken,
      'kind': Constants.getMobileKind(),
    };
    return _client.registerPushToken(request).tryGet((response) => true);
  }

  @override
  Future<ResultDart<bool, ApiError>> logout({CancelToken? token}) async {
    return _client.logout(cancelToken: token).tryGet((_) async {
      logger.i('[AuthRepository] User logged out successfully');
      return await _authService.logout();
    });
  }

  @override
  Future<bool> isLoggedIn() async {
    // Follows MCP-ddd-repository-pattern: Implement repository
    // methods in infrastructure layer
    logger.i('[AuthRepository] Checking mock login status');

    final user = UserDTO.fromJson(Storage.user);
    final token = await Storage.accessToken;

    // Both user data and access token must exist
    if (user.isValid() && token != null && token.isNotEmpty) {
      logger.i('[AuthRepository] Mock user is logged in');
      return true;
    }

    // If only one exists, clear it for consistency
    if (user.isValid() && (token == null || token.isEmpty)) {
      logger.w('[AuthRepository] Mock user data exists but token'
          ' missing, clearing session');
      await _authService.logout();
    } else if ((user.isValid()) && token != null && token.isNotEmpty) {
      logger.w('[AuthRepository] Token exists but user'
          ' data missing, clearing session');
      await _authService.logout();
    }

    logger.i('[AuthRepository] User is not logged in');
    return false;
  }
}
