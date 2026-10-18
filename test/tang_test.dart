import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanga/tang/advertisement.dart';
import 'package:tanga/tang/client.dart';
import 'package:tanga/tang/ec_key.dart';
import 'package:tanga/tang/jose_util.dart';
import 'package:tanga/tang/server.dart';

// Server keys generated with `jose jwk gen -i '{"alg":"ES512"}'` and
// `jose jwk gen -i '{"alg":"ECMR"}'` (jose 14), exactly like tang's
// `tangd-keygen`.
const _joseSigningKeyJwk = {
  'alg': 'ES512',
  'crv': 'P-521',
  'd':
      'APPV0-kJfN4XGukV7I_YIoEgp-zVHOl_ydsnHIuCi2aUVk38P2WJUqLfNeX3oIIVpX_BkMfCnKpVH6e7vb9MRDZZ',
  'key_ops': ['sign', 'verify'],
  'kty': 'EC',
  'x':
      'AVDCR4ZbcBllAeFaNL_kRnAfn6aAATqBwx11faWUKGfTMB4thEJEKT95Pt5vzsMA1nuwK7hwH7taDs4jUntPcNlw',
  'y':
      'AcrUZFdbxxuAzvZ2CiQP_zhXwiQ2Y3tHbFvP08On3_rml7XTMu-MI3ljZBQsOiOPtmJaNfxj7h9zAP3PZF5aLRE8',
};

const _joseExchangeKeyJwk = {
  'alg': 'ECMR',
  'crv': 'P-521',
  'd':
      'Ab9JQSC2Wqwf9KL75IEmddRcx_02eHdUdY2VRQctNCiV4p0GF02wdvG5SC-4T_LUDC0ZwwSxTdvDTfLPbMXE7u3y',
  'key_ops': ['deriveKey'],
  'kty': 'EC',
  'x':
      'AYZdPq4ZLTU5WDD6omZN9BanWVYpXwwBj7FFeOhatUDeyEVYRWaon0niiipLRDaFKSLdmeq5piJ9alNh5OG32uCq',
  'y':
      'AWLe2s6dGKpYyaWrIkCPhm-cc4Yny9kTpbNAswltxC5koZwkHYYsMQEarLevFPaqrIzWo59qnDvyBBXtvSkSkosh',
};

const _joseExchangeKid = '5yMvrFEpUi66MHsBiX2ywcfRoDsvLUEdADeq9cdM4nk';

// `jose jws sig -s '{"protected":{"cty":"jwk-set+json"}}' -k sig.jwk -I -`
const _joseAdvertisementJws =
    '{"payload":"eyJrZXlzIjpbeyJhbGciOiJFUzUxMiIsImNydiI6IlAtNTIxIiwia2V5X29wcyI6WyJ2ZXJpZnkiXSwia3R5IjoiRUMiLCJ4IjoiQVZEQ1I0WmJjQmxsQWVGYU5MX2tSbkFmbjZhQUFUcUJ3eDExZmFXVUtHZlRNQjR0aEVKRUtUOTVQdDV2enNNQTFudXdLN2h3SDd0YURzNGpVbnRQY05sdyIsInkiOiJBY3JVWkZkYnh4dUF6dloyQ2lRUF96aFh3aVEyWTN0SGJGdlAwOE9uM19ybWw3WFRNdS1NSTNsalpCUXNPaU9QdG1KYU5meGo3aDl6QVAzUFpGNWFMUkU4In0seyJhbGciOiJFQ01SIiwiY3J2IjoiUC01MjEiLCJrZXlfb3BzIjpbImRlcml2ZUtleSJdLCJrdHkiOiJFQyIsIngiOiJBWVpkUHE0WkxUVTVXREQ2b21aTjlCYW5XVllwWHd3Qmo3RkZlT2hhdFVEZXlFVllSV2FvbjBuaWlpcExSRGFGS1NMZG1lcTVwaUo5YWxOaDVPRzMydUNxIiwieSI6IkFXTGUyczZkR0twWXlhV3JJa0NQaG0tY2M0WW55OWtUcGJOQXN3bHR4QzVrb1p3a0hZWXNNUUVhckxldkZQYXFySXpXbzU5cW5EdnlCQlh0dlNrU2tvc2gifV19Cg","protected":"eyJhbGciOiJFUzUxMiIsImN0eSI6Imp3ay1zZXQranNvbiJ9","signature":"AYstM-m5x1KsJS-Y38D-YR2aBtkH6jO81zxJwnzKrqgzKF5Jl8UtmuBMIMyclC7XarZe_Sk1UiHXk6gKCzaq6QWbAHBpm8_4j8Jg28j1Rx7jSyS7usM_JqMgGWG4AkVE3ebaQWOmsLzIgez_K7fhGK5TzEt3hLPv8TKSPNuCxB81yD1-"}';

