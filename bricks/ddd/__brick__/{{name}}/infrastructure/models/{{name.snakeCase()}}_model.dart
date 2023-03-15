import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/{{name.snakeCase()}}.dart';

part '{{name.snakeCase()}}_model.freezed.dart';
part '{{name.snakeCase()}}_model.g.dart';

@freezed
class {{name.pascalCase()}}Model with _${{name.pascalCase()}}Model implements I{{name.pascalCase()}} {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory {{name.pascalCase()}}Model({
    @JsonKey(name: 'id') @Default(-1) int id,
  }) = _{{name.pascalCase()}}Model;

  factory {{name.pascalCase()}}Model.fromJson(json) => _${{name.pascalCase()}}ModelFromJson(json);
}
