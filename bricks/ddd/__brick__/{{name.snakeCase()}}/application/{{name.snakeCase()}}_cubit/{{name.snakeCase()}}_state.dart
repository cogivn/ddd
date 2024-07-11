part of '{{name.snakeCase()}}_cubit.dart';

@generate
enum {{name.pascalCase()}}Status {
  initial,
  loading,
  error,
  loaded;
}


@freezed
class {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  const {{name.pascalCase()}}State._();

  const factory {{name.pascalCase()}}State({
    @Default({{name.pascalCase()}}Status.initial) {{name.pascalCase()}}Status status,
    I{{name.pascalCase()}}? data,
    ApiError? error,
  }) = _{{name.pascalCase()}}State;

}

extension {{name.pascalCase()}}StateX on {{name.pascalCase()}}State {
  {{name.pascalCase()}}State get loading => copyWith(status: {{name.pascalCase()}}Status.loading);

  {{name.pascalCase()}}State onError(ApiError error) => copyWith(
        status: {{name.pascalCase()}}Status.error,
        error: error,
      );

  {{name.pascalCase()}}State onLoaded(I{{name.pascalCase()}} data) => copyWith(
        status: {{name.pascalCase()}}Status.loaded,
        data: data,
      );
}