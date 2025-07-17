import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'countdown.dart';

/// Hook for easily creating and managing [CountdownController] instances
///
/// This hook ensures proper lifecycle management for countdown controllers
/// when used in Flutter Hooks context. The controller will be automatically
/// disposed when the widget using it is removed.
///
/// Example usage:
/// ```dart
/// final countdownController = useCountdownController(autoStart: true);
/// ```
///
/// Example with a complete widget:
/// ```dart
/// class CountdownExample extends HookWidget {
///   const CountdownExample({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // Create a countdown controller with hooks
///     final countdownController = useCountdownController(autoStart: false);
///     
///     return Column(
///       children: [
///         // Countdown widget with the hooked controller
///         Countdown(
///           seconds: 60,
///           controller: countdownController,
///           build: (context, remaining) => Text(
///             '${remaining.toInt()} seconds',
///             style: TextStyle(fontSize: 24),
///           ),
///           onFinished: () => ScaffoldMessenger.of(context).showSnackBar(
///             SnackBar(content: Text('Time\'s up!')),
///           ),
///         ),
///         
///         // Control buttons row
///         Padding(
///           padding: const EdgeInsets.all(16.0),
///           child: Row(
///             mainAxisAlignment: MainAxisAlignment.spaceAround,
///             children: [
///               IconButton(
///                 icon: Icon(Icons.play_arrow),
///                 onPressed: () => countdownController.start(),
///               ),
///               IconButton(
///                 icon: Icon(Icons.pause),
///                 onPressed: () => countdownController.pause(),
///               ),
///               IconButton(
///                 icon: Icon(Icons.replay),
///                 onPressed: () => countdownController.restart(),
///               ),
///             ],
///           ),
///         ),
///       ],
///     );
///   }
/// }
/// ```
const useCountdownController = _CountdownControllerHookCreator();

/// Internal creator class for the countdown controller hook pattern
class _CountdownControllerHookCreator {
  const _CountdownControllerHookCreator();

  /// Creates and returns a [CountdownController] with proper lifecycle management
  ///
  /// The [autoStart] parameter determines whether the timer should start automatically
  /// once created. The [keys] parameter allows controlling when the hook should
  /// recreate the controller.
  CountdownController call({bool autoStart = true, List<Object?>? keys}) {
    return use(_CountdownControllerHook(autoStart, keys));
  }
}

/// Hook implementation for [CountdownController]
class _CountdownControllerHook extends Hook<CountdownController> {
  const _CountdownControllerHook(
    this.autoStart, [
    List<Object?>? keys,
  ]) : super(keys: keys);

  /// Whether the timer should start automatically when created
  final bool autoStart;

  @override
  _CountdownControllerHookState createState() {
    return _CountdownControllerHookState();
  }
}

/// State class for the countdown controller hook
class _CountdownControllerHookState
    extends HookState<CountdownController, _CountdownControllerHook> {
  /// The controller instance that will be managed by this hook
  late final _controller = CountdownController(autoStart: hook.autoStart);

  @override
  CountdownController build(BuildContext context) => _controller;

  @override
  void dispose() => _controller.dispose();

  @override
  String get debugLabel => 'useCountdownController';
}
