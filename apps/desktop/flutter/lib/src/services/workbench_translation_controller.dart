import 'dart:async';

import 'package:flutter/foundation.dart';

import '../features.dart';
import '../routes/settings/provider_meta.dart' show isServiceEnabled;
import '../utils/language_util.dart';
import 'llm_stream.dart';
import 'runtime.dart';
import 'settings_store.dart';

abstract interface class WorkbenchTranslationGateway {
  Future<List<ProviderConfigEntry>> listProviders();

  Future<List<ServiceConfigEntry>> listServices();

  Future<String?> detectLanguage(String serviceId, String text);

  Stream<String> translateStream(
    String serviceId,
    String sourceLanguage,
    String targetLanguage,
    String text,
  );

  Future<TranslateResponse> translate(
    String serviceId,
    TranslateRequest request,
  );

  Future<LookUpResponse> lookUp(String serviceId, LookUpRequest request);

  /// The translation targets configured on 服务.
  List<TranslationTarget> configuredTranslationTargets();

  /// The subset of [targets] that applies to what detection found — the rule
  /// behind 自动匹配, which the runtime owns so both windows resolve it alike.
  Future<List<TranslationTarget>> activeTranslationTargets(
    List<TranslationTarget> targets,
    String? detectedLanguage,
  );
}

class RuntimeWorkbenchTranslationGateway
    implements WorkbenchTranslationGateway {
  @override
  Future<List<ProviderConfigEntry>> listProviders() {
    return runtime.settings().listProviders();
  }

  @override
  Future<List<ServiceConfigEntry>> listServices() {
    return runtime.settings().listServices();
  }

  @override
  Future<String?> detectLanguage(String serviceId, String text) async {
    final response = await runtime
        .translation(providerId: serviceId)
        .detectLanguage(request: DetectLanguageRequest(texts: [text]));
    final detections = response.detections;
    return detections == null || detections.isEmpty
        ? null
        : detections.first.detectedLanguage;
  }

  @override
  Stream<String> translateStream(
    String serviceId,
    String sourceLanguage,
    String targetLanguage,
    String text,
  ) async* {
    await for (final chunk in LlmStream.translate(
      providerId: serviceId,
      sourceLang: sourceLanguage,
      targetLang: targetLanguage,
      text: text,
    )) {
      if (chunk.content.isNotEmpty) yield chunk.content;
    }
  }

  @override
  Future<TranslateResponse> translate(
    String serviceId,
    TranslateRequest request,
  ) {
    return runtime
        .translation(providerId: serviceId)
        .translate(request: request);
  }

  @override
  Future<LookUpResponse> lookUp(String serviceId, LookUpRequest request) {
    return runtime.dictionary(providerId: serviceId).lookup(request: request);
  }

  @override
  List<TranslationTarget> configuredTranslationTargets() {
    return settingsStore.general.translationTargets;
  }

  @override
  Future<List<TranslationTarget>> activeTranslationTargets(
    List<TranslationTarget> targets,
    String? detectedLanguage,
  ) {
    return runtime.settings().getActiveTranslationTargets(
          targets: targets,
          detectedLanguage: detectedLanguage,
        );
  }
}

/// What one service returned for one target — 自动匹配 can ask for several
/// languages at once, and each keeps its own text, error and in-flight flag.
class WorkbenchTranslationOutput {
  String text = '';
  String? audioUrl;
  Object? error;
  bool loading = true;

  bool get hasText => text.trim().isNotEmpty;
}

class WorkbenchServiceResult {
  WorkbenchServiceResult({
    required this.service,
    required this.provider,
    required List<String> targets,
  }) : outputs = {
          for (final target in targets) target: WorkbenchTranslationOutput(),
        };

  final ServiceConfigEntry service;
  final ProviderConfigEntry? provider;

  /// One output per target, in the order the targets were resolved.
  final Map<String, WorkbenchTranslationOutput> outputs;

  /// The output for [target]. A target this result was never asked for reads
  /// as still loading rather than as a crash: the UI lists the resolved
  /// targets and the results are re-keyed the moment resolution lands.
  WorkbenchTranslationOutput output(String target) =>
      outputs[target] ?? WorkbenchTranslationOutput();

  /// The first target's output — what the single-target callers (history,
  /// the ⌥n fallback) read, and the whole story when 自动匹配 lands on one.
  WorkbenchTranslationOutput get primary =>
      outputs.values.firstOrNull ?? WorkbenchTranslationOutput();

  String get text => primary.text;
  String? get audioUrl => primary.audioUrl;
  Object? get error => primary.error;
  bool get loading => primary.loading;
  bool get hasText => primary.hasText;

  /// Whether every target's output is still in flight.
  bool get loadingAll => outputs.values.every((output) => output.loading);

  /// Whether any target came back with text.
  bool get hasAnyText => outputs.values.any((output) => output.hasText);

