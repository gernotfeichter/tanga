import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tanga/tang/key_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('persists generated keys across reloads', () async {
    SharedPreferences.setMockInitialValues({});

    final first = await const TangKeyStore().loadOrCreate();
    final second = await const TangKeyStore().loadOrCreate();

    expect(
      second.signingKeys.single.thumbprintS256(),
      first.signingKeys.single.thumbprintS256(),
    );
    expect(
      second.exchangeKeys.single.thumbprintS256(),
      first.exchangeKeys.single.thumbprintS256(),
    );
  });

  test('regenerates keys when stored values are corrupt', () async {
    SharedPreferences.setMockInitialValues({
      'tang.signingKeys': 'not json',
      'tang.exchangeKeys': 'not json',
    });

    final server = await const TangKeyStore().loadOrCreate();

    expect(server.signingKeys, hasLength(1));
    expect(server.exchangeKeys, hasLength(1));
  });
}
