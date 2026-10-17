import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'advertisement.dart';
import 'ec_key.dart';
import 'jose_util.dart';

/// A clevis-compatible tang client.
///
/// Implements the provisioning (encryption) and recovery (decryption) steps
/// of the tang protocol as performed by `clevis encrypt tang` and
/// `clevis decrypt tang`.
class TangClient {
  TangClient({HttpClient? httpClient}) : _http = httpClient ?? HttpClient();

  final HttpClient _http;

  /// Encrypts [plaintext] to the tang server at [url] and returns the
  /// compact serialized JWE. The binding key is discarded, so the plaintext
  /// can only be recovered with help of the server (network presence).
  Future<String> encrypt(String plaintext, String url) async {
    final advertisement = Advertisement.parse(await _fetchAdvertisement(url));
    final serverKey = advertisement.exchangeKey();
    final kid = serverKey.thumbprintS256();

    // Provisioning: ECDH-ES with an ephemeral key, then discard the
    // ephemeral private key (McCallum-Relyea binding).
    final ephemeral = TangEcKey.generate();
    final shared = ephemeral.ecdh(serverKey);
    final cek = _deriveCek(shared);

    final protectedHeader = <String, Object?>{
      'alg': 'ECDH-ES',
      'clevis': {
        'pin': 'tang',
        'tang': {'adv': advertisement.jwks, 'url': url},
      },
      'enc': 'A256GCM',
      'epk': ephemeral.publicJwk(includeAlg: false, includeKeyOps: false),
      'kid': kid,
    };

    return jweCompactEncrypt(
      protectedHeader: protectedHeader,
      cek: cek,
      plaintext: utf8.encode(plaintext),
    );
  }

  /// Decrypts a compact serialized [jwe] produced by [encrypt] (or by
  /// `clevis encrypt tang`) using the tang server referenced in its header.
  ///
  /// [recoveryUrl] overrides `clevis.tang.url` from the JWE header when
  /// contacting the server. This is useful when the binding server has moved
  /// and only the network location of `POST /rec/{kid}` differs; it does not
  /// affect the cryptography (the header, and with it the JWE AAD, stays
  /// untouched).
  Future<String> decrypt(String jwe, {String? recoveryUrl}) async {
    final parsed = JweCompact.parse(jwe);
    final header = parsed.protectedHeader;

    if (header['alg'] != 'ECDH-ES' || header['enc'] != 'A256GCM') {
      throw const FormatException('unsupported JWE algorithms');
    }
    final clevis = header['clevis'];
    if (clevis is! Map<String, Object?> || clevis['pin'] != 'tang') {
      throw const FormatException('JWE is not bound to a tang server');
    }
    final tang = clevis['tang'];
    if (tang is! Map<String, Object?>) {
      throw const FormatException('JWE is missing clevis.tang');
    }
    final url = tang['url'];
    final adv = tang['adv'];
    final kid = header['kid'];
    final epk = header['epk'];
    if (url is! String || adv is! Map<String, Object?> || kid is! String) {
      throw const FormatException('JWE is missing tang binding data');
    }
    if (epk is! Map<String, Object?>) {
      throw const FormatException('JWE is missing required epk parameter');
    }

    final advertisement = Advertisement.fromJwks(adv);
    final serverKey = advertisement.keys.cast<TangEcKey?>().firstWhere(
      (key) => key!.thumbprintS256() == kid,
      orElse: () => null,
    );
    if (serverKey == null) {
      throw const FormatException(
        'key thumbprint does not match advertisement',
      );
    }

    // Recovery: blind the stored client public key with a fresh ephemeral
    // key, ask the server to perform its half of the exchange, then unblind.
    final clientPublic = TangEcKey.fromJwk(epk);
    final ephemeral = TangEcKey.generate();
    final blinded = clientPublic.ecmrExchange(ephemeral);
    final recovered = await _postRec(recoveryUrl ?? url, kid, blinded);

    final z = ephemeral.ecdh(serverKey);
    final binding = recovered.ecmrExchange(z);
    final cek = _deriveCek(binding);

    try {
      return utf8.decode(parsed.decrypt(cek));
    } catch (_) {
      throw const FormatException('failed to decrypt JWE');
    }
  }

  Future<Map<String, Object?>> _fetchAdvertisement(String url) async {
    final uri = Uri.parse('$url/adv');
    final request = await _http.getUrl(uri);
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'unable to fetch advertisement: '
        '${response.statusCode}',
        uri: uri,
      );
    }
    final body = await utf8.decodeStream(response);
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('malformed advertisement');
    }
    return decoded;
  }

  Future<TangEcKey> _postRec(String url, String kid, TangEcKey blinded) async {
    final uri = Uri.parse('$url/rec/$kid');
    final request = await _http.postUrl(uri);
    request.headers.contentType = ContentType('application', 'jwk+json');
    request.write(jsonEncode(blinded.publicJwk()));
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'recovery request failed: ${response.statusCode}',
        uri: uri,
      );
    }
    final decoded = jsonDecode(await utf8.decodeStream(response));
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('malformed recovery reply');
    }
    return TangEcKey.fromJwk(decoded);
  }

  Uint8List _deriveCek(TangEcKey sharedPoint) {
    final z = intToFixedBytes(
      sharedPoint.point.x!.toBigInteger()!,
      p521CoordinateBytes,
    );
    return concatKdf(z: z, algorithmId: 'A256GCM');
  }
}