// `clevis encrypt tang` style output: `jose jwe enc` with alg ECDH-ES,
// enc A256GCM against `_joseExchangeKeyJwk`, plaintext "PLAINTEXT".
const _joseEncryptedJwe =
    'eyJhbGciOiJFQ0RILUVTIiwiY2xldmlzIjp7InBpbiI6InRhbmciLCJ0YW5nIjp7ImFkdiI6eyJrZXlzIjpbeyJhbGciOiJFUzUxMiIsImNydiI6IlAtNTIxIiwia2V5X29wcyI6WyJ2ZXJpZnkiXSwia3R5IjoiRUMiLCJ4IjoiQVZEQ1I0WmJjQmxsQWVGYU5MX2tSbkFmbjZhQUFUcUJ3eDExZmFXVUtHZlRNQjR0aEVKRUtUOTVQdDV2enNNQTFudXdLN2h3SDd0YURzNGpVbnRQY05sdyIsInkiOiJBY3JVWkZkYnh4dUF6dloyQ2lRUF96aFh3aVEyWTN0SGJGdlAwOE9uM19ybWw3WFRNdS1NSTNsalpCUXNPaU9QdG1KYU5meGo3aDl6QVAzUFpGNWFMUkU4In0seyJhbGciOiJFQ01SIiwiY3J2IjoiUC01MjEiLCJrZXlfb3BzIjpbImRlcml2ZUtleSJdLCJrdHkiOiJFQyIsIngiOiJBWVpkUHE0WkxUVTVXREQ2b21aTjlCYW5XVllwWHd3Qmo3RkZlT2hhdFVEZXlFVllSV2FvbjBuaWlpcExSRGFGS1NMZG1lcTVwaUo5YWxOaDVPRzMydUNxIiwieSI6IkFXTGUyczZkR0twWXlhV3JJa0NQaG0tY2M0WW55OWtUcGJOQXN3bHR4QzVrb1p3a0hZWXNNUUVhckxldkZQYXFySXpXbzU5cW5EdnlCQlh0dlNrU2tvc2gifV19LCJ1cmwiOiJodHRwOi8vZXhhbXBsZS5vcmc6NzUwMCJ9fSwiZW5jIjoiQTI1NkdDTSIsImVwayI6eyJjcnYiOiJQLTUyMSIsImt0eSI6IkVDIiwieCI6IkFSNElVODZxMHJuamo5bjFKM2k3S01mNkw5U3VZaWVXUnNsb1hKcVduZ2ZPdjlhSWp6UE5OZ1k4NksxeHpNMU9XcjF0VU10a2VxVGlZM1hJNkoyQnEweFAiLCJ5IjoiQUp2MUh6TXRqMG90WVRkNm1YajduSk5mRnNXZ2N2S3I2b3R2bWMtVl9BZjNyUjB4bDhSX2ZNS3owX3hCeGpiYzJydnpKbmxUdUxnclM0bjNFY0pMM19mNiJ9LCJraWQiOiI1eU12ckZFcFVpNjZNSHNCaVgyeXdjZlJvRHN2TFVFZEFEZXE5Y2RNNG5rIn0..-XeR21PD3hpDn4Qz.F5PibGO8F3j-.cZqTVDmi3p-rVMbA2rUFXQ';

