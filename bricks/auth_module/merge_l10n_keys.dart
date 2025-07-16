import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> readKeysFile(String path) async {
  final file = File(path);
  if (await file.exists()) {
    return json.decode(await file.readAsString()) as Map<String, dynamic>;
  }
  return {};
}

void mergeKeys(Map<String, dynamic> data, Map<String, dynamic> keys) {
  for (final entry in keys.entries) {
    if (!data.containsKey(entry.key)) {
      final value = entry.value;
      if (value != null && value.toString().trim().isNotEmpty) {
        data[entry.key] = value;
      }
    }
  }
}

void main() async {
  // Lấy keys từ bricks/auth_module/l10n
  final keysEn = await readKeysFile('bricks/auth_module/l10n/auth_l10n_keys.arb');
  final keysHans = await readKeysFile('bricks/auth_module/l10n/auth_l10n_keys_zh_Hans.arb');
  final keysHant = await readKeysFile('bricks/auth_module/l10n/auth_l10n_keys_zh_Hant.arb');
  final l10nDir = Directory('assets/l10n');

  if (!await l10nDir.exists()) {
    print('assets/l10n directory not found!');
    exit(1);
  }

  final arbFiles = l10nDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb') && f.path.contains('intl_'));

  for (final file in arbFiles) {
    final content = await file.readAsString();
    final data = json.decode(content) as Map<String, dynamic>;
    if (file.path.contains('zh_Hans')) {
      mergeKeys(data, keysHans);
    } else if (file.path.contains('zh_Hant')) {
      mergeKeys(data, keysHant);
    } else if (file.path.contains('en')) {
      mergeKeys(data, keysEn);
    }
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(data));
  }
  print('Merged localization keys into all existing intl_*.arb files in assets/l10n/.');
} 