import 'dart:convert';

import 'ec_key.dart';
import 'jose_util.dart';

/// The tang advertisement: a JWS (JSON serialization) whose payload is a
/// JWKSet of the server's public signing and exchange keys.
class Advertisement {
  Advertisement._(this.jws, this.jwks, this.keys);

  /// The full JWS as served by `GET /adv`.
  final Map<String, Object?> jws;

  /// The decoded JWKSet (`{"keys": [...]}` payload of the JWS).
  final Map<String, Object?> jwks;

  /// The public keys contained in [jwks].
  final List<TangEcKey> keys;

  /// Builds a signed advertisement from the private server keys.
  factory Advertisement.create({
    required List<TangEcKey> signingKeys,
    required List<TangEcKey> exchangeKeys,
  }) {
    final payloadKeys = <Map<String, Object?>>[
      for (final key in signingKeys)
        key.publicJwk(includeKeyOps: true)..['key_ops'] = const ['verify'],
      for (final key in exchangeKeys) key.publicJwk(),
    ];
    final jwks = {'keys': payloadKeys};
    final payload = b64urlEncode(utf8.encode(jsonEncode(jwks)));

    final signatures = <Map<String, Object?>>[];
    for (final key in signingKeys) {
      final protected = b64urlEncode(
        utf8.encode(jsonEncode({'alg': 'ES512', 'cty': 'jwk-set+json'})),
      );
      final signature = key.signEs512(ascii.encode('$protected.$payload'));
      signatures.add({
        'protected': protected,
        'signature': b64urlEncode(signature),
      });
    }
    return Advertisement._(
      {'payload': payload, 'signatures': signatures},
      jwks,
      [...payloadKeys.map(TangEcKey.fromJwk)],
    );
  }

  /// Parses an advertisement fetched from a server and verifies that at least
  /// one valid ES512 signature exists over the payload (like clevis does).
  ///
  /// Both the general and flattened JWS serializations are accepted; `jose`
  /// emits the flattened form for single-signature JWS.
  factory Advertisement.parse(Map<String, Object?> jws) {
    final payload = jws['payload'];
    if (payload is! String) {
      throw const FormatException('malformed advertisement');
    }

    final List<Map<String, Object?>> signatures;
    if (jws['signatures'] is List) {
      signatures = [
        for (final signature in jws['signatures'] as List)
          if (signature is Map) Map<String, Object?>.from(signature),
      ];
    } else if (jws['signature'] != null) {
      final flattened = Map<String, Object?>.from(jws)..remove('payload');
      signatures = [flattened];
    } else {
      throw const FormatException('malformed advertisement');
    }

    final jwks = jsonDecode(utf8.decode(b64urlDecode(payload)));
    if (jwks is! Map<String, Object?> || jwks['keys'] is! List) {
      throw const FormatException('malformed advertisement payload');
    }
    final keys = <TangEcKey>[
      for (final key in jwks['keys'] as List)
        TangEcKey.fromJwk(Map<String, Object?>.from(key as Map)),
    ];
    final signingKeys = [
      for (final key in keys)
        if (key.keyOps?.contains('verify') ?? false) key,
    ];

    var verified = false;
    for (final signature in signatures) {
      final protected = signature['protected'];
      final sig = signature['signature'];
      if (protected is! String || sig is! String) continue;
      final header = jsonDecode(utf8.decode(b64urlDecode(protected)));
      if (header is! Map<String, Object?> || header['alg'] != 'ES512') {
        continue;
      }
      final signingInput = ascii.encode('$protected.$payload');
      final raw = b64urlDecode(sig);
      for (final key in signingKeys) {
        if (key.verifyEs512(signingInput, raw)) {
          verified = true;
          break;
        }
      }
    }
    if (!verified) {
      throw const FormatException('advertisement is missing valid signatures');
    }
    return Advertisement._(jws, jwks, keys);
  }

  /// Parses a JWKS payload without verifying any signature. Only suitable
  /// for advertisements that were already bound to a trusted key, e.g. the
  /// `clevis.tang.adv` member embedded in a JWE.
  factory Advertisement.fromJwks(Map<String, Object?> jwks) {
    if (jwks['keys'] is! List) {
      throw const FormatException('malformed JWKSet');
    }
    return Advertisement._(<String, Object?>{}, jwks, [
      for (final key in jwks['keys'] as List)
        TangEcKey.fromJwk(Map<String, Object?>.from(key as Map)),
    ]);
  }

  /// The exchange key advertised with `key_ops` containing `deriveKey`.
  TangEcKey exchangeKey() {
    for (final key in keys) {
      if (key.keyOps?.contains('deriveKey') ?? false) return key;
    }
    throw const FormatException('advertisement contains no exchange key');
  }

  /// Finds a key by its S256 thumbprint.
  TangEcKey? findByThumbprint(String kid) {
    for (final key in keys) {
      if (key.thumbprintS256() == kid) return key;
    }
    return null;
  }
}
