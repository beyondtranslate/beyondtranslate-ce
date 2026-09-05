// ignore_for_file: deprecated_member_use, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../extensions/window_controller.dart';
import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../routes/settings/provider_meta.dart'
    show isDefaultTranslationService, isServiceEnabled, serviceDisplayName;
import '../../routes/settings/services.dart' show ServicesSettingsPage;
import '../../services/app_windows.dart'
    show
        handOffToWorkbench,
        hideMiniTranslatorWindow,
        miniTranslatorPositionAtCursorScreenTopRight,
        miniTranslatorWindowController,
        showMiniTranslatorWindow,
        showSettingsWindow;
import '../../services/history_store.dart';
import '../../services/llm_stream.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../services/shortcut_service/shortcut_service.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../widgets/block_heading.dart';
import '../../widgets/toast_host.dart' show showToast;
import '../../widgets/ui.dart' show DesignThemeContext, PopoverPanel, ToastTone;
import 'limited_functionality_banner.dart';
import 'translation_input_view.dart';
import 'translation_results_view.dart';
import 'translation_target_select_view.dart';

/// The tray's own inset (`--bt-mini-tray-pad`): the top bar, the panel card and
/// the action bar all float this far inside the window edge.
const double _kTrayInset = 8;

/// What the footer's 复制 is keyed under — it copies the first target's text.
const String _kCopiedAll = '*';

class MiniTranslatorPage extends StatefulWidget {
  const MiniTranslatorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MiniTranslatorPageState();
}

