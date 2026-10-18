import 'dart:convert';
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// JOSE base64url encoding without padding (RFC 7515).
String b64urlEncode(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

/// JOSE base64url decoding, tolerating missing padding.
Uint8List b64urlDecode(String input) =>
    base64Url.decode(base64Url.normalize(input));

/// Pads [value] to a fixed [length] big-endian byte string.
Uint8List intToFixedBytes(BigInt value, int length) {
  final out = Uint8List(length);
  var v = value;
  for (var i = length - 1; i >= 0; i--) {
    out[i] = (v & BigInt.from(0xff)).toInt();
    v = v >> 8;
  }
  if (v != BigInt.zero) {
    throw ArgumentError('value does not fit in $length bytes');
  }
  return out;
}

/// Reads a big-endian integer from [bytes].
BigInt fixedBytesToInt(List<int> bytes) {
  var v = BigInt.zero;
  for (final b in bytes) {
    v = (v << 8) | BigInt.from(b);
  }
  return v;
}

Uint8List randomBytes(int length, {Random? random}) {
  final rnd = random ?? Random.secure();
  return Uint8List.fromList(
    List<int>.generate(length, (_) => rnd.nextInt(256)),
  );
}

SecureRandom fortunaRandom() {
  final rnd = FortunaRandom();
  rnd.seed(KeyParameter(randomBytes(32)));
  return rnd;
}

/// Concatenated key derivation function with SHA-256 as used by
/// jose for `ECDH-ES` (RFC 7518 section 4.6).
Uint8List concatKdf({
  required Uint8List z,
  required String algorithmId,
  List<int> partyU = const <int>[],
  List<int> partyV = const <int>[],
  int keyDataLengthBits = 256,
}) {
  final otherInfo = Uint8List.fromList(<int>[
    ..._kdfField(utf8.encode(algorithmId)),
    ..._kdfField(partyU),
    ..._kdfField(partyV),
    ..._be32(keyDataLengthBits),
  ]);

  final out = Uint8List(keyDataLengthBits ~/ 8);
  final digest = SHA256Digest();
  final block = Uint8List(digest.digestSize);
  final blocks = (out.length + digest.digestSize - 1) ~/ digest.digestSize;
  for (var counter = 1; counter <= blocks; counter++) {
    digest.reset();
    final counterBytes = _be32(counter);
    digest.update(counterBytes, 0, counterBytes.length);
    digest.update(z, 0, z.length);
    digest.update(otherInfo, 0, otherInfo.length);
    digest.doFinal(block, 0);
    final offset = (counter - 1) * digest.digestSize;
    final take = (out.length - offset).clamp(0, digest.digestSize);
    out.setRange(offset, offset + take, block);
  }
  return out;
}

Uint8List _kdfField(List<int> data) {
  final out = Uint8List(4 + data.length);
  out.setRange(0, 4, _be32(data.length));
  out.setRange(4, out.length, data);
  return out;
}

Uint8List _be32(int value) => Uint8List.fromList([
  (value >> 24) & 0xff,
  (value >> 16) & 0xff,
  (value >> 8) & 0xff,
  value & 0xff,
]);

/// AES-256-GCM encryption; returns ciphertext followed by the 16 byte tag.
Uint8List aesGcmEncrypt({
  required Uint8List key,
  required Uint8List iv,
  required Uint8List aad,
  required Uint8List plaintext,
}) {
  final cipher = GCMBlockCipher(AESEngine());
  cipher.init(
    true,
    AEADParameters<KeyParameter>(KeyParameter(key), 128, iv, aad),
  );
  return cipher.process(plaintext);
}

/// AES-256-GCM decryption; [ciphertext] is followed by the 16 byte tag.
Uint8List aesGcmDecrypt({
  required Uint8List key,
  required Uint8List iv,
  required Uint8List aad,
  required Uint8List ciphertext,
}) {
  final cipher = GCMBlockCipher(AESEngine());
  cipher.init(
    false,
    AEADParameters<KeyParameter>(KeyParameter(key), 128, iv, aad),
  );
  return cipher.process(ciphertext);
}

/// Builds a compact serialized JWE using `dir`-style key agreement
/// (no encrypted key), as produced by jose for `ECDH-ES` + `A256GCM`.
String jweCompactEncrypt({
  required Map<String, Object?> protectedHeader,
  required Uint8List cek,
  required Uint8List plaintext,
}) {
  final protected = b64urlEncode(utf8.encode(jsonEncode(protectedHeader)));
  final iv = randomBytes(12);
  final aad = Uint8List.fromList(ascii.encode(protected));
  final sealed = aesGcmEncrypt(
    key: cek,
    iv: iv,
    aad: aad,
    plaintext: plaintext,
  );
  final ciphertext = sealed.sublist(0, sealed.length - 16);
  final tag = sealed.sublist(sealed.length - 16);
  return '$protected..${b64urlEncode(iv)}.${b64urlEncode(ciphertext)}.'
      '${b64urlEncode(tag)}';
}

class JweCompact {
  JweCompact(this.protectedHeader, this.protectedB64, this.iv, this.sealed);

  final Map<String, Object?> protectedHeader;
  final String protectedB64;
  final Uint8List iv;

  /// Ciphertext followed by the tag.
  final Uint8List sealed;

  static JweCompact parse(String jwe) {
    final parts = jwe.trim().split('.');
    if (parts.length != 5) {
      throw FormatException('expected a compact JWE with 5 parts', jwe);
    }
    final protected = jsonDecode(utf8.decode(b64urlDecode(parts[0])));
    if (protected is! Map<String, Object?>) {
      throw const FormatException('invalid JWE protected header');
    }
    return JweCompact(
      protected,
      parts[0],
      b64urlDecode(parts[2]),
      Uint8List.fromList([
        ...b64urlDecode(parts[3]),
        ...b64urlDecode(parts[4]),
      ]),
    );
  }

  Uint8List decrypt(Uint8List cek) => aesGcmDecrypt(
    key: cek,
    iv: iv,
    aad: Uint8List.fromList(ascii.encode(protectedB64)),
    ciphertext: sealed,
  );
}
