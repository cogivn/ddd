import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

Future<void> run(HookContext context) async {
  // Merge localization keys
  await mergeLocalizeKeys(context);
}


Future<void> mergeLocalizeKeys(HookContext context) async {
  final basePath = File(Platform.script.toFilePath()).path;
  final brickPath = upLevels(basePath, 5);
  final result = await Process.run(
    'dart',
    ['${brickPath}/merge_l10n_keys.dart'],
    runInShell: true,
    workingDirectory: Directory.current.path, // Đảm bảo chạy từ workspace root
  );
  if (result.exitCode != 0) {
    context.logger.err('Failed to merge l10n keys: \n${result.stderr}');
  } else {
    context.logger.info('Merged l10n keys successfully!');
  }
}

String upLevels(String path, int levels) {
  var result = path;
  for (var i = 0; i < levels; i++) {
    result = p.dirname(result);
  }
  return result;
}
