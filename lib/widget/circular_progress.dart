import 'dart:math';

import 'package:flutter/material.dart';

const double _stokeWidth = 20;

class _CircularProgressPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size sz) {
    final c = Offset(sz.width / 2, sz.height / 2);
    final r = min(sz.width, sz.height) / 2 - _stokeWidth / 2;

    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(c, r, bgPaint);

    final progressPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stokeWidth - 6
      ..strokeCap = StrokeCap.round;

    final startAngle = pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class CircularProgress extends StatelessWidget {
  final double progress;
  const CircularProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _CircularProgressPainter(progress: progress),
    );
  }
}
