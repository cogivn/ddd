import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../models/register_request.dart';

/// Repository interface for register operations
abstract class RegisterRepository {
  /// Registers a new user with phone number, password and mobile token
  /// 
  /// Takes a [request] containing:
  /// - Phone number that has been validated
  /// - Mobile token from OTP verification
  /// - Password for the new account
  /// - Device information (mobile kind, push token)
  /// - Language preference
  ///
  /// Optionally accepts a [token] for request cancellation.
  /// 
  /// Returns a [ResultDart] containing either:
  /// - Success: [User] entity with the newly registered user information
  /// - Failure: [ApiError] with error details if registration fails
  /// 
  /// The registration process:
  /// 1. Validates all provided information
  /// 2. Creates a new user account in the system
  /// 3. Returns user data including authentication token
  Future<ResultDart<User, ApiError>> register(
    RegisterRequest request, {
    CancelToken? token,
  });

  /// Retrieves supportive content by its unique key identifier
  ///
  /// Takes a [key] string that uniquely identifies the supportive content.
  /// Returns a [ResultDart] containing either:
  /// - Success: [Supportive] entity with the content information
  /// - Failure: [ApiError] with error details if retrieval fails
  ///
  /// This method is typically used to fetch static content like:
  /// - Terms and conditions
  /// - Privacy policy
  /// - Help content
  /// - Other informational pages
  /// Future<ResultDart<Supportive, ApiError>> getSupportiveByKey(String key);
}

