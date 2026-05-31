import 'package:flutter/material.dart';

const _onColor = Color(0xFF9DB8CC);
const _offColor = Color(0xFF172230);

class LcdDigit extends StatelessWidget {
  final int digit;
  final double size;

  const LcdDigit({super.key, required this.digit, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.7),
      painter: _LcdPainter(digit: digit),
    );
  }
}

class LcdColon extends StatelessWidget {
  final double size;
  const LcdColon({super.key, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.6),
      painter: _LcdColonPainter(),
    );
  }
}

class _LcdColonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pw = w * 0.55;
    final ph = h * 0.2;
    final corner = pw * 0.3;

    final paint = Paint()
      ..color = _onColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH((w - pw) / 2, h * 0.10, pw, ph),
        Radius.circular(corner),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH((w - pw) / 2, h * 0.90, pw, ph),
        Radius.circular(corner),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _LcdPainter extends CustomPainter {
  final int digit;

  _LcdPainter({required this.digit});

  static const _segments = {
    0: [1, 1, 1, 1, 1, 1, 0],
    1: [0, 1, 1, 0, 0, 0, 0],
    2: [1, 1, 0, 1, 1, 0, 1],
    3: [1, 1, 1, 1, 0, 0, 1],
    4: [0, 1, 1, 0, 0, 1, 1],
    5: [1, 0, 1, 1, 0, 1, 1],
    6: [1, 0, 1, 1, 1, 1, 1],
    7: [1, 1, 1, 0, 0, 0, 0],
    8: [1, 1, 1, 1, 1, 1, 1],
    9: [1, 1, 1, 1, 0, 1, 1],
  };

  // [left, top, width, height] as fractions of total size
  static const _rects = [
    [0.18, 0.04, 0.64, 0.10], // a
    [0.80, 0.12, 0.16, 0.36], // b
    [0.80, 0.52, 0.16, 0.36], // c
    [0.18, 0.86, 0.64, 0.10], // d
    [0.04, 0.52, 0.16, 0.36], // e
    [0.04, 0.12, 0.16, 0.36], // f
    [0.18, 0.46, 0.64, 0.10], // g
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final segs = _segments[digit] ?? _segments[0]!;
    final w = size.width;
    final h = size.height;
    final corner = w * 0.12;

    for (var i = 0; i < 7; i++) {
      final r = _rects[i];
      final paint = Paint()
        ..color = segs[i] == 1 ? _onColor : _offColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(r[0] * w, r[1] * h, r[2] * w, r[3] * h),
          Radius.circular(corner),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LcdPainter old) => old.digit != digit;
}
