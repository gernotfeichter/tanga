import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'advertisement.dart';
import 'ec_key.dart';
import 'jose_util.dart';

/// A pure Dart implementation of the tang server HTTP API
/// (`GET /adv`, `GET /adv/{kid}`, `POST /rec/{kid}`).
class TangServer {
  TangServer({required this.signingKeys, required this.exchangeKeys});

  /// Generates a fresh server with one signing and one exchange key.
  factory TangServer.generate() => TangServer(
    signingKeys: [
      TangEcKey.generate(alg: 'ES512', keyOps: const ['sign', 'verify']),
    ],
    exchangeKeys: [
      TangEcKey.generate(alg: 'ECMR', keyOps: const ['deriveKey']),
    ],
  );

  /// Loads server keys from JWK maps (private material required).
  factory TangServer.fromJwks({
    required List<Map<String, Object?>> signingKeys,
    required List<Map<String, Object?>> exchangeKeys,
  }) => TangServer(
    signingKeys: [for (final jwk in signingKeys) TangEcKey.fromJwk(jwk)],
    exchangeKeys: [for (final jwk in exchangeKeys) TangEcKey.fromJwk(jwk)],
  );

  final List<TangEcKey> signingKeys;
  final List<TangEcKey> exchangeKeys;

  HttpServer? _httpServer;
  Advertisement? _advertisement;

  bool get isRunning => _httpServer != null;

  int get port => _httpServer?.port ?? 0;

  Uri get uri =>
      Uri.parse('http://${_httpServer?.address.address ?? '0.0.0.0'}:$port');

  Future<void> start({InternetAddress? address, int port = 7500}) async {
    if (_httpServer != null) {
      throw StateError('server already running');
    }
    _advertisement = Advertisement.create(
      signingKeys: signingKeys,
      exchangeKeys: exchangeKeys,
    );
    final server = await HttpServer.bind(
      address ?? InternetAddress.anyIPv4,
      port,
    );
    _httpServer = server;
    unawaited(_serve(server));
  }

  Future<void> stop() async {
    final server = _httpServer;
    _httpServer = null;
    if (server != null) {
      await server.close(force: true);
    }
  }

  Future<void> _serve(HttpServer server) async {
    try {
      await for (final request in server) {
        try {
          await _handle(request);
        } catch (_) {
          await _reply(request, HttpStatus.internalServerError);
        }
      }
    } on HttpException {
      // The server was closed.
    }
  }

  Future<void> _handle(HttpRequest request) async {
    final segments = request.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();

    if (segments.isEmpty ||
        segments.first != 'adv' && segments.first != 'rec') {
      await _reply(request, HttpStatus.notFound);
      return;
    }

    if (segments.first == 'adv') {
      if (request.method != 'GET') {
        await _reply(request, HttpStatus.methodNotAllowed);
        return;
      }
      await _handleAdv(request, segments);
      return;
    }

    if (request.method != 'POST') {
      await _reply(request, HttpStatus.methodNotAllowed);
      return;
    }
    await _handleRec(request, segments);
  }

  Future<void> _handleAdv(HttpRequest request, List<String> segments) async {
    final jws = Map<String, Object?>.from(_advertisement!.jws);
    if (segments.length == 2) {
      // `GET /adv/{kid}`: re-sign including the requested signing key, like
      // tang's `find_jws()`.
      final kid = segments[1];
      TangEcKey? requested;
      for (final key in signingKeys) {
        if (key.thumbprintS256() == kid) requested = key;
      }
      if (requested == null) {
        await _reply(request, HttpStatus.notFound);
        return;
      }
      final payload = jws['payload']! as String;
      final protected = b64urlEncode(
        utf8.encode(jsonEncode({'alg': 'ES512', 'cty': 'jwk-set+json'})),
      );
      jws['signatures'] = [
        {
          'protected': protected,
          'signature': b64urlEncode(
            requested.signEs512(ascii.encode('$protected.$payload')),
          ),
        },
      ];
    } else if (segments.length > 2) {
      await _reply(request, HttpStatus.notFound);
      return;
    }
    await _reply(
      request,
      HttpStatus.ok,
      body: jsonEncode(jws),
      contentType: 'application/jose+json',
    );
  }

  Future<void> _handleRec(HttpRequest request, List<String> segments) async {
    if (segments.length != 2) {
      await _reply(request, HttpStatus.notFound);
      return;
    }
    final kid = segments[1];

    TangEcKey? serverKey;
    for (final key in exchangeKeys) {
      if (key.thumbprintS256() == kid) serverKey = key;
    }
    if (serverKey == null) {
      await _reply(request, HttpStatus.notFound);
      return;
    }

    Map<String, Object?> body;
    try {
      final raw = await _readBody(request);
      final decoded = jsonDecode(utf8.decode(raw));
      if (decoded is! Map<String, Object?>) throw const FormatException();
      body = decoded;
    } catch (_) {
      await _reply(request, HttpStatus.badRequest);
      return;
    }

    if (body['kty'] != 'EC') {
      await _reply(request, HttpStatus.badRequest);
      return;
    }
    final alg = body['alg'];
    if (alg != null && alg != 'ECMR') {
      await _reply(request, HttpStatus.badRequest);
      return;
    }
    final keyOps = body['key_ops'];
    if (keyOps is List && !keyOps.contains('deriveKey')) {
      await _reply(request, HttpStatus.forbidden);
      return;
    }

    TangEcKey requestKey;
    try {
      requestKey = TangEcKey.fromJwk(body);
    } catch (_) {
      await _reply(request, HttpStatus.badRequest);
      return;
    }

    final TangEcKey result;
    try {
      result = serverKey.ecmrExchange(requestKey);
    } catch (_) {
      await _reply(request, HttpStatus.badRequest);
      return;
    }

    await _reply(
      request,
      HttpStatus.ok,
      body: jsonEncode({
        'alg': 'ECMR',
        'crv': 'P-521',
        'key_ops': ['deriveKey'],
        'kty': 'EC',
        'x': result.publicJwk(includeAlg: false, includeKeyOps: false)['x'],
        'y': result.publicJwk(includeAlg: false, includeKeyOps: false)['y'],
      }),
      contentType: 'application/jwk+json',
    );
  }

  static Future<Uint8List> _readBody(HttpRequest request) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in request) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  static Future<void> _reply(
    HttpRequest request,
    int statusCode, {
    String? body,
    String? contentType,
  }) async {
    final response = request.response;
    response.statusCode = statusCode;
    if (body != null) {
      response.headers.contentType = ContentType.parse(
        contentType ?? 'application/json',
      );
      response.write(body);
    }
    await response.close();
  }
}
