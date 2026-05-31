import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/widget/circular_progress.dart';

const _FOCUS = 25 * 60;
const _BREAK = 5 * 60;
const _REST = 15 * 60;

enum TimerType { tfocus, tbreak, trest }

const _glowColor = Color(0xFF00E5FF);
const _glassBg = Color(0x1AFFFFFF);
const _glassBorder = Color(0x33FFFFFF);

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  int _timeLeft = _FOCUS;
  bool _isRunning = false;
  TimerType _currentType = TimerType.tfocus;

  int get _totalTime {
    switch (_currentType) {
      case TimerType.tfocus:
        return _FOCUS;
      case TimerType.tbreak:
        return _BREAK;
      case TimerType.trest:
        return _REST;
    }
  }

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
    setState(() => _isRunning = true);
  }

  void _pauseCountdown() {
    _timer?.cancel();
    _timer = null;
    setState(() => _isRunning = false);
  }

  void _selectTimer(TimerType type) {
    if (_isRunning) {
      _timer?.cancel();
      _timer = null;
    }
    setState(() {
      _currentType = type;
      _timeLeft = _totalTime;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        _buildModeSelector(),
        const Spacer(flex: 1),
        _buildTimerDisplay(),
        const Spacer(flex: 1),
        _buildPlayButton(),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _buildModeSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: _glassBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _glassBorder, width: 0.5),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModeButton('FOCUS', TimerType.tfocus),
              const SizedBox(width: 2),
              _buildModeButton('BREAK', TimerType.tbreak),
              const SizedBox(width: 2),
              _buildModeButton('REST', TimerType.trest),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, TimerType type) {
    final selected = _currentType == type;
    return GestureDetector(
      onTap: () => _selectTimer(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? _glowColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? _glowColor.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
            color: selected ? _glowColor : Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgress(progress: _timeLeft / _totalTime),
            _buildGlowText(),
          ],
        ),
      ],
    );
  }

  Widget _buildGlowText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          toTime(_timeLeft),
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w200,
            letterSpacing: 6,
            color: _glowColor,
            fontFamily: 'monospace',
            shadows: [
              Shadow(color: _glowColor.withValues(alpha: 0.8), blurRadius: 20),
              Shadow(color: _glowColor.withValues(alpha: 0.5), blurRadius: 40),
              Shadow(color: _glowColor.withValues(alpha: 0.3), blurRadius: 80),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _currentType == TimerType.tfocus
              ? 'FOCUS'
              : _currentType == TimerType.tbreak
              ? 'BREAK'
              : 'REST',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: () {
        if (_isRunning) {
          _pauseCountdown();
        } else {
          _startCountdown();
        }
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _glowColor.withValues(alpha: 0.1),
          border: Border.all(
            color: _glowColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _glowColor.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Center(
              child: Icon(
                _isRunning ? Icons.pause : Icons.play_arrow,
                color: _glowColor,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String toTime(int seconds) {
  final min = (seconds / 60).toInt();
  final sec = seconds % 60;
  String addZero(int n) => n < 10 ? "0$n" : "$n";
  return "${addZero(min)}:${addZero(sec)}";
}
