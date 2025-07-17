/// Constants used for validation in the delete account flow
///
/// Follows MCP-ddd-domain-layer: Use constants for validation keys
class DeleteAccountValidationKeys {
  // Private constructor to prevent instantiation
  DeleteAccountValidationKeys._();

  /// Key for reason field validation errors
  static const String reason = 'reason';
  static const String confirmReason = 'confirm-reason';
}