void main() {
  group('jose/clevis interoperability vectors', () {
    test('computes the same S256 thumbprint as jose', () {
      final key = TangEcKey.fromJwk(_joseExchangeKeyJwk);
      expect(key.thumbprintS256(), _joseExchangeKid);
    });

    test('verifies the advertisement signed by jose', () {
      final advertisement = Advertisement.parse(
        jsonDecode(_joseAdvertisementJws) as Map<String, Object?>,
      );
      expect(advertisement.keys, hasLength(2));
      expect(advertisement.exchangeKey().thumbprintS256(), _joseExchangeKid);
    });

    test(
      'decrypts a JWE that was encrypted by the jose/clevis toolchain',
      () async {
        final server = TangServer.fromJwks(
          signingKeys: const [_joseSigningKeyJwk],
          exchangeKeys: const [_joseExchangeKeyJwk],
        );
        await server.start(address: InternetAddress.loopbackIPv4, port: 0);
        addTearDown(server.stop);
        final url = 'http://127.0.0.1:${server.port}';

        // The JWE references `http://example.org:7500` in its protected
        // header; point the recovery request at the local test server instead.
        // Rewriting the header itself is not an option because it doubles as
        // the JWE AAD and was fixed at encryption time by jose.
        final recovered = await TangClient().decrypt(
          _joseEncryptedJwe,
          recoveryUrl: url,
        );
        expect(recovered, 'PLAINTEXT');
      },
    );
  });

  group('tang protocol round trip', () {
    late TangServer server;
    late TangClient client;

    setUp(() async {
      server = TangServer.generate();
      await server.start(address: InternetAddress.loopbackIPv4, port: 0);
      client = TangClient();
    });

    tearDown(() => server.stop());

    test('encrypts and decrypts a simple string', () async {
      const plaintext = 'PLAINTEXT';
      final url = 'http://127.0.0.1:${server.port}';

      final jwe = await client.encrypt(plaintext, url);
      expect(jwe.split('.'), hasLength(5));
      expect(jwe, isNot(contains(plaintext)));

      final decrypted = await client.decrypt(jwe);
      expect(decrypted, plaintext);
    });

    test('each encryption yields a different JWE', () async {
      final url = 'http://127.0.0.1:${server.port}';
      final first = await client.encrypt('PLAINTEXT', url);
      final second = await client.encrypt('PLAINTEXT', url);
      expect(first, isNot(second));
    });

    test('serves a verifiable advertisement on GET /adv', () async {
      final response = await HttpClient().getUrl(
        Uri.parse('http://127.0.0.1:${server.port}/adv'),
      );
      final reply = await response.close();
      expect(reply.statusCode, HttpStatus.ok);
      expect(reply.headers.contentType.toString(), 'application/jose+json');
      final jws = jsonDecode(await utf8.decodeStream(reply));
      final advertisement = Advertisement.parse(jws as Map<String, Object?>);
      expect(
        advertisement.exchangeKey().thumbprintS256(),
        server.exchangeKeys.single.thumbprintS256(),
      );
    });

    test('GET /adv/{kid} is signed by the requested signing key', () async {
      final kid = server.signingKeys.single.thumbprintS256();
      final reply = await HttpClient().getUrl(
        Uri.parse('http://127.0.0.1:${server.port}/adv/$kid'),
      );
      final response = await reply.close();
      expect(response.statusCode, HttpStatus.ok);
      final jws = jsonDecode(await utf8.decodeStream(response));
      final signatures = (jws['signatures'] as List)
          .cast<Map<String, dynamic>>();
      expect(signatures, hasLength(1));
      expect(
        jsonDecode(utf8.decode(b64urlDecode(signatures.single['protected']))),
        containsPair('alg', 'ES512'),
      );
    });

    test('POST /rec rejects unknown kids and malformed bodies', () async {
      final clientHttp = HttpClient();
      addTearDown(clientHttp.close);

      final unknown = await clientHttp.postUrl(
        Uri.parse('http://127.0.0.1:${server.port}/rec/unknown'),
      );
      unknown.write('{}');
      expect((await unknown.close()).statusCode, HttpStatus.notFound);

      final malformed = await clientHttp.postUrl(
        Uri.parse(
          'http://127.0.0.1:${server.port}/rec/${server.exchangeKeys.single.thumbprintS256()}',
        ),
      );
      malformed.write('not-json');
      expect((await malformed.close()).statusCode, HttpStatus.badRequest);
    });
  });
}
