import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/constants/app_colors.dart';
import 'package:pomodoro_flutter/models/timer_type.dart';
import 'package:pomodoro_flutter/widgets/lcd_digits.dart';

const _FOCUS = 25 * 60;
const _BREAK = 5 * 60;
const _REST = 15 * 60;

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

  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _timeLeft = _totalTime;
      _isRunning = false;
    });
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
        _buildBrand(),
        const SizedBox(height: 24),
        _buildModeIndicators(),
        const SizedBox(height: 12),
        _buildWatchFace(),
        const SizedBox(height: 24),
        _buildControls(),
      ],
    );
  }

  Widget _buildBrand() {
    return Text(
      'POMODORO',
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 4,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.25),
      ),
    );
  }

  Widget _buildModeIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _modeIndicator('FOCUS', TimerType.tfocus),
        const SizedBox(width: 16),
        _modeIndicator('BREAK', TimerType.tbreak),
        const SizedBox(width: 16),
        _modeIndicator('REST', TimerType.trest),
      ],
    );
  }

  Widget _modeIndicator(String label, TimerType type) {
    final selected = _currentType == type;
    return GestureDetector(
      onTap: () => _selectTimer(type),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 2,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? onColor : Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildWatchFace() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bezelColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: screenColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        child: Column(
          children: [
            _buildProgressBar(),
            const SizedBox(height: 12),
            _buildLcdTime(),
            const SizedBox(height: 4),
            _buildBottomLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = _timeLeft / _totalTime;
    return ClipRRect(
      borderRadius: BorderRadius.circular(1),
      child: SizedBox(
        height: 4,
        child: Row(
          children: List.generate(20, (i) {
            final filled = i / 20 < progress;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: filled
                      ? onColor.withValues(alpha: 0.7)
                      : offColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLcdTime() {
    final min = (_timeLeft / 60).toInt();
    final sec = _timeLeft % 60;
    final m1 = min ~/ 10;
    final m2 = min % 10;
    final s1 = sec ~/ 10;
    final s2 = sec % 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LcdDigit(digit: m1, size: 28),
        const SizedBox(width: 2),
        LcdDigit(digit: m2, size: 28),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: LcdColon(size: 8),
        ),
        LcdDigit(digit: s1, size: 28),
        const SizedBox(width: 2),
        LcdDigit(digit: s2, size: 28),
      ],
    );
  }

  Widget _buildBottomLabel() {
    final label = _currentType == TimerType.tfocus
        ? 'FOCUS'
        : _currentType == TimerType.tbreak
        ? 'BREAK'
        : 'REST';
    return Text(
      label,
      style: TextStyle(
        fontSize: 9,
        letterSpacing: 3,
        color: onColor.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _watchButton(
          icon: _isRunning ? Icons.pause : Icons.play_arrow,
          onTap: () {
            if (_isRunning) {
              _pauseCountdown();
            } else {
              _startCountdown();
            }
          },
        ),
        const SizedBox(width: 40),
        _watchButton(icon: Icons.replay_outlined, onTap: _resetTimer),
      ],
    );
  }

  Widget _watchButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          color: bezelColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(icon, color: onColor.withValues(alpha: 0.7), size: 18),
        ),
      ),
    );
  }
}
