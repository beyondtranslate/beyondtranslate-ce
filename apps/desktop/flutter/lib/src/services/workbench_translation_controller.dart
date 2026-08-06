import 'dart:async';

import 'package:flutter/foundation.dart';

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
  Future<LookUpResponse> lookUp(
    String serviceId,
    LookUpRequest request,
  ) {
    return runtime.dictionary(providerId: serviceId).lookup(request: request);
  }
}

class WorkbenchServiceResult {
  WorkbenchServiceResult({
    required this.service,
    required this.provider,
  });

  final ServiceConfigEntry service;
  final ProviderConfigEntry? provider;

  String text = '';
  String? audioUrl;
  Object? error;
  bool loading = true;

  bool get hasText => text.trim().isNotEmpty;
}

class WorkbenchTranslationController extends ChangeNotifier {
  WorkbenchTranslationController({
    WorkbenchTranslationGateway? gateway,
    String initialTargetLanguage = 'en',
  })  : _gateway = gateway ?? RuntimeWorkbenchTranslationGateway(),
        _usesRuntimeDefaults = gateway == null,
        targetLanguage = initialTargetLanguage;

  final WorkbenchTranslationGateway _gateway;
  final bool _usesRuntimeDefaults;
  bool _disposed = false;

  String sourceLanguage = kAutoSource;
  String targetLanguage;
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

  List<ServiceConfigEntry> get translationServices => services
      .where((service) => service.type == ServiceType.translation)
      .toList(growable: false);

  List<ServiceConfigEntry> get dictionaryServices => services
      .where((service) => service.type == ServiceType.dictionary)
      .toList(growable: false);

  Future<void> initialize() async {
    loadingServices = true;
    setupError = null;
    _notify();
    try {
      providers = await _gateway.listProviders();
      services = await _gateway.listServices();
      final enabledTargets = settingsStore.general.translationTargets
          .where((target) => target.enabled)
          .toList(growable: false);
      if (enabledTargets.isNotEmpty) {
        sourceLanguage = enabledTargets.first.source;
        targetLanguage = enabledTargets.first.target;
      } else if (_usesRuntimeDefaults) {
        targetLanguage = defaultTargetLanguage;
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

  void setTargetLanguage(String value) {
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
    results
      ..clear()
      ..addAll(
        translationServices.map(
          (service) => WorkbenchServiceResult(
            service: service,
            provider: _providerFor(service),
          ),
        ),
      );
    selectedServiceId = results.isEmpty ? null : results.first.service.id;
    _notify();

    await _detectLanguage(query, requestId);

    final futures = <Future<void>>[
      for (final result in results) _translate(result, query, requestId),
      if (dictionaryServices.isNotEmpty)
        _lookUp(dictionaryServices.first, query, requestId),
    ];
    await Future.wait(futures);

    if (requestId != _requestId) return;
    submitting = false;
    final firstSuccess = results.where((result) => result.hasText).firstOrNull;
    if (selectedResult?.hasText != true && firstSuccess != null) {
      selectedServiceId = firstSuccess.service.id;
    }
    _notify();
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
  ) async {
    try {
      if (_isLlm(result.provider?.type)) {
        final buffer = StringBuffer();
        await for (final content in _gateway.translateStream(
          result.service.id,
          sourceLanguage,
          targetLanguage,
          query,
        )) {
          if (requestId != _requestId) return;
          if (content.isNotEmpty) {
            buffer.write(content);
            result.text = buffer.toString();
            _notify();
          }
        }
      } else {
        final response = await _gateway.translate(
          result.service.id,
          TranslateRequest(
            sourceLanguage:
                isAutoSource(sourceLanguage) ? null : sourceLanguage,
            targetLanguage: targetLanguage,
            text: query,
          ),
        );
        if (requestId != _requestId) return;
        if (response.translations.isNotEmpty) {
          final translation = response.translations.first;
          result.text = translation.text;
          result.audioUrl = translation.audioUrl;
        }
      }
    } catch (error) {
      if (requestId != _requestId) return;
      result.error = error;
    } finally {
      if (requestId == _requestId) {
        result.loading = false;
        _notify();
      }
    }
  }

  Future<void> _lookUp(
    ServiceConfigEntry service,
    String query,
    int requestId,
  ) async {
    try {
      final response = await _gateway.lookUp(
        service.id,
        LookUpRequest(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
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
