import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro_flutter/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const PomodoroApp());
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);
  });
}
