import 'dart:math';

import 'package:flutter/material.dart';

class _CircularProgressPainter extends CustomPainter {
  static const double WID_STROKE = 2;

  final double progress; // 0.0 ~ 1.0

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size sz) {
    final c = Offset(sz.width / 2, sz.height / 2);
    final r = min(sz.width, sz.height) / 2 - WID_STROKE / 2;

    final bg = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(c, r, bg);
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
