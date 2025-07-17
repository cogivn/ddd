import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../models/auth_request.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Authenticates a user with the provided login request
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success: [User] object with session details
  /// - Failure: [ApiError] with error details
  ///
  /// The [token] parameter can be used to cancel the request
  Future<ResultDart<User, ApiError>> login(
    LoginRequest request, {
    CancelToken? token,
  });

  /// Updates user profile with the provided information
  ///
  /// Takes an update profile request containing the fields to update
  /// and returns the updated user entity.
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success: Updated [User] object
  /// - Failure: [ApiError] with error details
  ///
  /// The [token] parameter can be used to cancel the request
  ///
  /// Follows MCP-ddd-domain-layer: Define repository methods for domain operations
  Future<ResultDart<User, ApiError>> updateProfile(
    UpdateProfileRequest request, {
    CancelToken? token,
  });

  /// Retrieves detailed information about the member's account
  ///
  /// Fetches the complete user data from the API, including all account details
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success: [User] object with complete account details
  /// - Failure: [ApiError] with error details
  ///
  /// The [token] parameter can be used to cancel the request
  ///
  /// Follows MCP-ddd-domain-layer: Define repository methods for domain operations
  Future<ResultDart<User, ApiError>> me({CancelToken? token});

  /// Saves user data to persistent storage
  ///
  /// Takes a [user] entity and saves it to the appropriate storage mechanism.
  /// This method should be called whenever user data needs to be persisted,
  /// such as after login, registration, or profile updates.
  Future<void> saveUserData(User user);

  /// Saves access token to secure storage
  ///
  /// Takes the [token] string from the user and saves it securely.
  /// This method should be called whenever a new token is received,
  /// such as after login, registration, or token refresh.
  /// Returns true if the token was successfully saved.
  Future<void> saveAccessToken(String token);

  /// Checks if the user is currently logged in
  ///
  /// Returns true only if both conditions are met:
  /// 1. User data exists in storage
  /// 2. A valid access token exists
  ///
  /// If only one condition is met (either user data exists without token
  /// or token exists without user data), this method will clear the
  /// remaining data for consistency and return false.
  Future<bool> isLoggedIn();

  /// Retrieves the current user data from storage
  Future<User?> getUser();

  /// Registers the push token for the current user on the server
  ///
  /// [pushToken]: The FCM or APNs token to register
  /// Returns true if registration is successful, otherwise returns an ApiError
  Future<ResultDart<bool, ApiError>> registerPushToken({
    required String pushToken,
    CancelToken? token,
  });

  /// Logs out the user, clearing their session data
  ///
  /// This method should be called when:
  /// - User explicitly requests logout
  /// - Server returns 401 Unauthorized error
  ///
  /// Returns true if logout was successful, otherwise returns false
  Future<ResultDart<bool, ApiError>> logout({
    CancelToken? token,
  });
}
