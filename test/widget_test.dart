import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tanga/main.dart';
import 'package:tanga/tang/key_store.dart';

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

  testWidgets('shows and copies the key thumbprints', (WidgetTester tester) async {
    // Port 0 lets the OS choose a free port for the test server.
    SharedPreferences.setMockInitialValues({'port': 0, 'timeoutMinutes': 0});

    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(const TangaApp());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();

    final server = await const TangKeyStore().loadOrCreate();
    final signing = server.signingKeys.single;
    final exchange = server.exchangeKeys.single;

    expect(find.text('key thumbprints'), findsOneWidget);
    expect(
      find.text('Signing key (ES512) - SHA-256 / S256 (kid)'),
      findsOneWidget,
    );
    expect(find.text('Signing key (ES512) - SHA-1 / S1'), findsOneWidget);
    expect(find.text(signing.thumbprintS256()), findsOneWidget);
    expect(find.text(signing.thumbprintS1()), findsOneWidget);
    expect(
      find.text('Exchange key (ECMR) - SHA-256 / S256 (kid)'),
      findsOneWidget,
    );
    expect(find.text(exchange.thumbprintS256()), findsOneWidget);
    expect(find.byIcon(Icons.copy), findsNWidgets(4));

    await tester.ensureVisible(find.byIcon(Icons.copy).first);
    await tester.tap(find.byIcon(Icons.copy).first);
    await tester.pump();
    expect(calls.last.method, 'Clipboard.setData');
    final copied = (calls.last.arguments as Map)['text'];
    expect(
      copied is Map ? copied['text'] : copied,
      signing.thumbprintS256(),
    );
  });

  testWidgets('shows the thumbprints while the server is stopped', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'port': 0, 'timeoutMinutes': 0});

    await tester.pumpWidget(const TangaApp(autoStart: false));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
    expect(find.text('status: stopped'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('key thumbprints'), findsOneWidget);
    expect(find.byIcon(Icons.copy), findsNWidgets(4));
  });
}
