import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/widget/circular_progress.dart';

const _FOCUS = 25 * 60;
const _BREAK = 25 * 60;
const _REST = 25 * 60;
const _DEBUG_TIMER = 10;

enum TimerType { tfocus, tbreak, trest }

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;

  int _timeLeft = _FOCUS;
  bool _isRunning = false;

  void _startCountdown() {
    if (_isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timeLeft = 0;
          _isRunning = false;
          _timer?.cancel();
          _timer = null;
        }
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseCountdown() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _setTimer() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 200),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: Text("FOCUS"),
              selected: true,
              onSelected: (_) {},
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: Text("BREAK"),
              selected: false,
              onSelected: (_) {},
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: Text("REST"),
              selected: false,
              onSelected: (_) {},
            ),
          ],
        ),
        SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgress(progress: _timeLeft / _FOCUS),
            Text(
              toTime(_timeLeft),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 24),
        IconButton(
          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
          iconSize: 48,
          onPressed: () {
            if (_isRunning) {
              _pauseCountdown();
            } else {
              _startCountdown();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}

String toTime(int seconds) {
  final min = (seconds / 60).toInt();
  final sec = seconds % 60;

  String addZero(int n) => n < 10 ? "0$n" : "$n";
  return "${addZero(min)}:${addZero(sec)}";
}
