import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/widget/countdown_timer.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070A14),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF070A14),
              Color(0xFF0E1428),
              Color(0xFF0A0E1A),
              Color(0xFF070A14),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(child: Center(child: CountdownTimer())),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _GlassReflectionPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassReflectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-0.3, -0.2),
        end: Alignment(1.2, 1.5),
        colors: [
          Colors.transparent,
          Colors.transparent,
          Colors.white.withValues(alpha: 0.04),
          Colors.white.withValues(alpha: 0.07),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.42, 0.48, 0.54, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final floorPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.03),
              Colors.transparent,
            ],
            stops: const [0.0, 0.15, 0.4],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2),
          );

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2),
      floorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
