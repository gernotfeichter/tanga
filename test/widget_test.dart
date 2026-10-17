import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tanga/main.dart';

void main() {
  testWidgets('shows the tang server settings and start control', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'port': 7500,
      'timeoutMinutes': 2,
    });

    await tester.pumpWidget(const TangaApp(autoStart: false));
    await tester.pumpAndSettle();

    expect(find.text('tang server'), findsOneWidget);
    expect(find.text('status: stopped'), findsOneWidget);
    expect(find.text('Port'), findsOneWidget);
    expect(find.text('Auto-stop after (minutes)'), findsOneWidget);
    expect(find.text('0 = never stop (forever)'), findsOneWidget);
    expect(find.textContaining('Start tang server'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
