import 'package:mason/mason.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> run(HookContext context) async {
  // Install external packages
  await installExternalPackage(context);
  // Export assets
  await exportValueObjectsAssets(context);
  await exportTextFieldAssets(context);
  // Export common widgets
  await exportAssets(context);
  // Merge localization keys
  await mergeLocalizeKeys(context);
}

Future<void> installExternalPackage(HookContext context) async {
  await _installPinPut(context);
  await _installFlutterMultiFormatter(context);
}



Future<void> exportValueObjectsAssets(HookContext context) async {
  final dir = Directory.current.path;
  const lines = ['phone_number.dart'];
  final file =
      File('$dir/lib/src/core/domain/value_objects/value_objects.dart');
  if (!file.existsSync()) {
    // If file does not exist, create it and write all export lines
    final content = lines.map((line) => "export '$line';\n").join();
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  } else {
    // If file exists, append missing export lines
    String content = file.readAsStringSync();
    for (final line in lines) {
      final exportLine = "export '$line';\n";
      if (!content.contains(exportLine)) {
        file.writeAsStringSync(exportLine, mode: FileMode.append);
        content += exportLine;
      }
    }
  }
}

Future<void> exportTextFieldAssets(HookContext context) async {
  final dir = Directory.current.path;
  const lines = ['phone_textfield.dart'];
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

Future<void> exportAssets(HookContext context) async {
  final dir = Directory.current.path;
  const lines = ['countdown/widgets.dart'];
  final file = File('$dir/lib/src/common/widgets/widgets.dart');
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

Future<void> _installPinPut(HookContext context) async {
  final result = await Process.run(
    'flutter',
    ['pub', 'add', 'pinput'],
    runInShell: true,
  );
  if (result.exitCode != 0) {
    context.logger.err('Failed to add pinput: ${result.stderr}');
  } else {
    context.logger.info('pinput added successfully.');
  }
}

String upLevels(String path, int levels) {
  var result = path;
  for (var i = 0; i < levels; i++) {
    result = p.dirname(result);
  }
  return result;
}
