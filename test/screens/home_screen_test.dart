import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro_flutter/main.dart';

void main() {
  testWidgets('App renders POMODORO branding', (WidgetTester tester) async {
    await tester.pumpWidget(const PomodoroApp());
    expect(find.text('POMODORO'), findsOneWidget);
  });
}
