import 'package:mason/mason.dart';

void run(HookContext context) {
  final provider = context.vars['provider'];
  context.vars['is_riverpod'] = provider == 'riverpod';
  context.vars['is_bloc'] = provider == 'bloc';
}
