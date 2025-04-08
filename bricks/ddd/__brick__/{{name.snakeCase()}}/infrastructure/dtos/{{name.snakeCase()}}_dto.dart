import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/{{name.snakeCase()}}.dart';

part '{{name.snakeCase()}}_dto.freezed.dart';
part '{{name.snakeCase()}}_dto.g.dart';

@freezed
abstract class {{name.pascalCase()}}Dto with _${{name.pascalCase()}}Dto implements {{name.pascalCase()}} {
  const factory {{name.pascalCase()}}Dto({
    @JsonKey(name: 'id') @Default(-1) int id,
  }) = _{{name.pascalCase()}}Dto;

  factory {{name.pascalCase()}}Dto.fromJson(json) => _${{name.pascalCase()}}DtoFromJson(json);
}
