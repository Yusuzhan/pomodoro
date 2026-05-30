import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/widget/circular_progress.dart';

const _DEFAULT_TIMER = 25 * 60;
const _DEBUG_TIMER = 10;

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;

  int _timeLeft = _DEFAULT_TIMER;
  bool _isRunning = false;

  void _startCountdown() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft == 0) {
          _isRunning = false;
          _timer.cancel();
        }
      });
      print("timeLeft: $_timeLeft");
    });
  }

  void _pauseCoutndown() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: CircularProgress(progress: 0.3)),
          SizedBox(height: 24),
          Text(toTime(_timeLeft)),
          SizedBox(height: 24),
          IconButton(
            icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
            iconSize: 48,
            onPressed: () {
              if (_isRunning) {
                _pauseCoutndown();
              } else {
                _startCountdown();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

String toTime(int seconds) {
  final min = (seconds / 60).toInt();
  final sec = seconds % 60;

  String addZero(int n) => n < 10 ? "0$n" : "$n";
  return "${addZero(min)}:${addZero(sec)}";
}