  /// Re-key the outputs once 自动匹配 has resolved: the query was armed on the
  /// standing targets, and what detection routed to may differ.
  void resetTargets(List<String> targets) {
    outputs
      ..clear()
      ..addEntries([
        for (final target in targets)
          MapEntry(target, WorkbenchTranslationOutput()),
      ]);
  }
}

class WorkbenchTranslationController extends ChangeNotifier {
  WorkbenchTranslationController({
    WorkbenchTranslationGateway? gateway,
    String initialTargetLanguage = 'en',
  })  : _gateway = gateway ?? RuntimeWorkbenchTranslationGateway(),
        _usesRuntimeDefaults = gateway == null,
        targetLanguage = initialTargetLanguage,
        _resolvedTargets = [initialTargetLanguage];

  final WorkbenchTranslationGateway _gateway;
  final bool _usesRuntimeDefaults;
  bool _disposed = false;

  String sourceLanguage = kAutoSource;

  /// The target the user picked, or null for 自动匹配 — the target menu's
  /// first item, which hands the choice to the configured translation targets.
  String? targetLanguage;

  /// What 自动匹配 last landed on. Concrete languages are needed before the
  /// query is sent — for the input placeholder and for what history records —
  /// and re-resolving them on every rebuild would mean a runtime call per
  /// frame. More than one when a specific rule and the 自动检测 fallback both
  /// apply: the core translates into each, and the pane stacks a block per
  /// target.
  List<String> _resolvedTargets;

  /// The languages a submit actually translates into: the pick when there is
  /// one, otherwise whatever 自动匹配 resolved to last. Never empty.
  List<String> get effectiveTargetLanguages {
    final picked = targetLanguage;
    return picked != null ? [picked] : List.unmodifiable(_resolvedTargets);
  }

  /// The first of [effectiveTargetLanguages] — the one history records and
  /// the single-target callers read.
  String get effectiveTargetLanguage => effectiveTargetLanguages.first;

  String? detectedLanguage;
  String? selectedServiceId;
  String text = '';
  bool loadingServices = true;
  bool submitting = false;
  Object? setupError;
  LookUpResponse? dictionaryResult;

  List<ProviderConfigEntry> providers = const [];
  List<ServiceConfigEntry> services = const [];
  final List<WorkbenchServiceResult> results = [];

  int _requestId = 0;

  WorkbenchServiceResult? get selectedResult {
    if (results.isEmpty) return null;
    return results.cast<WorkbenchServiceResult?>().firstWhere(
          (result) => result?.service.id == selectedServiceId,
          orElse: () => results.first,
        );
  }

  // A service switched off on 服务 takes no part in a query.
  List<ServiceConfigEntry> get translationServices => services
      .where(
        (service) =>
            service.type == ServiceType.translation &&
            isServiceEnabled(service),
      )
      .toList(growable: false);

  List<ServiceConfigEntry> get dictionaryServices => services
      .where(
        (service) =>
            service.type == ServiceType.dictionary &&
            isServiceTypeVisible(service.type) &&
            isServiceEnabled(service),
      )
      .toList(growable: false);

  Future<void> initialize() async {
    loadingServices = true;
    setupError = null;
    _notify();
    try {
      providers = await _gateway.listProviders();
      services = await _gateway.listServices();
      final enabledTargets = _gateway
          .configuredTranslationTargets()
          .where((target) => target.enabled)
          .toList(growable: false);
      if (enabledTargets.isNotEmpty) {
        sourceLanguage = enabledTargets.first.source;
        targetLanguage = enabledTargets.first.target;
        _resolvedTargets = [enabledTargets.first.target];
      } else if (_usesRuntimeDefaults) {
        targetLanguage = defaultTargetLanguage;
        _resolvedTargets = [defaultTargetLanguage];
      }
    } catch (error) {
      setupError = error;
    } finally {
      loadingServices = false;
      _notify();
    }
  }

  void setText(String value) {
    text = value;
    _notify();
  }

  void setSourceLanguage(String value) {
    sourceLanguage = value;
    _notify();
  }

  void setTargetLanguage(String? value) {
    targetLanguage = value;
    _notify();
  }

  void selectService(String id) {
    selectedServiceId = id;
    _notify();
  }

