import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GameTimer extends StatefulWidget {
  final int durationInSeconds;
  final VoidCallback? onTimerComplete;

  const GameTimer({
    super.key,
    required this.durationInSeconds,
    this.onTimerComplete,
  });

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late Timer _timer;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInSeconds;
  }

  void startTimer() {
    if (_isRunning) return;
    
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          _isRunning = false;
          widget.onTimerComplete?.call();
        }
      });
    });
  }

  void pauseTimer() {
    if (!_isRunning) return;
    _timer.cancel();
    setState(() => _isRunning = false);
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _remainingSeconds = widget.durationInSeconds;
      _isRunning = false;
    });
  }

  String get timeDisplay {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          timeDisplay,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _isRunning ? pauseTimer : startTimer,
              icon: Icon(
                _isRunning ? Icons.pause : Icons.play_arrow,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: resetTimer,
              icon: const Icon(
                Icons.replay,
                size: 32,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 