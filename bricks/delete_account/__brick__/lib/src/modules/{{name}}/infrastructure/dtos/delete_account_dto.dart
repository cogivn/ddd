import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/delete_account.dart';

part 'delete_account_dto.freezed.dart';
part 'delete_account_dto.g.dart';

/// Data Transfer Object for account deletion operations
///
/// This class implements the DeleteAccount entity and provides JSON serialization.
/// Follows MCP-ddd-infrastructure-layer: Use DTOs for data serialization
@freezed
abstract class DeleteAccountDto with _$DeleteAccountDto implements DeleteAccount {
  const factory DeleteAccountDto({
    @JsonKey(name: 'id') @Default(-1) int id,
    @JsonKey(name: 'reason') @Default('') String reason,
    @JsonKey(name: 'success') @Default(false) bool success,
  }) = _DeleteAccountDto;

  factory DeleteAccountDto.fromJson(Map<String, dynamic> json) => _$DeleteAccountDtoFromJson(json);
}