import 'dart:io';

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart' as rp;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dataDir;
  late rp.RuntimeSettings settings;

  setUp(() {
    dataDir = Directory.systemTemp.createTempSync('beyondtranslate-draft-');
    settings = rp.Runtime(dataDir: dataDir.path).settings();
  });

  tearDown(() => dataDir.deleteSync(recursive: true));

  // Port 1 refuses connections, so each call fails at the request without
  // touching the network. A blank defaultModel must not fail config
  // validation first: testing a draft is how the form finds a model.
  for (final providerType in ['ollama', 'openai_compatible']) {
    test('$providerType draft with a blank default model reaches the endpoint',
        () async {
      await expectLater(
        settings.listDraftModels(
          providerId: 'draft-$providerType',
          providerType: providerType,
          fields: {'baseUrl': 'http://127.0.0.1:1', 'defaultModel': ''},
        ),
        throwsA(
          isA<rp.ErrorExceptionRuntimeException>().having(
            (error) => error.msg,
            'msg',
            allOf(
              contains('network error'),
              isNot(contains('default_model')),
            ),
          ),
        ),
      );

      final providers = await settings.listProviders();
      expect(providers.map((provider) => provider.id),
          isNot(contains('draft-$providerType')));
    });
  }

  test('the built-in provider is refused as a draft', () async {
    await expectLater(
      settings.listDraftModels(
        providerId: 'system',
        providerType: 'system',
        fields: const {},
      ),
      throwsA(isA<rp.RuntimeException>()),
    );
  });
}
