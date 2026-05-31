import 'dart:math';
import 'package:flutter/material.dart';

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size sz) {
    final c = Offset(sz.width / 2, sz.height / 2);
    final outerR = min(sz.width, sz.height) / 2 - 4;

    final glowPaint = Paint()
      ..color = const Color(0x3300E5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(c, outerR, glowPaint);

    final bgPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.03),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.02),
          Colors.white.withValues(alpha: 0.08),
        ],
      ).createShader(Rect.fromCircle(center: c, radius: outerR + 6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(c, outerR, bgPaint);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: -pi / 2 + 2 * pi * progress,
        colors: [
          const Color(0xFF00E5FF),
          const Color(0xFF0077FF),
          const Color(0xFF00E5FF),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: outerR + 6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: outerR),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.8,
        colors: [
          Colors.white.withValues(alpha: 0.15),
          Colors.transparent,
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, sz.width, sz.height));

    canvas.drawCircle(c, outerR, highlightPaint);
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
      size: const Size(240, 240),
      painter: _CircularProgressPainter(progress: progress),
    );
  }
}
