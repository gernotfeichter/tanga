import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import 'jose_util.dart';

/// The NIST P-521 curve; the curve used by both jose's `ES512` and `ECMR`.
final ECDomainParameters p521 = ECDomainParameters('secp521r1');

final int p521CoordinateBytes = (p521.curve.fieldSize + 7) ~/ 8;

/// An elliptic curve key on P-521, usable both for ES512 signatures and for
/// the McCallum-Relyea (ECMR) exchange performed by tang.
class TangEcKey {
  TangEcKey._({required this.point, this.d, this.alg, this.keyOps});

  /// Public point of the key.
  final ECPoint point;

  /// Private scalar, `null` for public keys.
  final BigInt? d;

  /// Optional JOSE `alg` member (e.g. `ES512`, `ECMR`).
  final String? alg;

  /// Optional JOSE `key_ops` member (e.g. `[sign, verify]`).
  final List<String>? keyOps;

  bool get isPrivate => d != null;

  factory TangEcKey.fromPrivate({
    required BigInt d,
    String? alg,
    List<String>? keyOps,
  }) {
    final q = p521.G * d;
    if (q == null || q.isInfinity) {
      throw ArgumentError('invalid private scalar');
    }
    return TangEcKey._(point: q, d: d, alg: alg, keyOps: keyOps);
  }

  factory TangEcKey.generate({String? alg, List<String>? keyOps}) {
    final rnd = fortunaRandom();
    while (true) {
      final d = rnd.nextBigInteger(p521.curve.fieldSize);
      if (d > BigInt.zero && d < p521.n) {
        return TangEcKey.fromPrivate(d: d, alg: alg, keyOps: keyOps);
      }
    }
  }

  /// Parses a JWK. Private scalars (`d`) are accepted; the public point is
  /// recomputed from `d` when present so that inconsistent `x`/`y` values are
  /// rejected.
  factory TangEcKey.fromJwk(Map<String, Object?> jwk) {
    if (jwk['kty'] != 'EC') {
      throw FormatException('unsupported kty: ${jwk['kty']}');
    }
    if (jwk['crv'] != 'P-521') {
      throw FormatException('unsupported crv: ${jwk['crv']}');
    }
    final keyOps = jwk['key_ops'];
    final parsed = TangEcKey._(
      point: _pointFromCoords(jwk['x'], jwk['y']),
      d: jwk['d'] == null
          ? null
          : fixedBytesToInt(b64urlDecode(jwk['d']! as String)),
      alg: jwk['alg'] as String?,
      keyOps: keyOps == null ? null : List<String>.from(keyOps as List),
    );
    final d = parsed.d;
    if (d != null) {
      final expected = p521.G * d;
      if (expected == null ||
          expected.isInfinity ||
          expected.x!.toBigInteger() != parsed.point.x!.toBigInteger() ||
          expected.y!.toBigInteger() != parsed.point.y!.toBigInteger()) {
        throw const FormatException('JWK public point does not match d');
      }
    }
    return parsed;
  }

  static ECPoint _pointFromCoords(Object? x, Object? y) {
    if (x is! String || y is! String) {
      throw const FormatException('JWK is missing x/y');
    }
    final xb = b64urlDecode(x);
    final yb = b64urlDecode(y);
    if (xb.length != p521CoordinateBytes || yb.length != p521CoordinateBytes) {
      throw const FormatException('invalid P-521 coordinate length');
    }
    final point = p521.curve.createPoint(
      fixedBytesToInt(xb),
      fixedBytesToInt(yb),
    );
    if (!_isOnCurve(point)) {
      throw const FormatException('point is not on curve P-521');
    }
    return point;
  }

  static bool _isOnCurve(ECPoint point) {
    final x = point.x!;
    final y = point.y!;
    final lhs = y * y;
    final rhs = x * x * x + p521.curve.a! * x + p521.curve.b!;
    return lhs.toBigInteger() == rhs.toBigInteger();
  }

