import 'dart:async';

import 'package:flutter/material.dart';

/// Controller for managing the countdown timer state and actions
///
/// Provides methods to control the countdown timer:
/// - start: Starts the timer
/// - pause: Pauses the timer
/// - resume: Resumes the timer after being paused
/// - restart: Resets and starts the timer from the beginning
///
/// The controller also exposes callbacks that can be set to react to these actions.
class CountdownController {
  /// Called when the timer is started
  VoidCallback? onStart;

  /// Called when the timer is paused
  VoidCallback? onPause;

  /// Called when the timer is resumed after being paused
  VoidCallback? onResume;

  /// Called when the timer is restarted
  VoidCallback? onRestart;

  /// Indicates whether the timer has completed its countdown
  ///
  /// This can be used to check the timer state and perform actions accordingly
  /// 
  /// Example:
  /// ```dart
  /// controller.isCompleted ? controller.restart() : controller.pause();
  /// ```
  bool isCompleted = false;

  /// Whether the timer should start automatically when initialized
  final bool autoStart;

  /// Creates a new [CountdownController] with optional auto-start behavior
  CountdownController({this.autoStart = false});

  /// Starts the countdown timer
  void start() {
    onStart?.call();
  }

  /// Sets the callback to be executed when the timer starts
  void setOnStart(VoidCallback callback) {
    onStart = callback;
  }

  /// Pauses the countdown timer
  void pause() {
    onPause?.call();
  }

  /// Sets the callback to be executed when the timer is paused
  void setOnPause(VoidCallback callback) {
    onPause = callback;
  }

  /// Resumes the countdown timer after being paused
  void resume() {
    onResume?.call();
  }

  /// Sets the callback to be executed when the timer is resumed
  void setOnResume(VoidCallback callback) {
    onResume = callback;
  }

  /// Restarts the countdown timer from the beginning
  void restart() {
    onRestart?.call();
  }

  /// Sets the callback to be executed when the timer is restarted
  void setOnRestart(VoidCallback callback) {
    onRestart = callback;
  }

  /// Cleans up resources when the controller is no longer needed
  void dispose() {
    // Currently there are no resources to dispose
    // This method is provided for future expansions
  }
}

/// A customizable countdown timer widget
///
/// This widget provides a visual countdown timer with customizable appearance
/// through the [builder] function. The timer can be controlled manually using
/// the [CountdownController].
///
/// The [seconds] parameter defines the total duration of the countdown in seconds.
/// The [builder] function is called on each timer tick to update the UI.
/// The [interval] parameter defines how often the timer updates (default is 1 second).
/// The [onFinished] callback is triggered when the timer reaches zero.
/// The [onTap] callback is triggered when the user taps the widget after the timer completes.
///
/// Example Usage:
/// ```dart
/// // Basic usage with automatic start
/// Countdown(
///   seconds: 60,
///   build: (context, remainingSeconds) => Text(
///     '${remainingSeconds.toInt()} seconds remaining',
///     style: TextStyle(fontSize: 20),
///   ),
///   onFinished: () => print('Countdown finished!'),
/// )
///
/// // Advanced usage with controller
/// final controller = CountdownController();
/// 
/// // In your widget build method:
/// Column(
///   children: [
///     Countdown(
///       seconds: 30,
///       controller: controller,
///       build: (context, remainingSeconds) => Text(
///         remainingSeconds.toInt().toString(),
///         style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
///       ),
///       onFinished: () => showDialog(
///         context: context,
///         builder: (_) => AlertDialog(title: Text('Time\'s up!')),
///       ),
///     ),
///     SizedBox(height: 20),
///     // Control buttons
///     Row(
///       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///       children: [
///         ElevatedButton(
///           onPressed: () => controller.start(),
///           child: Text('Start'),
///         ),
///         ElevatedButton(
///           onPressed: () => controller.pause(),
///           child: Text('Pause'),
///         ),
///         ElevatedButton(
///           onPressed: () => controller.resume(),
///           child: Text('Resume'),
///         ),
///         ElevatedButton(
///           onPressed: () => controller.restart(),
///           child: Text('Restart'),
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class Countdown extends StatefulWidget {
  /// The total duration of the countdown in seconds
  final int seconds;

  /// Builder function to customize the appearance of the countdown timer
  /// 
  /// The double parameter represents the current seconds remaining
  final Widget Function(BuildContext, double) builder;

  /// Called when the countdown reaches zero
  final VoidCallback? onFinished;

  /// Called when the widget is tapped after countdown completion
  final VoidCallback? onTap;

  /// How frequently the timer should update
  final Duration interval;

  /// Controller to manage the countdown timer state and actions
  final CountdownController? controller;

  /// Creates a new [Countdown] widget
  const Countdown({
    super.key,
    required this.seconds,
    required this.builder,
    this.interval = const Duration(seconds: 1),
    this.onFinished,
    this.onTap,
    this.controller,
  });

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  // Multiplier to convert seconds to microseconds for precise timing
  static const int _microsecondsPerSecond = 1000000;

  // Timer that drives the countdown
  Timer? _timer;

  // Tracks if the onFinished callback was already executed
  bool _onFinishedExecuted = false;

  // Current time remaining in microseconds
  late int _currentMicroSeconds;

  // Controller for the countdown
  late final CountdownController _controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize the controller or use the provided one
    _controller = widget.controller ?? CountdownController();
    _currentMicroSeconds = widget.seconds * _microsecondsPerSecond;
    
    // Set up controller callbacks
    _controller.setOnStart(_startTimer);
    _controller.setOnPause(_pauseTimer);
    _controller.setOnResume(_resumeTimer);
    _controller.setOnRestart(_restartTimer);
    _controller.isCompleted = false;

    if (_controller.autoStart) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(Countdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _currentMicroSeconds = widget.seconds * _microsecondsPerSecond;
    }
  }

  @override
  void dispose() {
    _controller.isCompleted = false;
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _controller.isCompleted ? widget.onTap : null,
      child: widget.builder(
        context, 
        _currentMicroSeconds / _microsecondsPerSecond,
      ),
    );
  }

  /// Pauses the countdown timer
  void _pauseTimer() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
  }

  /// Resumes the countdown timer after being paused
  void _resumeTimer() {
    _startTimer();
  }

  /// Restarts the countdown timer from the beginning
  void _restartTimer() {
    _controller.isCompleted = false;
    _onFinishedExecuted = false;

    if (mounted) {
      setState(() {
        _currentMicroSeconds = widget.seconds * _microsecondsPerSecond;
      });
      _startTimer();
    }
  }

  /// Starts the countdown timer
  void _startTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
      _controller.isCompleted = true;
    }

    if (_currentMicroSeconds != 0) {
      _timer = Timer.periodic(
        widget.interval,
        (Timer timer) {
          if (_currentMicroSeconds <= 0) {
            timer.cancel();
            
            if (mounted) {
              setState(() {
                if (widget.onFinished != null && !_onFinishedExecuted) {
                  widget.onFinished!();
                  _onFinishedExecuted = true;
                }
                _controller.isCompleted = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _currentMicroSeconds = 
                    _currentMicroSeconds - widget.interval.inMicroseconds;
              });
            }
          }
        },
      );
    } else if (!_onFinishedExecuted) {
      if (widget.onFinished != null) {
        widget.onFinished!();
        _onFinishedExecuted = true;
      }
      _controller.isCompleted = true;
    }
  }
}
