// ignore_for_file: deprecated_member_use, unused_element

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nativeapi_flutter/nativeapi_flutter.dart' as nativeapi;

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
import '../../widgets/popover_panel.dart' show PopoverPanel;
import '../../widgets/toast_host.dart' show showToast;
import '../../widgets/ui.dart' show ThemeDataBuildContextProps, ToastTint;
import 'limited_functionality_banner.dart';
import 'translation_input_view.dart';
import 'translation_results_view.dart';
import 'translation_target_select_view.dart';

/// The tray's own inset (`--bt-mini-tray-pad`): the top bar, the panel card and
/// the action bar all float this far inside the window edge.
const double _kTrayInset = 8;

/// The same inset on the sides, widened. The window is narrow, so the cards
/// run nearly its full width; at 8px the 原文/译文 blocks read as pressed
/// against the window edge rather than floating on the tray.
const double _kTrayInsetX = 12;

/// What the footer's 复制 is keyed under — it copies the first target's text.
const String _kCopiedAll = '*';

class MiniTranslatorPage extends StatefulWidget {
  const MiniTranslatorPage({super.key});

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

  /// Which target's 复制 just fired — a block's, or [_kCopiedAll] for the
  /// footer's.
  String? _copiedTarget;
  bool _starred = false;
  final TranslationHistorySession _historySession = TranslationHistorySession();
  Timer? _copiedTimer;

  /// Service display names and the translation-service ids, captured per query
  /// so the results view can attribute records without re-fetching settings.
  Map<String, String> _serviceNameById = {};

  /// The provider type behind each queried service, captured with the names so
  /// a compare row can carry the provider's own mark.
  Map<String, ProviderType> _providerTypeByServiceId = {};
  Set<String> _translationServiceIds = {};

  /// The translation service 设置 marks 默认, captured per query: it is the
  /// one the query runs, and its output fills the block.
  String? _defaultServiceId;

  /// The services this query was built from, kept so 对比 can ask the ones the
  /// query skipped without re-reading settings.
  List<ServiceConfigEntry> _queryServices = const [];
  Map<String, ServiceConfigEntry> _serviceById = const {};
  Map<String, ProviderConfigEntry> _providersById = const {};

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

