import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanga/tang/server.dart';

/// Runs the real clevis toolchain (`clevis encrypt tang` /
/// `clevis decrypt tang`) against the Dart tang server, i.e. exactly what
/// `test/encrypt-decrypt.sh` does. Skipped when clevis/jose are unavailable.
void main() {
  test(
    'clevis encrypt/decrypt a string against the Dart tang server',
    () async {
      final clevis = await _which('clevis');
      final jose = await _which('jose');
      if (clevis == null || jose == null) {
        markTestSkipped('clevis and jose are required for this test');
        return;
      }

      final server = TangServer.generate();
      await server.start(address: InternetAddress.loopbackIPv4, port: 0);
      addTearDown(server.stop);
      final url = 'http://127.0.0.1:${server.port}';

      final environment = {
        ...Platform.environment,
        'PATH': '${jose.parent.path}:${Platform.environment['PATH']}',
      };

      final encrypted = await _run(
        clevis,
        [
          'encrypt',
          'tang',
          jsonEncode({'url': url}),
          '-y',
        ],
        environment: environment,
        stdin: utf8.encode('PLAINTEXT'),
      );
      expect(
        encrypted.code,
        0,
        reason: 'clevis encrypt failed: ${encrypted.err}',
      );
      final jwe = encrypted.out;
      expect(utf8.decode(jwe), isNot(contains('PLAINTEXT')));

      final decrypted = await _run(
        clevis,
        ['decrypt', 'tang'],
        environment: environment,
        stdin: jwe,
      );
      expect(
        decrypted.code,
        0,
        reason: 'clevis decrypt failed: ${decrypted.err}',
      );
      expect(utf8.decode(decrypted.out), 'PLAINTEXT');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

class _Result {
  const _Result(this.code, this.out, this.err);

  final int code;
  final List<int> out;
  final String err;
}

Future<_Result> _run(
  File executable,
  List<String> arguments, {
  List<int>? stdin,
  Map<String, String>? environment,
}) async {
  final process = await Process.start(
    executable.path,
    arguments,
    environment: environment,
  );
  if (stdin != null) process.stdin.add(stdin);
  await process.stdin.close();
  final out = <int>[];
  await process.stdout.forEach(out.addAll);
  final err = await process.stderr.transform(utf8.decoder).join();
  final code = await process.exitCode;
  return _Result(code, out, err);
}

Future<File?> _which(String command) async {
  for (final dir in (Platform.environment['PATH'] ?? '').split(':')) {
    if (dir.isEmpty) continue;
    final candidate = File('$dir/$command');
    if (await candidate.exists()) return candidate;
  }
  return null;
}
