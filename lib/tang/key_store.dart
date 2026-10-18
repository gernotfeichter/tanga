import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'ec_key.dart';
import 'server.dart';

/// Loads the Tang server keys from local storage, generating and persisting a
/// fresh key pair on first use.
///
/// Persisting the keys keeps the server identity stable across restarts, which
/// is required for existing clevis bindings (they pin the thumbprint of the
/// exchange key and would otherwise break on every reboot).
class TangKeyStore {
  const TangKeyStore();

  static const _signingKeysKey = 'tang.signingKeys';
  static const _exchangeKeysKey = 'tang.exchangeKeys';

  Future<TangServer> loadOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    final signing = prefs.getString(_signingKeysKey);
    final exchange = prefs.getString(_exchangeKeysKey);
    if (signing != null && exchange != null) {
      try {
        return TangServer.fromJwks(
          signingKeys: _decodeJwks(signing),
          exchangeKeys: _decodeJwks(exchange),
        );
      } catch (_) {
        // Stored keys are unreadable; fall through and regenerate them.
      }
    }
    final server = TangServer.generate();
    await prefs.setString(_signingKeysKey, _encodeJwks(server.signingKeys));
    await prefs.setString(_exchangeKeysKey, _encodeJwks(server.exchangeKeys));
    return server;
  }

  static String _encodeJwks(List<TangEcKey> keys) => jsonEncode([
    for (final key in keys) key.publicJwk(includePrivate: true),
  ]);

  static List<Map<String, Object?>> _decodeJwks(String json) => [
    for (final key in jsonDecode(json) as List)
      Map<String, Object?>.from(key as Map),
  ];
}
