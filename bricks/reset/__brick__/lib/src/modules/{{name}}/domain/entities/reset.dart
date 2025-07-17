/// Domain entity representing a successful password reset response
///
/// This interface defines the core domain entity returned after a successful
/// password reset operation. It contains the access token which can be used
/// for authentication after the password has been reset.
///
/// Follows MCP-ddd-domain-layer: Define domain entities as interfaces
abstract interface class Reset {
  /// Authentication token received after successful password reset
  ///
  /// This token can be used to authenticate the user after their password
  /// has been successfully reset, avoiding the need for an additional login step.
  String get token;
}