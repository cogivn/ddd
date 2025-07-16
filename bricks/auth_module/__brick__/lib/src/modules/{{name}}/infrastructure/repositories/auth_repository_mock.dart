import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/domain/services/auth_service.dart';
import '../../../../core/infrastructure/datasources/local/storage.dart';
import '../../domain/interfaces/auth_repository.dart';
import '../../domain/models/auth_request.dart';
import '../dtos/user_dto.dart';

@alpha
@LazySingleton(as: AuthRepository)
class AuthRepositoryMock implements AuthRepository {
  final AuthService _authService;

  const AuthRepositoryMock(this._authService);

  @override
  Future<ResultDart<User, ApiError>> login(
    LoginRequest request, {
    CancelToken? token,
  }) async {
    // Extract primitive values from request model
    final phone = request.mobileNumber.value;
    final password = request.password.value;
    if (phone == '99999999' && password == 'aA111111') {
      // Tạo UserDto với MemberAccountDto
      final user = UserDTO();
      return Success(user);
    }
    return Failure(
      ApiError.server(
        message: 'Invalid credentials',
        code: 401,
      ),
    );
  }

  @override
  Future<ResultDart<User, ApiError>> updateProfile(
    UpdateProfileRequest request, {
    bool? ignoreAuthHandler,
    CancelToken? token,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ResultDart<bool, ApiError>> registerPushToken({
    required String pushToken,
    CancelToken? token,
  }) async {
    return true.toSuccess();
  }

  @override
  Future<void> saveUserData(User user) async {
    // Follows MCP-ddd-infrastructure-layer: Mock storage operations
    logger.i('[AuthRepositoryMock] Mock saving user data '
        'to storage for user: ${user.id}');
    await Storage.setUser(user);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    // Follows MCP-ddd-infrastructure-layer: Mock storage operations
    logger.i('[AuthRepositoryMock] Mock saving access token to secure storage');
    await Storage.setAccessToken(token);
  }

  @override
  Future<bool> isLoggedIn() async {
    // Follows MCP-ddd-repository-pattern: Implement repository
    // methods in infrastructure layer
    logger.i('[AuthRepositoryMock] Checking mock login status');

    final user = Storage.user;
    final token = await Storage.accessToken;

    // Both user data and access token must exist
    if (user != null && token != null && token.isNotEmpty) {
      logger.i('[AuthRepositoryMock] Mock user is logged in');
      return true;
    }

    // If only one exists, clear it for consistency
    if (user != null && (token == null || token.isEmpty)) {
      logger.w('[AuthRepositoryMock] Mock user data exists but token'
          ' missing, clearing session');
      await _authService.logout();
    } else if ((user == null) && token != null && token.isNotEmpty) {
      logger.w('[AuthRepositoryMock] Mock token exists but user'
          ' data missing, clearing session');
      await _authService.logout();
    }

    logger.i('[AuthRepositoryMock] Mock user is not logged in');
    return false;
  }

  @override
  Future<User?> getUser() async {
    // Follows MCP-ddd-infrastructure-layer: Handle local storage
    // in repository implementations
    logger.i('[AuthRepository] Retrieving user data from storage');
    if (!await isLoggedIn()) {
      return null;
    }
    return Storage.user;
  }

  @override
  Future<ResultDart<User, ApiError>> me({
    CancelToken? token,
  }) async {
    // Follows MCP-ddd-infrastructure-layer: Provide mock implementations for testing
    try {
      logger.i('[AuthRepositoryMock] Mocking get member account detail');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Check login status
      if (!await isLoggedIn()) {
        logger.w('[AuthRepositoryMock] Cannot get account details:'
            ' User not logged in');
        return Failure(
          ApiError.server(
            message: 'Unauthorized access',
            code: 401,
          ),
        );
      }

      // Get current user from storage
      final currentUser = Storage.user;
      if (currentUser == null) {
        // This shouldn't happen as isLoggedIn() should have returned false
        logger.e('[AuthRepositoryMock] User is null'
            'despite isLoggedIn() check');
        return Failure(
          ApiError.internal(
            'User data not found',
          ),
        );
      }

      // In a real implementation, this would fetch fresh data from the API
      // For the mock, we'll just return the current user with a slight modification
      // to simulate that we got updated data

      // Create a slightly modified account to simulate a refresh


      // Create refreshed user with the updated account
      final refreshedUser = UserDTO();

      logger.i(
          '[AuthRepositoryMock] Member account details fetched successfully');
      return Success(refreshedUser);
    } catch (e, stackTrace) {
      logger.e('[AuthRepositoryMock] Error getting member account details',
          exception: e, stackTrace: stackTrace);
      return Failure(
        ApiError.internal(
          'Unknown error: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<ResultDart<bool, ApiError>> logout({CancelToken? token}) async {
    final status = await _authService.logout();
    return status.toSuccess();
  }
}
