import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/reset.dart';

part 'reset_dto.freezed.dart';
part 'reset_dto.g.dart';

@freezed
abstract class ResetDto with _$ResetDto implements Reset {
  const factory ResetDto({
    @JsonKey(name: 'access_token') @Default('') String token,
  }) = _ResetDto;

  factory ResetDto.fromJson(json) => _$ResetDtoFromJson(json);
}