  Future<void> submit() async {
    final query = text.trim();
    if (query.isEmpty || loadingServices) return;

    final requestId = ++_requestId;
    submitting = true;
    detectedLanguage = null;
    dictionaryResult = null;
    // Armed on the standing targets so the skeletons show while detection
    // runs; re-keyed below once 自动匹配 has spoken.
    final standing = effectiveTargetLanguages;
    results
      ..clear()
      ..addAll(
        translationServices.map(
          (service) => WorkbenchServiceResult(
            service: service,
            provider: _providerFor(service),
            targets: standing,
          ),
        ),
      );
    selectedServiceId = results.isEmpty ? null : results.first.service.id;
    _notify();

    await _detectLanguage(query, requestId);
    if (requestId != _requestId) return;

    // 自动匹配 can only be settled once detection has spoken, so the targets
    // are resolved here rather than when they were picked.
    final targets = await _resolveTargets(requestId);
    if (requestId != _requestId) return;
    if (!listEquals(targets, standing)) {
      for (final result in results) {
        result.resetTargets(targets);
      }
      _notify();
    }

    final futures = <Future<void>>[
      for (final result in results)
        for (final target in targets)
          _translate(result, query, requestId, target),
      if (dictionaryServices.isNotEmpty)
        _lookUp(dictionaryServices.first, query, requestId, targets.first),
    ];
    await Future.wait(futures);

    if (requestId != _requestId) return;
    submitting = false;
    final firstSuccess =
        results.where((result) => result.hasAnyText).firstOrNull;
    if (selectedResult?.hasAnyText != true && firstSuccess != null) {
      selectedServiceId = firstSuccess.service.id;
    }
    _notify();
  }

  /// The languages this submit translates into. A concrete pick is its own
  /// answer; 自动匹配 defers to the configured translation targets, routed by
  /// what the text is already in — the same rule the mini translator follows,
  /// and every target the rules hand back is translated into. With nothing
  /// configured, nothing matching, or a runtime that would not answer, the
  /// last concrete targets stand: a target we cannot resolve is no reason to
  /// fail the whole query.
  Future<List<String>> _resolveTargets(int requestId) async {
    final picked = targetLanguage;
    if (picked != null) return [picked];

    final configured = _gateway.configuredTranslationTargets();
    if (configured.isEmpty) return _resolvedTargets;

    try {
      final active = await _gateway.activeTranslationTargets(
        configured,
        // A source the user picked outranks the detector: they have said
        // what the text is, and 自动匹配 routes away from it just the same.
        isAutoSource(sourceLanguage) ? detectedLanguage : sourceLanguage,
      );
      if (requestId != _requestId) return _resolvedTargets;
      // Two rules naming the same language are one translation, not two.
      final matched = <String>[];
      for (final target in active) {
        if (!matched.contains(target.target)) matched.add(target.target);
      }
      if (matched.isNotEmpty && !listEquals(matched, _resolvedTargets)) {
        _resolvedTargets = matched;
        _notify();
      }
    } catch (_) {
      // Keep the standing targets rather than failing the submit.
    }
    return _resolvedTargets;
  }

  Future<void> _detectLanguage(String query, int requestId) async {
    final service = translationServices.firstOrNull;
    if (service == null) return;
    try {
      final detected = await _gateway.detectLanguage(service.id, query);
      if (requestId != _requestId) return;
      if (detected != null) {
        detectedLanguage = detected;
        _notify();
      }
    } catch (_) {
      // Detection is supplemental; translation can continue without it.
    }
  }

  Future<void> _translate(
    WorkbenchServiceResult result,
    String query,
    int requestId,
    String target,
  ) async {
    final output = result.output(target);
    try {
      if (_isLlm(result.provider?.type)) {
        final buffer = StringBuffer();
        await for (final content in _gateway.translateStream(
          result.service.id,
          sourceLanguage,
          target,
          query,
        )) {
          if (requestId != _requestId) return;
          if (content.isNotEmpty) {
            buffer.write(content);
            output.text = buffer.toString();
            _notify();
          }
        }
      } else {
        final response = await _gateway.translate(
          result.service.id,
          TranslateRequest(
            sourceLanguage:
                isAutoSource(sourceLanguage) ? null : sourceLanguage,
            targetLanguage: target,
            text: query,
          ),
        );
        if (requestId != _requestId) return;
        if (response.translations.isNotEmpty) {
          final translation = response.translations.first;
          output.text = translation.text;
          output.audioUrl = translation.audioUrl;
        }
      }
    } catch (error) {
      if (requestId != _requestId) return;
      output.error = error;
    } finally {
      if (requestId == _requestId) {
        output.loading = false;
        _notify();
      }
    }
  }

  Future<void> _lookUp(
    ServiceConfigEntry service,
    String query,
    int requestId,
    String target,
  ) async {
    try {
      final response = await _gateway.lookUp(
        service.id,
        LookUpRequest(
          sourceLanguage: sourceLanguage,
          targetLanguage: target,
          word: query,
        ),
      );
      if (requestId != _requestId) return;
      dictionaryResult = response;
      _notify();
    } catch (_) {
      // Dictionary lookup is optional and must not fail the translation.
    }
  }

  ProviderConfigEntry? _providerFor(ServiceConfigEntry service) {
    for (final provider in providers) {
      if (provider.id == service.providerId) return provider;
    }
    return null;
  }

  bool _isLlm(ProviderType? type) {
    return type == ProviderType.openAi ||
        type == ProviderType.anthropic ||
        type == ProviderType.ollama ||
        type == ProviderType.xAi;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _requestId++;
    super.dispose();
  }
}
