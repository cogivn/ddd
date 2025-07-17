import 'package:injectable/injectable.dart';

import '../../../common/utils/logger.dart';
import '../../infrastructure/datasources/local/storage.dart';

/// Service for handling authentication-related operations
@singleton
class AuthService {

  const AuthService();

  /// Logs out the user, clearing their session data
  ///
  /// This method should be called when:
  /// - User explicitly requests logout
  /// - Server returns 401 Unauthorized error
  /// - Token becomes invalid or expires
  ///
  /// Returns true if logout was successful
  Future<bool> logout() async {
    try {
      logger.i('Logging out user due to authentication issue');
      await Storage.clearUserData();
      logger.i('User data cleared successfully');
      return true;
    } catch (e) {
      logger.e('Error during logout: $e');
      return false;
    }
  }
}