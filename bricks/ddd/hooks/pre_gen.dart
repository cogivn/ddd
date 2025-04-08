import 'package:mason/mason.dart';

void run(HookContext context) {
  final provider = context.vars['provider'];
  context.vars['is_riverbloc'] = provider == 'riverbloc';
  context.vars['is_bloc'] = provider == 'bloc';
  context.vars['is_riverpod'] = provider == 'riverpod';
}