  /// Re-reads both system permissions and lets the 功能受限 banner follow.
  ///
  /// It used to be asked once, in [initState], and the mini translator's page
  /// is registered on its first show and then merely hidden and shown — so
  /// that was once per app run, and the only other way to ask was the banner's
  /// own 重新检查 button, which does not exist while the banner is hidden.
  /// Revoking a permission on a running app therefore never surfaced.
  ///
  /// macOS answers `AXIsProcessTrusted()` live, but
  /// `CGPreflightScreenCaptureAccess()` is cached for the life of the process:
  /// a screen-recording grant or revocation made while the app runs is
  /// invisible here until it restarts. So this catches up with the
  /// accessibility half in-session, and the 重新检查 feedback says as much
  /// when the other half will not move.
  Future<void> _refreshPermissions() async {
    if (!kIsMacOS) return;
    final permission = runtime.permission();
    final screenCapture = await permission.isScreenRecordingPermissionGranted();
    final screenSelection = await permission.isAccessibilityPermissionGranted();
    if (!mounted) return;
    if (screenCapture == _isAllowedScreenCaptureAccess &&
        screenSelection == _isAllowedScreenSelectionAccess) {
      return;
    }
    _setStateAndScheduleWindowResize(() {
      _isAllowedScreenCaptureAccess = screenCapture;
      _isAllowedScreenSelectionAccess = screenSelection;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back from System Settings is the moment the answer may have
    // changed — and the trip there is how it is changed at all.
    if (state == AppLifecycleState.resumed) _refreshPermissions();
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
    await _refreshPermissions();

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
          windowSize: _window.size.toSize(),
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
        // The window comes back to the front after a trip to System Settings.
        _refreshPermissions();
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
        _lastShownPosition = event.newPosition.toOffset();
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
      _window.position = _lastShownPosition.toNative();
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
      final oldSize = _window.size.toSize();
      final newHeight = _measureWindowHeight();
      final newSize = Size(oldSize.width, newHeight.clamp(0, _maxWindowHeight));
      if (oldSize.width == newSize.width && oldSize.height == newSize.height) {
        return;
      }
      _window.setSize(newSize.toNative(), animate);
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
      // A new query asks the default service and nothing else, so the lists
      // fold back up: leaving one open would leave it staring at services
      // this query never ran.
      _compareOpen.clear();
    });

    final settings = runtime.settings();
    final providers = await settings.listProviders();
    final services = await settings.listServices();
    final generalSettings = await settings.getGeneral();
    _providersById = {
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
    _queryServices = queryServices;
    _serviceById = {for (final service in queryServices) service.id: service};
    _serviceNameById = {
      for (final service in queryServices)
        service.id: serviceDisplayName(service),
    };
    _providerTypeByServiceId = {
      for (final service in queryServices)
        if (_providersById[service.providerId] case final provider?)
          service.id: provider.type,
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

    // Only the default translation service runs on submit — the rest are asked
    // when 对比 opens, so a query costs one translation per target however many
    // services are configured. Dictionary lookups always run: 词典 is its own
    // block, not a folded candidate. A service with no record is a service
    // that was not asked, which is what keeps the folded ones out of the
    // block's own state.
    final leadServiceId = _defaultServiceId ??
        queryServices
            .where((service) => service.type == ServiceType.translation)
            .firstOrNull
            ?.id;
    final activeTargets = await _activeTranslationTargets(generalSettings);
    final nextTranslationResultList = _createPendingTranslationResults(
      activeTargets,
      queryServices
          .where((service) =>
              service.type != ServiceType.translation ||
              service.id == leadServiceId)
          .toList(growable: false),
    );

    _setStateAndScheduleWindowResize(() {
      _translationResultList = nextTranslationResultList;
    }, animate: false);

    final futures = <Future<bool>>[];
    for (final result in _translationResultList) {
      for (final record in result.translationResultRecordList ??
          const <TranslationResultRecord>[]) {
        final service = _serviceById[record.translationServiceId];
        if (service == null) continue;
        futures.add(
          _queryProvider(
            service: service,
            translationTarget: result.translationTarget,
            translationResultRecord: record,
          ),
        );
      }
    }

    await Future.wait(futures);
    await _saveMiniHistory();
  }

  /// The services behind 对比, asked the moment the list opens rather than on
  /// submit. Each is asked once: a second 对比 on the same target finds every
  /// service already holding a record and does nothing.
  Future<void> _queryComparisonServices(TranslationResult result) async {
    final records = result.translationResultRecordList;
    if (records == null) return;
    final asked = {
      for (final record in records) record.translationServiceId,
    };
    final pending = _queryServices
        .where((service) =>
            service.type == ServiceType.translation &&
            !asked.contains(service.id))
        .toList(growable: false);
    if (pending.isEmpty) return;

    final added = [
      for (final service in pending)
        TranslationResultRecord(translationServiceId: service.id),
    ];
    // The rows are spinners from here until the answers land.
    _setStateAndScheduleWindowResize(() => records.addAll(added));

    await Future.wait([
      for (int i = 0; i < pending.length; i++)
        _queryProvider(
          service: pending[i],
          translationTarget: result.translationTarget,
          translationResultRecord: added[i],
        ),
    ]);
  }

  Future<void> _saveMiniHistory() async {
    final preferred = preferredTranslation(
      _translationResultList,
      _defaultServiceId,
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
    required TranslationTarget? translationTarget,
    required TranslationResultRecord translationResultRecord,
  }) async {
    final provider = _providersById[service.providerId];
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

      // Recorded before the call goes out: the request is what tells the
      // results view this service was asked at all, and the ones 对比 skipped
      // must not read as still in flight.
      final translateRequest = TranslateRequest(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        text: _text,
      );
      translationResultRecord.translateRequest = translateRequest;

      if (isLlmProvider) {
        // Streaming LLM translation — update UI progressively
        futures.add(() async {
          try {
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
            final translateResponse = await runtime
                .translation(providerId: service.id)
                .translate(request: translateRequest);
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
        tone: ToastTint.danger,
      );
    }
  }

  bool _isExtractingClipboard = false;

  void _handleExtractTextFromClipboard() async {
    if (_isExtractingClipboard) return;
    _isExtractingClipboard = true;
    try {
      // Also focus an already visible window when invoked from a global shortcut.
      await _windowShow();
      if (!mounted) return;
      final text = await runtime.textExtractor().extractFromClipboard();
      if (!mounted) return;
      _handleTextChanged(text, isRequery: true);
    } catch (error) {
      if (!mounted) return;
      showToast(
        context,
        '${t.mini_translator.message.ocr_recognition_failed}: $error',
        tone: ToastTint.danger,
      );
    } finally {
      _isExtractingClipboard = false;
    }
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
      _defaultServiceId,
    );
    if (preferred == null) return;
    _copy(preferred.text, _kCopiedAll);
  }

  /// 复制 on one target's attribution row — that language's preferred text.
  void _handleCopyTarget(String target) {
    for (final result in _translationResultList) {
      if (result.translationTarget?.target != target) continue;
      final preferred = preferredTranslation([result], _defaultServiceId);
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
    final opening = !_compareOpen.contains(target);
    _setStateAndScheduleWindowResize(() {
      if (opening) {
        _compareOpen.add(target);
      } else {
        _compareOpen.remove(target);
      }
    });
    // 失效清单 opens over a query that already failed; it lists the reasons
    // it has rather than starting new work.
    if (!opening || target == MiniTranslatorTranslation.kFailureListKey) {
      return;
    }
    final result = _translationResultList
        .where((result) => result.translationTarget?.target == target)
        .firstOrNull;
    if (result != null) unawaited(_queryComparisonServices(result));
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
          await _refreshPermissions();
          if (!context.mounted) return;

          final feedback = t.mini_translator.limited_banner.feedback;
          if (_isAllowedScreenCaptureAccess &&
              _isAllowedScreenSelectionAccess) {
            showToast(context, feedback.enabled, tone: ToastTint.success);
          } else {
            showToast(
              context,
              // Screen recording is the one macOS will not re-answer in this
              // process, so say what actually has to happen next.
              _isAllowedScreenCaptureAccess
                  ? feedback.still_missing
                  : feedback.still_missing_screen_capture,
              tone: ToastTint.warning,
            );
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final hasTranslation =
        preferredTranslation(_translationResultList, _defaultServiceId) != null;
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
          _defaultServiceId,
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
                providerTypeByServiceId: _providerTypeByServiceId,
                defaultServiceId: _defaultServiceId,
                preferredServiceId: _defaultServiceId,
                inputSubmitMode: settingsStore.inputSubmitMode,
                matchedAutomatically: _selectedTargetLanguage == null,
                compareOpenTargets: _compareOpen,
                copiedTarget: _copiedTarget,
                onToggleCompare: _handleToggleCompare,
                onCopyTarget: _handleCopyTarget,
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
    // A `Scaffold` used to paint this; all it was giving the window was its
    // ground, and the tray draws everything else itself.
    //
    // The tray is the paper. `colorSurfaceMuted` is the card sitting on it —
    // "the card, the panel, the toolbar", in the token's own words — and the
    // two were the other way round here, which held in every palette but
    // Bright: Bright's card steps *up* to white where Studio's steps down, so
    // it landed on the same white the tray had taken, and the panel vanished
    // into the window.
    return ColoredBox(
      color: context.vars.colorSurface,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: _kTrayInsetX,
          vertical: _kTrayInset,
        ),
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
}
