import 'package:beyondtranslate_desktop/src/services/workbench_translation_controller.dart';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter_test/flutter_test.dart';

/// 自动匹配 is the target menu's first item in both windows. The workbench
/// translates into one language at a time, so the choice it hands to the
/// configured translation targets has to come back as exactly one — resolved
/// after detection has spoken, and never left null by the time a request is
/// built.
void main() {
  test('a picked target is the one translated into', () async {
    final gateway = _FakeGateway();
    final controller = WorkbenchTranslationController(
      gateway: gateway,
      initialTargetLanguage: 'en',
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    controller
      ..setTargetLanguage('ja')
      ..setText('hello');
    await controller.submit();

    expect(controller.effectiveTargetLanguage, 'ja');
    expect(gateway.requestedTargets, ['ja']);
    // Nothing to resolve, so the runtime is never asked.
    expect(gateway.activeCalls, 0);
  });

  test('自动匹配 resolves against what detection found', () async {
    final gateway = _FakeGateway(
      configured: [
        _target(source: 'ja', target: 'zh-Hans'),
        _target(source: 'en', target: 'zh-Hant'),
      ],
      detected: 'ja',
      // The runtime keeps the targets whose source matches the detection.
      active: [_target(source: 'ja', target: 'zh-Hans')],
    );
    final controller = WorkbenchTranslationController(
      gateway: gateway,
      initialTargetLanguage: 'en',
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    controller
      ..setTargetLanguage(null)
      ..setText('こんにちは');
    await controller.submit();

    expect(gateway.activeCalls, 1);
    expect(gateway.detectedPassedToActive, 'ja');
    // The capsule still says 自动匹配…
    expect(controller.targetLanguage, isNull);
    // …while the query went to the language it resolved to.
    expect(controller.effectiveTargetLanguage, 'zh-Hans');
    expect(gateway.requestedTargets, ['zh-Hans']);
  });

  test('自动匹配 falls back to the standing target when nothing matches', () async {
    final gateway = _FakeGateway(
      configured: [_target(source: 'ja', target: 'zh-Hans')],
      detected: 'de',
      active: const [],
    );
    final controller = WorkbenchTranslationController(
      gateway: gateway,
      initialTargetLanguage: 'en',
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    // The roster started on the configured target, so that is what "standing"
    // means here — not the constructor's 'en'.
    expect(controller.effectiveTargetLanguage, 'zh-Hans');

    controller
      ..setTargetLanguage(null)
      ..setText('guten tag');
    await controller.submit();

    // Detection found a language no target claims. The standing target holds,
    // rather than a null leaking into the request.
    expect(controller.effectiveTargetLanguage, 'zh-Hans');
    expect(gateway.requestedTargets, ['zh-Hans']);
  });

  test('a runtime that will not resolve does not fail the query', () async {
    final gateway = _FakeGateway(
      configured: [_target(source: 'ja', target: 'zh-Hans')],
      activeThrows: true,
    );
    final controller = WorkbenchTranslationController(
      gateway: gateway,
      initialTargetLanguage: 'en',
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    controller
      ..setTargetLanguage(null)
      ..setText('hello');
    await controller.submit();

    expect(controller.effectiveTargetLanguage, 'zh-Hans');
    expect(gateway.requestedTargets, ['zh-Hans']);
    expect(controller.results.single.error, isNull);
  });

  test('the roster picks up the first configured target', () async {
    final gateway = _FakeGateway(
      configured: [_target(source: 'ja', target: 'zh-Hans')],
    );
    final controller = WorkbenchTranslationController(
      gateway: gateway,
      initialTargetLanguage: 'en',
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    expect(controller.sourceLanguage, 'ja');
    expect(controller.targetLanguage, 'zh-Hans');
    expect(controller.effectiveTargetLanguage, 'zh-Hans');
  });
}

TranslationTarget _target({
  required String source,
  required String target,
  bool enabled = true,
}) {
  return TranslationTarget(source: source, target: target, enabled: enabled);
}

class _FakeGateway implements WorkbenchTranslationGateway {
  _FakeGateway({
    this.configured = const [],
    this.detected,
    this.active = const [],
    this.activeThrows = false,
  });

  final List<TranslationTarget> configured;
  final String? detected;
  final List<TranslationTarget> active;
  final bool activeThrows;

  /// The target language of every translate request that went out. Nullable,
  /// because the request field is — a 自动匹配 that never resolved would show
  /// up here as a null rather than as a silently wrong language.
  final List<String?> requestedTargets = [];
  int activeCalls = 0;
  String? detectedPassedToActive;

  @override
  List<TranslationTarget> configuredTranslationTargets() => configured;

  @override
  Future<List<TranslationTarget>> activeTranslationTargets(
    List<TranslationTarget> targets,
    String? detectedLanguage,
  ) async {
    activeCalls++;
    detectedPassedToActive = detectedLanguage;
    if (activeThrows) throw StateError('runtime unavailable');
    return active;
  }

  @override
  Future<String?> detectLanguage(String serviceId, String text) async =>
      detected;

  @override
  Future<List<ProviderConfigEntry>> listProviders() async => const [];

  @override
  Future<List<ServiceConfigEntry>> listServices() async => [
        ServiceConfigEntry(
          id: 'deepl+translation',
          providerId: 'deepl',
          type: ServiceType.translation,
          name: 'DeepL',
          fields: const {},
        ),
      ];

  @override
  Future<TranslateResponse> translate(
    String serviceId,
    TranslateRequest request,
  ) async {
    requestedTargets.add(request.targetLanguage);
    return TranslateResponse(
      translations: [TextTranslation(text: 'ok')],
    );
  }

  @override
  Stream<String> translateStream(
    String serviceId,
    String sourceLanguage,
    String targetLanguage,
    String text,
  ) async* {
    requestedTargets.add(targetLanguage);
    yield 'ok';
  }

  @override
  Future<LookUpResponse> lookUp(String serviceId, LookUpRequest request) async {
    throw UnimplementedError();
  }
}
