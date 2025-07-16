import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

Future<void> run(HookContext context) async {
  // Cài đặt gói bên ngoài focus_detector_v2
  await installExternalPackage(context);
  // Chạy script merge từ root workspace để assets/l10n đúng
  await mergeLocalizeKeys(context);
  // Xuất các widget textfield vào widgets.dart
  await exportAssets(context);
}

Future<void> installExternalPackage(HookContext context) async {
  await _installFocusDetectorV2(context);
  await _installFlutterMultiFormatter(context);
}

Future<void> _installFocusDetectorV2(HookContext context) async {
  final result = await Process.run(
    'flutter',
    ['pub', 'add', 'focus_detector_v2'],
    runInShell: true,
  );
  if (result.exitCode != 0) {
    context.logger.err('Failed to add focus_detector_v2: ${result.stderr}');
  } else {
    context.logger.info('focus_detector_v2 added successfully.');
  }
}

Future<void> _installFlutterMultiFormatter(HookContext context) async {
  final result = await Process.run(
    'flutter',
    ['pub', 'add', 'flutter_multi_formatter'],
    runInShell: true,
  );
  if (result.exitCode != 0) {
    context.logger.err('Failed to add flutter_multi_formatter: ${result.stderr}');
  } else {
    context.logger.info('flutter_multi_formatter added successfully.');
  }
}

Future<void> exportAssets(HookContext context) async {
  final dir = Directory.current.path;
  const lines = [
    'phone_textfield.dart',
    'password_textfield.dart',
  ];
  final file = File('$dir/lib/src/common/widgets/textfield/widgets.dart');
  String content = file.existsSync() ? file.readAsStringSync() : '';
  for (final line in lines) {
    final exportLine = "export '$line';\n";
    if (!content.contains(exportLine)) {
      file.writeAsStringSync(exportLine, mode: FileMode.append);
      content += exportLine;
    }
  }
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