class _MiniTranslatorPageState extends State<MiniTranslatorPage>
    with WidgetsBindingObserver, ShortcutListener {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _bannersViewKey = GlobalKey();
  final GlobalKey _contentViewKey = GlobalKey();
  final GlobalKey _toolbarViewKey = GlobalKey();

  Brightness _brightness = Brightness.light;

  Offset _lastShownPosition = Offset.zero;

  // The mini-translator grows with its content but caps at this height, after
  // which the results area scrolls.
  static const double _maxWindowHeight = 800;

  bool _isAlwaysOnTop = false;

  bool _isAllowedScreenCaptureAccess = true;
  bool _isAllowedScreenSelectionAccess = true;

  String _sourceLanguage = kAutoSource;
  String? _selectedTargetLanguage;
  int _activeConfigIndex = -1;
  List<TranslationTarget> _fastTargets = [];

  bool _querySubmitted = false;
  String _text = '';
  String? _detectedLanguage;
  bool _isTextDetecting = false; // ignore: unused_field
  List<TranslationResult> _translationResultList = [];

  /// 对比 — per target: the candidates are the other services' renderings
  /// into that language, so each target's block folds out its own list.
  final Set<String> _compareOpen = {};

  /// The source was edited after the last query — arms ⏎ 重新翻译.
  bool _resultStale = false;

  /// Service promoted with 设为首选 / ⌥n; the preferred block follows it.
  String? _preferredServiceId;

  /// Which target's 复制 just fired — a block's, or [_kCopiedAll] for the
  /// footer's.
  String? _copiedTarget;
  bool _starred = false;
  final TranslationHistorySession _historySession = TranslationHistorySession();
  Timer? _copiedTimer;

  /// Service display names and the translation-service ids, captured per query
  /// so the results view can attribute records without re-fetching settings.
  Map<String, String> _serviceNameById = {};
  Set<String> _translationServiceIds = {};

  /// The translation service 设置 marks 默认, captured per query: its output
  /// is attributed as plain 译文, a promoted service by name.
  String? _defaultServiceId;

  Timer? _resizeSettledTimer;
  bool _isWindowResizeScheduled = false;
  bool _pendingWindowResizeAnimate = true;
  bool _pendingWindowResizeSettle = false;
  int? _windowFocusedListenerId;
  int? _windowBlurredListenerId;
  int? _windowMovedListenerId;

  nativeapi.Window get _window => miniTranslatorWindowController.window;

  @override
  void initState() {
    settingsStore.addListener(_handleChanged);
    WidgetsBinding.instance.addObserver(this);
    if (kIsLinux || kIsMacOS || kIsWindows) {
      ShortcutService.instance.setListener(this);
      _registerWindowEvents();
      _init();
    }
    _loadData();
    super.initState();
    _scheduleWindowResize(animate: false, settle: true);
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    WidgetsBinding.instance.removeObserver(this);
    if (kIsLinux || kIsMacOS || kIsWindows) {
      ShortcutService.instance.setListener(null);
      _unregisterWindowEvents();
    }
    _resizeSettledTimer?.cancel();
    _copiedTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    Brightness newBrightness =
        WidgetsBinding.instance.window.platformBrightness;

    if (newBrightness != _brightness) {
      _setStateAndScheduleWindowResize(() {
        _brightness = newBrightness;
      });
    }
  }

  void _handleChanged() {
    _setStateAndScheduleWindowResize(() {});
  }

  void _setStateAndScheduleWindowResize(
    VoidCallback fn, {
    bool animate = true,
  }) {
    if (!mounted) return;
    setState(fn);
    _scheduleWindowResize(animate: animate);
  }

  void _init() async {
    if (kIsMacOS) {
      _isAllowedScreenCaptureAccess =
          await runtime.permission().isScreenRecordingPermissionGranted();
      _isAllowedScreenSelectionAccess =
          await runtime.permission().isAccessibilityPermissionGranted();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    // This page is only built as part of the window's first show, which has
    // already placed the window (tray anchor, or the default in
    // showMiniTranslatorWindow) — moving it here would yank it away from
    // that anchor. Only seed the remembered position if nothing has yet.
    if (_lastShownPosition == Offset.zero) {
      if (kIsLinux || kIsWindows) {
        final primaryDisplay = nativeapi.DisplayManager.instance.getPrimary();
        if (primaryDisplay != null) {
          final windowSize = _window.size;
          _lastShownPosition = Offset(
            primaryDisplay.size.width - windowSize.width - 50,
            50,
          );
        }
      } else if (kIsMacOS) {
        final position = miniTranslatorPositionAtCursorScreenTopRight(
          windowSize: _window.size,
        );
        if (position != null) {
          _lastShownPosition = position;
        }
      }
    }
    _setStateAndScheduleWindowResize(() {});
  }

  void _registerWindowEvents() {
    _windowFocusedListenerId =
        nativeapi.WindowManager.instance.addListener((event) {
      if (event is! nativeapi.WindowFocusedEvent) return;
      if (event.windowId == _window.id) {
        _focusNode.requestFocus();
      }
    });
    _windowBlurredListenerId =
        nativeapi.WindowManager.instance.addListener((event) {
      if (event is! nativeapi.WindowBlurredEvent) return;
      if (event.windowId == _window.id) {
        _focusNode.unfocus();
        // The pin state, not the window level: on macOS the window is always
        // at the floating level (see `app_windows.dart`).
        if (!_isAlwaysOnTop) {
          hideMiniTranslatorWindow();
        }
      }
    });
    _windowMovedListenerId =
        nativeapi.WindowManager.instance.addListener((event) {
      if (event is! nativeapi.WindowMovedEvent) return;
      if (event.windowId == _window.id) {
        _lastShownPosition = event.newPosition;
      }
    });
  }

  void _unregisterWindowEvents() {
    if (_windowFocusedListenerId != null) {
      nativeapi.WindowManager.instance
          .removeListener(_windowFocusedListenerId!);
      _windowFocusedListenerId = null;
    }
    if (_windowBlurredListenerId != null) {
      nativeapi.WindowManager.instance
          .removeListener(_windowBlurredListenerId!);
      _windowBlurredListenerId = null;
    }
    if (_windowMovedListenerId != null) {
      nativeapi.WindowManager.instance.removeListener(_windowMovedListenerId!);
      _windowMovedListenerId = null;
    }
  }

  Future<void> _windowShow() async {
    final isAlwaysOnTop = _window.isAlwaysOnTop;
    // final windowSize = _window.size;

    if (kIsLinux) {
      _window.position = _lastShownPosition;
    }

    // if (kIsMacOS && isShowBelowTray) {
    //   final trayIconBounds = _trayIcon?.bounds;
    //   if (trayIconBounds != null) {
    //     final trayIconSize = trayIconBounds.size;
    //     final trayIconPosition = trayIconBounds.topLeft;

    //     Offset newPosition = Offset(
    //       trayIconPosition.dx - ((windowSize.width - trayIconSize.width) / 2),
    //       trayIconPosition.dy,
    //     );

    //     if (!isAlwaysOnTop) {
    //       _window.setPosition(newPosition.dx, newPosition.dy);
    //     }
    //   }
    // }

    final isVisible = _window.isVisible;
    if (!isVisible) {
      // Through the window layer, which owns the placement.
      await showMiniTranslatorWindow();
    } else {
      _window.focus();
    }
    _scheduleWindowResize(animate: false, settle: true);

    if (kIsLinux && !isAlwaysOnTop) {
      _window.isAlwaysOnTop = true;
      await Future.delayed(const Duration(milliseconds: 10));
      _window.isAlwaysOnTop = false;
      await Future.delayed(const Duration(milliseconds: 10));
      _window.focus();
    }
  }

  Future<void> _windowHide() async {
    hideMiniTranslatorWindow();
  }

  void _scheduleWindowResize({bool animate = true, bool settle = false}) {
    if (!(kIsLinux || kIsMacOS || kIsWindows)) return;

    _pendingWindowResizeAnimate = _isWindowResizeScheduled
        ? _pendingWindowResizeAnimate && animate
        : animate;
    _pendingWindowResizeSettle = _pendingWindowResizeSettle || settle;
    if (_isWindowResizeScheduled) return;

    _isWindowResizeScheduled = true;
    WidgetsBinding.instance.endOfFrame.then((_) {
      _isWindowResizeScheduled = false;
      final pendingAnimate = _pendingWindowResizeAnimate;
      final pendingSettle = _pendingWindowResizeSettle;
      _pendingWindowResizeAnimate = true;
      _pendingWindowResizeSettle = false;

      if (!mounted) return;
      _windowResize(animate: pendingAnimate);
      if (pendingSettle) {
        _scheduleSettledWindowResize(animate: pendingAnimate);
      }
    });
  }

  void _windowResize({bool animate = true}) {
    if (context.canPop()) return;

    try {
      final oldSize = _window.size;
      final newHeight = _measureWindowHeight();
      final newSize = Size(oldSize.width, newHeight.clamp(0, _maxWindowHeight));
      if (oldSize.width == newSize.width && oldSize.height == newSize.height) {
        return;
      }
      _window.setSize(newSize, animate);
    } catch (error) {
      // ignore
    }
  }

  double _measureWindowHeight() {
    final toolbarViewHeight = _renderBoxHeight(_toolbarViewKey);
    final contentViewHeight = _renderBoxHeight(_contentViewKey);

    // Both keys sit inside the tray inset, so it has to be added back on.
    return toolbarViewHeight +
        contentViewHeight +
        (_kTrayInset * 2) +
        (kIsWindows ? 5 : 0);
  }

  double _renderBoxHeight(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 0;
  }

  void _scheduleSettledWindowResize({bool animate = true}) {
    _resizeSettledTimer?.cancel();
    _resizeSettledTimer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      _windowResize(animate: animate);
      _resizeSettledTimer = null;
    });
  }

  void _loadData() async {
    // The previous implementation populated `_latestVersion` from a cloud API
    // and refreshed local service config. Both pieces of state moved into the
    // Rust runtime / external installers, so the mini translator no longer
    // performs network bootstrapping here.
  }

  Future<void> _queryData() async {
    if (_historySession.beginSource(_text)) _starred = false;
    setState(() {
      _querySubmitted = true;
      _detectedLanguage = null;
      _translationResultList = [];
      _resultStale = false;
      _copiedTarget = null;
    });

    final settings = runtime.settings();
    final providers = await settings.listProviders();
    final services = await settings.listServices();
    final generalSettings = await settings.getGeneral();
    final providersById = {
      for (final provider in providers) provider.id: provider,
    };
    final queryServices = services
        .where(
          (service) =>
              (service.type == ServiceType.dictionary ||
                  service.type == ServiceType.translation) &&
              isServiceTypeVisible(service.type) &&
              // A service switched off on 服务 takes no part in a query.
              isServiceEnabled(service),
        )
        .toList();
    _serviceNameById = {
      for (final service in queryServices)
        service.id: serviceDisplayName(service),
    };
    _translationServiceIds = {
      for (final service in queryServices)
        if (service.type == ServiceType.translation) service.id,
    };
    _defaultServiceId = queryServices
        .where(
          (service) =>
              service.type == ServiceType.translation &&
              isDefaultTranslationService(service, generalSettings),
        )
        .firstOrNull
        ?.id;

    // Detect source language for translation target matching.
    if (_text.isNotEmpty) {
      try {
        final translationService = queryServices.firstWhere(
          (service) => service.type == ServiceType.translation,
        );
        final detectResponse = await runtime
            .translation(providerId: translationService.id)
            .detectLanguage(request: DetectLanguageRequest(texts: [_text]));
        final detections = detectResponse.detections;
        if (detections != null && detections.isNotEmpty) {
          _detectedLanguage = detections.first.detectedLanguage;
          if (mounted) {
            _setStateAndScheduleWindowResize(() {});
          }
        }
      } catch (e) {
        // Detection failed silently; continue without detected language
        debugPrint('Language detection failed: $e');
      }
    }

    final activeTargets = await _activeTranslationTargets(generalSettings);
    final nextTranslationResultList = _createPendingTranslationResults(
      activeTargets,
      queryServices,
    );

    _setStateAndScheduleWindowResize(() {
      _translationResultList = nextTranslationResultList;
    }, animate: false);

    final futures = <Future<bool>>[];
    for (int i = 0; i < _translationResultList.length; i++) {
      final translationTarget = _translationResultList[i].translationTarget;
      final translationResultRecordList =
          _translationResultList[i].translationResultRecordList;
      if (translationResultRecordList == null) {
        continue;
      }

      for (int j = 0; j < translationResultRecordList.length; j++) {
        futures.add(
          _queryProvider(
            service: queryServices[j],
            provider: providersById[queryServices[j].providerId],
            translationTarget: translationTarget,
            translationResultRecord: translationResultRecordList[j],
          ),
        );
      }
    }

    await Future.wait(futures);
    await _saveMiniHistory();
  }

  Future<void> _saveMiniHistory() async {
    final preferred = preferredTranslation(
      _translationResultList,
      _preferredServiceId,
    );
    if (preferred == null || _text.trim().isEmpty) return;
    final serviceId = preferred.record.translationServiceId ?? '';
    final target = preferred.result.translationTarget;
    final entry = await _historySession.save(
      HistoryEntryInput(
        source: _text,
        translation: preferred.text,
        sourceLanguage: _detectedLanguage ?? target?.source ?? kAutoSource,
        targetLanguage: target?.target ?? defaultTargetLanguage,
        serviceId: serviceId,
        serviceName: (_serviceNameById[serviceId] ?? serviceId).trim(),
        edited: false,
      ),
    );
    if (!mounted || entry == null) return;
    _setStateAndScheduleWindowResize(() {
      _starred = entry.favorite;
    });
  }

  Future<void> _preferService(String serviceId) async {
    _setStateAndScheduleWindowResize(() {
      _preferredServiceId = serviceId;
    });
    await _saveMiniHistory();
  }

  Future<void> _toggleHistoryFavorite() async {
    if (_historySession.entryId == null) await _saveMiniHistory();
    final entry = await _historySession.toggleFavorite();
    if (mounted && entry != null) {
      _setStateAndScheduleWindowResize(() => _starred = entry.favorite);
    }
  }

  List<TranslationResult> _createPendingTranslationResults(
    List<TranslationTarget> activeTargets,
    List<ServiceConfigEntry> services,
  ) {
    return [
      for (final translationTarget in activeTargets)
        TranslationResult(
          translationTarget: translationTarget,
          translationResultRecordList: [
            for (final service in services)
              TranslationResultRecord(translationServiceId: service.id),
          ],
          unsupportedServiceIdList: [],
        ),
    ];
  }

  Future<bool> _queryProvider({
    required ServiceConfigEntry service,
    required ProviderConfigEntry? provider,
    required TranslationTarget? translationTarget,
    required TranslationResultRecord translationResultRecord,
  }) async {
    final sourceLanguage = translationTarget?.source;
    final targetLanguage = translationTarget?.target;
    final futures = <Future<void>>[];

    if (service.type == ServiceType.dictionary) {
      futures.add(() async {
        try {
          if (sourceLanguage == null || targetLanguage == null) {
            throw Exception('Translation target language is missing');
          }

          final lookUpRequest = LookUpRequest(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            word: _text,
          );
          final lookUpResponse = await runtime
              .dictionary(providerId: service.id)
              .lookup(request: lookUpRequest);
          translationResultRecord.lookUpRequest = lookUpRequest;
          translationResultRecord.lookUpResponse = lookUpResponse;
        } catch (error) {
          translationResultRecord.lookUpError = TranslationError(
            message: error.toString(),
          );
        }
        if (mounted) _setStateAndScheduleWindowResize(() {});
      }());
    }

    if (service.type == ServiceType.translation) {
      final providerType = provider?.type;
      final isLlmProvider = providerType == ProviderType.openAi ||
          providerType == ProviderType.anthropic ||
          providerType == ProviderType.ollama ||
          providerType == ProviderType.xAi;

      if (isLlmProvider) {
        // Streaming LLM translation — update UI progressively
        futures.add(() async {
          try {
            final translateRequest = TranslateRequest(
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
              text: _text,
            );
            translationResultRecord.translateRequest = translateRequest;

            final buffer = StringBuffer();
            final stream = LlmStream.translate(
              providerId: service.id,
              sourceLang: sourceLanguage ?? 'auto',
              targetLang: targetLanguage ?? 'en',
              text: _text,
            );

            await for (final chunk in stream) {
              if (chunk.content.isNotEmpty) {
                buffer.write(chunk.content);
                // Update the record with accumulated text so far
                translationResultRecord.translateResponse = TranslateResponse(
                  translations: [
                    TextTranslation(
                      text: buffer.toString(),
                      detectedSourceLanguage: null,
                      audioUrl: null,
                    ),
                  ],
                );
                if (mounted) {
                  _setStateAndScheduleWindowResize(() {});
                }
              }
            }
          } catch (error) {
            translationResultRecord.translateError = TranslationError(
              message: error.toString(),
            );
            if (mounted) _setStateAndScheduleWindowResize(() {});
          }
        }());
      } else {
        // Traditional non-streaming translation
        futures.add(() async {
          try {
            final translateRequest = TranslateRequest(
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
              text: _text,
            );
            final translateResponse = await runtime
                .translation(providerId: service.id)
                .translate(request: translateRequest);
            translationResultRecord.translateRequest = translateRequest;
            translationResultRecord.translateResponse = translateResponse;
          } catch (error) {
            translationResultRecord.translateError = TranslationError(
              message: error.toString(),
            );
          }
        }());
      }
    }

    await Future.wait(futures);

    if (mounted) {
      _setStateAndScheduleWindowResize(() {});
    }
    return true;
  }

  Future<List<TranslationTarget>> _activeTranslationTargets(
    GeneralSettings generalSettings,
  ) async {
    final persistentTargets = generalSettings.translationTargets;

    if (_activeConfigIndex >= 0 &&
        _activeConfigIndex < persistentTargets.length) {
      return [persistentTargets[_activeConfigIndex]];
    }

    if (_selectedTargetLanguage != null) {
      return _fastTargets.isNotEmpty
          ? _fastTargets
          : [
              TranslationTarget(
                source: _sourceLanguage,
                target: _selectedTargetLanguage!,
                enabled: true,
              ),
            ];
    }

    if (persistentTargets.isNotEmpty) {
      final settings = runtime.settings();
      final active = await settings.getActiveTranslationTargets(
        targets: persistentTargets,
        detectedLanguage: _detectedLanguage,
        // Detection refuses on short input; the runtime falls back to the
        // script the query is written in so 自动匹配 still routes away from
        // the language the text is already in.
        text: _text,
      );
      // 每一条目标都被关掉时它会空手而归。退回默认目标，而不是安静地什么都不
      // 翻 —— 和 `filter_active` 宁可多翻一种也不翻不出东西的取向一致。
      if (active.isNotEmpty) return active;
    }

    return [
      TranslationTarget(
        source: _sourceLanguage,
        target: defaultTargetLanguage,
        enabled: true,
      ),
    ];
  }

  void _handleSourceChanged(String newSource) {
    _setStateAndScheduleWindowResize(() {
      _sourceLanguage = newSource;
      _activeConfigIndex = -1;
      if (_selectedTargetLanguage != null) {
        _fastTargets = [
          TranslationTarget(
            source: newSource,
            target: _selectedTargetLanguage!,
            enabled: true,
          ),
        ];
      }
    });
    if (_text.isNotEmpty) _handleButtonTappedTrans();
  }

  void _handleTargetLanguageChanged(String? targetCode) {
    _setStateAndScheduleWindowResize(() {
      _selectedTargetLanguage = targetCode;
      _activeConfigIndex = -1;
      _fastTargets = targetCode == null
          ? []
          : [
              TranslationTarget(
                source: _sourceLanguage,
                target: targetCode,
                enabled: true,
              ),
            ];
    });
    if (_text.isNotEmpty) _handleButtonTappedTrans();
  }

  void _handleConfigTargetSelected(int index) {
    if (index == -1) {
      _setStateAndScheduleWindowResize(() {
        _activeConfigIndex = -1;
        _sourceLanguage = kAutoSource;
        _selectedTargetLanguage = null;
        _fastTargets = [];
      });
      if (_text.isNotEmpty) _handleButtonTappedTrans();
      return;
    }
    final target = settingsStore.general.translationTargets[index];
    _setStateAndScheduleWindowResize(() {
      _activeConfigIndex = index;
      _sourceLanguage = target.source;
      _selectedTargetLanguage = target.target;
      _fastTargets = [];
    });
    if (_text.isNotEmpty) _handleButtonTappedTrans();
  }

  void _handleManageTargets() {
    showSettingsWindow();
  }

  void _handleManageCommonLanguages() {
    ServicesSettingsPage.pendingOpenCommonLanguages = true;
    showSettingsWindow();
  }

  void _handleAddTarget() {
    ServicesSettingsPage.pendingOpenAddTarget = true;
    showSettingsWindow();
  }

  void _handleTextChanged(String? newValue, {bool isRequery = false}) {
    _setStateAndScheduleWindowResize(() {
      final previousText = _text;
      _text = (newValue ?? '').trim();
      if (settingsStore.inputSubmitMode == InputSubmitMode.enter) {
        _text = _text.replaceAll('\n', ' ');
      }
      // 原文已修改 — arm ⏎ 重新翻译 on the result block.
      if (_querySubmitted && _text != previousText) {
        _resultStale = true;
      }
    });
    if (isRequery) {
      _textEditingController.text = _text;
      _textEditingController.selection = TextSelection(
        baseOffset: _text.length,
        extentOffset: _text.length,
      );
      _handleButtonTappedTrans();
    }
  }

  void _handleExtractTextFromScreenSelection() async {
    String? text;
    try {
      text = await runtime.textExtractor().extractFromScreenSelection();
    } catch (_) {
      // extractFromScreenSelection may throw if no text is selected or
      // operation fails (e.g. accessibility not granted on macOS).
    }

    await _windowShow();
    await Future.delayed(const Duration(milliseconds: 10));

    _handleTextChanged(text, isRequery: true);
  }

  void _handleExtractTextFromScreenCapture() async {
    _setStateAndScheduleWindowResize(() {
      _querySubmitted = false;
      _text = '';
      _detectedLanguage = null;
      _isTextDetecting = false;
      _translationResultList = [];
    });
    _textEditingController.clear();
    _focusNode.unfocus();

    await _windowHide();

    try {
      final text = await runtime.textExtractor().extractFromScreenCapture();
      await _windowShow();
      _handleTextChanged(text, isRequery: true);
    } catch (error) {
      await _windowShow();
      if (!mounted) return;
      _setStateAndScheduleWindowResize(() {});
      showToast(
        context,
        '${t.mini_translator.message.ocr_recognition_failed}: ${error.toString()}',
        tone: ToastTone.danger,
      );
    }
  }

  void _handleExtractTextFromClipboard() async {
    final windowIsVisible = _window.isVisible;
    if (!windowIsVisible) {
      await _windowShow();
      await Future.delayed(const Duration(milliseconds: 10));
    }

    String? text;
    try {
      text = await runtime.textExtractor().extractFromClipboard();
    } catch (_) {
      // extractFromClipboard may throw if clipboard is empty.
    }
    _handleTextChanged(text, isRequery: true);
  }

  void _handleButtonTappedClear() {
    _setStateAndScheduleWindowResize(() {
      _querySubmitted = false;
      _text = '';
      _detectedLanguage = null;
      _isTextDetecting = false;
      _translationResultList = [];
      _resultStale = false;
      _copiedTarget = null;
      _starred = false;
      _historySession.reset();
    });
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  void _handleButtonTappedCopy() {
    final preferred = preferredTranslation(
      _translationResultList,
      _preferredServiceId,
    );
    if (preferred == null) return;
    _copy(preferred.text, _kCopiedAll);
  }

  /// 复制 on one target's attribution row — that language's preferred text.
  void _handleCopyTarget(String target) {
    for (final result in _translationResultList) {
      if (result.translationTarget?.target != target) continue;
      final preferred = preferredTranslation([result], _preferredServiceId);
      if (preferred != null) _copy(preferred.text, target);
      return;
    }
  }

  void _copy(String text, String key) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedTarget = key);
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _copiedTarget = null);
    });
  }

  void _handleToggleCompare(String target) {
    _setStateAndScheduleWindowResize(() {
      if (!_compareOpen.add(target)) _compareOpen.remove(target);
    });
  }

  /// ⌥1/⌥2/⌥3 promote a service, matching the shortcut hints on the cards —
  /// numbered by the service's position in the configured list, whichever
  /// target's list the hint was read from.
  void _handlePreferServiceAt(int index) {
    final ids = _translationServiceIds.toList();
    if (index < 0 || index >= ids.length) return;
    _preferService(ids[index]);
  }

  void _handleButtonTappedTrans() async {
    if (_text.isEmpty) {
      showToast(context, t.mini_translator.message.please_enter_word_or_text);
      _focusNode.requestFocus();
      return;
    }
    await _queryData();
  }

  Widget _buildBannersView(BuildContext context) {
    bool isNoAllowedAllAccess =
        !(_isAllowedScreenCaptureAccess && _isAllowedScreenSelectionAccess);

    if (!isNoAllowedAllAccess) return const SizedBox.shrink();

    return SizedBox(
      key: _bannersViewKey,
      width: double.infinity,
      child: LimitedFunctionalityBanner(
        isAllowedScreenCaptureAccess: _isAllowedScreenCaptureAccess,
        isAllowedScreenSelectionAccess: _isAllowedScreenSelectionAccess,
        onTappedRecheckIsAllowedAllAccess: () async {
          _isAllowedScreenCaptureAccess =
              await runtime.permission().isScreenRecordingPermissionGranted();
          _isAllowedScreenSelectionAccess =
              await runtime.permission().isAccessibilityPermissionGranted();

          if (!context.mounted) return;
          _setStateAndScheduleWindowResize(() {});

          if (_isAllowedScreenCaptureAccess &&
              _isAllowedScreenSelectionAccess) {
            showToast(
              context,
              t.mini_translator.limited_banner.feedback.enabled,
              tone: ToastTone.success,
            );
          } else {
            showToast(
              context,
              t.mini_translator.limited_banner.feedback.still_missing,
              tone: ToastTone.warn,
            );
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final hasTranslation =
        preferredTranslation(_translationResultList, _preferredServiceId) !=
            null;
    final noResult = _querySubmitted &&
        allServicesFailed(_translationResultList, _translationServiceIds);
    // Several targets: 复制 moves onto each block's attribution row, and the
    // footer keeps only the paragraph-level 收藏 and 翻译.
    final stacked = _translationResultList.length > 1;
    // 语言文件未下载 on every target is a failed query like 未返回结果: nothing
    // to copy or star, and ⏎ is a retry.
    final allMissing = _querySubmitted &&
        allTargetsMissingLanguage(
          _translationResultList,
          _preferredServiceId,
          _translationServiceIds,
        );

    return Column(
      key: _contentViewKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBannersView(context),
        // The deck's MiniPanel: input, result and dictionary share one card
        // floating on the tray. It spans the tray inset edge to edge — the
        // top bar and action bar add their own inner padding on top of it.
        PopoverPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              MiniTranslatorInput(
                focusNode: _focusNode,
                controller: _textEditingController,
                inputSubmitMode: settingsStore.inputSubmitMode,
                targetLanguageName: _selectedTargetLanguage == null
                    ? null
                    : getLanguageName(_selectedTargetLanguage!),
                sourceHeadingParts: sourceHeading(
                  _text.isEmpty
                      ? null
                      : getSourceDisplayName(
                          _detectedLanguage ?? _sourceLanguage,
                        ),
                  detectedAutomatically: isAutoSource(_sourceLanguage),
                ),
                onChanged: (v) => _handleTextChanged(v),
                onSubmitted: _handleButtonTappedTrans,
              ),
              // 两块之间的接缝：译文不再回答上面的原文了。
              if (_resultStale && _querySubmitted)
                MiniTranslatorStaleNotice(
                  inputSubmitMode: settingsStore.inputSubmitMode,
                  onRequery: _handleButtonTappedTrans,
                ),
              MiniTranslatorTranslation(
                querySubmitted: _querySubmitted,
                translationResultList: _translationResultList,
                translationServiceIds: _translationServiceIds,
                serviceNameById: _serviceNameById,
                defaultServiceId: _defaultServiceId,
                preferredServiceId: _preferredServiceId,
                inputSubmitMode: settingsStore.inputSubmitMode,
                matchedAutomatically: _selectedTargetLanguage == null,
                compareOpenTargets: _compareOpen,
                copiedTarget: _copiedTarget,
                onToggleCompare: _handleToggleCompare,
                onCopyTarget: _handleCopyTarget,
                onPreferService: _preferService,
                onRequery: _handleButtonTappedTrans,
              ),
              MiniTranslatorWordDefinition(
                translationResultList: _translationResultList,
              ),
            ],
          ),
        ),
        MiniTranslatorActionButtons(
          inputSubmitMode: settingsStore.inputSubmitMode,
          hasContent: hasTranslation && !allMissing,
          copyVisible: !stacked,
          copied: _copiedTarget == _kCopiedAll,
          starred: _starred,
          translateEnabled: _text.isNotEmpty,
          // 原文译文皆无 —— 开局还没输入 —— 清空无从谈起，整颗收起来。
          clearVisible: _text.isNotEmpty || _querySubmitted,
          retry: noResult || allMissing,
          onCopy: _handleButtonTappedCopy,
          onBookmark: _toggleHistoryFavorite,
          onTranslate: _handleButtonTappedTrans,
          onClear: _handleButtonTappedClear,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The window itself is the deck's MiniWindow tray: the top bar and the
    // action bar sit directly on it, the panel card floats between them.
    return Scaffold(
      backgroundColor: context.colors.tray,
      body: CallbackShortcuts(
        bindings: {
          // ⌥1…⌥9 promote the matching service, as hinted on the cards.
          for (var digit = 1; digit <= 9; digit++)
            SingleActivator(
              LogicalKeyboardKey(LogicalKeyboardKey.digit1.keyId + digit - 1),
              alt: true,
            ): () => _handlePreferServiceAt(digit - 1),
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(_kTrayInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiniTranslatorTopBar(
                key: _toolbarViewKey,
                sourceLanguage: _sourceLanguage,
                selectedTargetLanguage: _selectedTargetLanguage,
                activeConfigIndex: _activeConfigIndex,
                persistentTargets: settingsStore.general.translationTargets,
                commonLanguageCodes:
                    settingsStore.general.commonLanguages.isNotEmpty
                        ? settingsStore.general.commonLanguages
                        : defaultCommonLanguages(),
                onSourceChanged: _handleSourceChanged,
                onTargetLanguageChanged: _handleTargetLanguageChanged,
                onConfigTargetSelected: _handleConfigTargetSelected,
                onManageCommonLanguages: _handleManageCommonLanguages,
                onAddTarget: _handleAddTarget,
                onManageTargets: _handleManageTargets,
                isAlwaysOnTop: _isAlwaysOnTop,
                onTogglePin: () {
                  setState(() {
                    _isAlwaysOnTop = !_isAlwaysOnTop;
                  });
                  // On macOS the panel lives at the floating level regardless;
                  // the pin only exempts it from closing on blur.
                  if (!kIsMacOS) _window.isAlwaysOnTop = _isAlwaysOnTop;
                },
                onExtractScreenCapture: _handleExtractTextFromScreenCapture,
                onExtractClipboard: _handleExtractTextFromClipboard,
                onOpenWorkbench: () => handOffToWorkbench(_text),
                onOpenSettings: showSettingsWindow,
              ),
              _buildBody(context),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Re-implement protocol URL handling when protocol_handler is restored
  // @override
  // void onProtocolUrlReceived(String url) async {
  //   Uri uri = Uri.parse(url);
  //   if (uri.scheme != 'beyondtranslate') return;
  //
  //   if (uri.authority == 'translate') {
  //     if (_text.isNotEmpty) _handleButtonTappedClear();
  //     String? text = uri.queryParameters['text'];
  //     if (text != null && text.isNotEmpty) {
  //       _handleTextChanged(text, isRequery: true);
  //     }
  //   }
  //   await _windowShow();
  // }

  @override
  void onShortcutKeyDownToggleMiniTranslator() async {
    final isVisible = _window.isVisible;
    if (isVisible) {
      _windowHide();
    } else {
      _windowShow();
    }
  }

  @override
  void onShortcutKeyDownExtractFromScreenSelection() {
    _handleExtractTextFromScreenSelection();
  }

  @override
  void onShortcutKeyDownExtractFromScreenCapture() {
    _handleExtractTextFromScreenCapture();
  }

  @override
  void onShortcutKeyDownExtractFromClipboard() {
    _handleExtractTextFromClipboard();
  }

  @override
  void onShortcutKeyDownTranslateInputContent() {
    // TODO: Reimplement when keypress_simulator dependency is restored
  }
}
