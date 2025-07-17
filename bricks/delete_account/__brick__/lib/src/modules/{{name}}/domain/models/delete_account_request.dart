import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_request.freezed.dart';
part 'delete_account_request.g.dart';


/// Request model for account deletion operations
/// 
/// Follows MCP-ddd-domain-layer: Define immutable value objects for requests
@freezed
abstract class DeleteAccountRequest with _$DeleteAccountRequest {
  const DeleteAccountRequest._();

  /// Creates an account deletion request with the required parameters
  const factory DeleteAccountRequest({
    /// Reason for account deletion
    @Default('') String reason,
  }) = _DeleteAccountRequest;

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestFromJson(json);
}