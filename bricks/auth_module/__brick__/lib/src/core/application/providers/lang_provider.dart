import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/utils/getit_utils.dart';
import '../../../common/utils/logger.dart';
import '../../domain/interfaces/lang_repository.dart';

part 'lang_provider.g.dart';

@riverpod
class Lang extends _$Lang {
  @override
  Locale build() {
    final repository = getIt<LangRepository>();
    return repository.getLocale();
  }

  Future<void> setLocale(Locale val) async {
    final repository = getIt<LangRepository>();
    if (val == state) return;

    try {
      await repository.setLocale(val);
      state = val;
    } catch (error) {
      logger.e(error);
    }
  }
}
