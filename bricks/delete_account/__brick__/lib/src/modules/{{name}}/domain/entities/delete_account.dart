/// Domain entity representing an account deletion
///
/// This interface defines the properties required for an account deletion operation.
/// Follows MCP-ddd-domain-layer: Define clean domain entities
abstract interface class DeleteAccount {
  /// Unique identifier for this account deletion record
  int get id;
  
  /// User's reason for deleting their account
  String get reason;
  
  /// Whether the account deletion was successful
  bool get success;
}