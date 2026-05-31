import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/widgets/countdown_timer.dart';

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
        color: const Color(0xFF111111),
        child: SafeArea(child: Center(child: CountdownTimer())),
      ),
    );
  }
}
