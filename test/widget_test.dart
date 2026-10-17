import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tanga/main.dart';

void main() {
  testWidgets('shows the tang server start controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TangaApp());

    expect(find.text('tanga - tang server'), findsOneWidget);
    expect(find.text('status: stopped'), findsOneWidget);
    expect(find.textContaining('Start tang server'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