  /// RFC 7638 JWK thumbprint using SHA-256 (jose's default `S256`).
  String thumbprintS256() {
    final jwk = publicJwk(includeAlg: false, includeKeyOps: false);
    final canonical =
        '{"crv":"${jwk['crv']}","kty":"${jwk['kty']}",'
        '"x":"${jwk['x']}","y":"${jwk['y']}"}';
    final digest = SHA256Digest();
    final hash = digest.process(Uint8List.fromList(canonical.codeUnits));
    return b64urlEncode(hash);
  }

  /// JWK representation of this key. Private material is only included when
  /// [includePrivate] is set.
  Map<String, Object?> publicJwk({
    bool includePrivate = false,
    bool includeAlg = true,
    bool includeKeyOps = true,
  }) {
    final jwk = <String, Object?>{};
    if (includeAlg && alg != null) jwk['alg'] = alg;
    jwk['crv'] = 'P-521';
    if (includeKeyOps && keyOps != null) jwk['key_ops'] = keyOps;
    jwk['kty'] = 'EC';
    jwk['x'] = b64urlEncode(
      intToFixedBytes(point.x!.toBigInteger()!, p521CoordinateBytes),
    );
    jwk['y'] = b64urlEncode(
      intToFixedBytes(point.y!.toBigInteger()!, p521CoordinateBytes),
    );
    if (includePrivate && d != null) {
      jwk['d'] = b64urlEncode(intToFixedBytes(d!, p521CoordinateBytes));
    }
    return jwk;
  }

  /// The shared point of an ECDH exchange: `d * other.point`.
  TangEcKey ecdh(TangEcKey other) {
    final scalar = d;
    if (scalar == null) {
      throw StateError('ECDH requires a private key');
    }
    final shared = other.point * scalar;
    if (shared == null || shared.isInfinity) {
      throw StateError('invalid ECDH result');
    }
    return TangEcKey._(point: shared);
  }

  /// Performs the jose `ECMR` key exchange, mirroring
  /// `jose_jwk_exc(..., "ECMR", ...)`:
  ///
  /// * if this key is private: `other.point * d`
  /// * otherwise: `point + other.point`, negated first when [other] is public
  ///   only as well.
  TangEcKey ecmrExchange(TangEcKey other) {
    final scalar = d;
    if (scalar != null) {
      return ecdh(other);
    }
    var result = other.point;
    if (!other.isPrivate) {
      result = -result;
    }
    final sum = point + result;
    if (sum == null || sum.isInfinity) {
      throw StateError('invalid ECMR result');
    }
    return TangEcKey._(point: sum);
  }

  /// ES512 signature over [data] as used in JWS: raw `R || S`, each component
  /// fixed width (66 bytes on P-521).
  Uint8List signEs512(List<int> data) {
    final scalar = d;
    if (scalar == null) {
      throw StateError('signing requires a private key');
    }
    final signer = ECDSASigner(SHA512Digest());
    signer.init(
      true,
      ParametersWithRandom(
        PrivateKeyParameter(ECPrivateKey(scalar, p521)),
        fortunaRandom(),
      ),
    );
    final sig = signer.generateSignature(Uint8List.fromList(data));
    if (sig is! ECSignature) {
      throw StateError('unexpected signature type');
    }
    return Uint8List.fromList([
      ...intToFixedBytes(sig.r, p521CoordinateBytes),
      ...intToFixedBytes(sig.s, p521CoordinateBytes),
    ]);
  }

  /// Verifies an ES512 signature in JWS `R || S` format.
  bool verifyEs512(List<int> data, List<int> signature) {
    if (signature.length != p521CoordinateBytes * 2) {
      return false;
    }
    final r = fixedBytesToInt(signature.sublist(0, p521CoordinateBytes));
    final s = fixedBytesToInt(signature.sublist(p521CoordinateBytes));
    final signer = ECDSASigner(SHA512Digest());
    signer.init(false, PublicKeyParameter(ECPublicKey(point, p521)));
    return signer.verifySignature(Uint8List.fromList(data), ECSignature(r, s));
  }
}
