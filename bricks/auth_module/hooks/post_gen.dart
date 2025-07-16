import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  // Chạy script merge từ root workspace để assets/l10n đúng
  final result = await Process.run(
    'dart',
    ['bricks/auth_module/merge_l10n_keys.dart'],
    runInShell: true,
    workingDirectory: Directory.current.path, // Đảm bảo chạy từ workspace root
  );
  if (result.exitCode != 0) {
    context.logger.err('Failed to merge l10n keys: \n${result.stderr}');
  } else {
    context.logger.info('Merged l10n keys successfully!');
  }
} 