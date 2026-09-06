// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/src/widgets/_window.dart' as flutter_window
    show WindowController, WindowEntry, WindowManager, WindowRegistry;
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart';
import 'package:path_provider/path_provider.dart';

import '../i18n/i18n.dart';
import '../services/app_windows.dart';
import '../services/dock_icon_controller.dart';
import '../services/mac_app_presentation.dart';
import '../services/settings_store.dart';
import '../services/shortcut_service/shortcut_service.dart';
import '../theme/app_theme.dart';
import '../utils/language_util.dart';
import '../widgets/toast_host.dart';
import '__root.dart';
import 'debug/runtime.dart' as debug_runtime_route;
import 'debug/widget_showcase.dart' as widget_showcase_route;
import 'mini_translator/mini_translator.dart';
import 'workbench/index.dart' as workbench_route;

// ──────────────────────────────────────────────────────────────────────────────
// Routers
// ──────────────────────────────────────────────────────────────────────────────

/// Assembles the main application's route graph from modular route files.
///
/// TanStack Start-inspired organization:
/// - each route lives in its own module/file
/// - this file is the composition root for router setup
GoRouter createWorkbenchAppRouter({String? initialLocation}) {
  return GoRouter(
    routes: <RouteBase>[
      ...$appRoutes,
      ...debug_runtime_route.$appRoutes,
      ...widget_showcase_route.$appRoutes,
      ...workbench_route.$appRoutes,
    ],
    initialLocation: initialLocation ?? pendingWorkbenchLocation,
    debugLogDiagnostics: false,
  );
}

/// Assembles the mini-translator window's route graph.
GoRouter createMiniTranslatorAppRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, states) => const MiniTranslatorPage(),
      ),
    ],
    debugLogDiagnostics: false,
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// App widgets
// ──────────────────────────────────────────────────────────────────────────────

class WorkbenchApp extends StatefulWidget {
  const WorkbenchApp({super.key});

  @override
  State<WorkbenchApp> createState() => _WorkbenchAppState();
}

class _WorkbenchAppState extends State<WorkbenchApp> {
  late final GoRouter _router = createWorkbenchAppRouter();

  @override
  void initState() {
    super.initState();
    attachWorkbenchRouter(_router);
    settingsStore.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    detachWorkbenchRouter(_router);
    settingsStore.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: kWorkbenchWindowTitle,
      theme: appThemeData(
        settingsStore.themeFamily.themeFor(Brightness.light),
      ),
      darkTheme: appThemeData(
        settingsStore.themeFamily.themeFor(Brightness.dark),
      ),
      themeMode: settingsStore.themeMode,
      builder: (context, child) => _withDesignTokens(context, child!),
      routerConfig: _router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

/// Establishes the design system's root defaults under the resolved Material
/// brightness, so every kit widget below reads the same palette [appThemeData]
/// was built from — and gives the window its own [ToastHost], so each window
/// stacks its own notifications.
Widget _withDesignTokens(BuildContext context, Widget child) {
  return AppThemeProvider(
    theme: settingsStore.themeFamily.themeFor(Theme.of(context).brightness),
    child: ToastHost(child: child),
  );
}

class MiniTranslatorApp extends StatefulWidget {
  const MiniTranslatorApp({super.key});

  @override
  State<MiniTranslatorApp> createState() => _MiniTranslatorAppState();
}

class _MiniTranslatorAppState extends State<MiniTranslatorApp> {
  late final GoRouter _router = createMiniTranslatorAppRouter();

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    settingsStore.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: kMiniTranslatorWindowTitle,
      theme: appThemeData(
        settingsStore.themeFamily.themeFor(Brightness.light),
      ),
      darkTheme: appThemeData(
        settingsStore.themeFamily.themeFor(Brightness.dark),
      ),
      themeMode: settingsStore.themeMode,
      builder: (context, child) => _withDesignTokens(context, child!),
      routerConfig: _router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    // The scope sits above the window manager so one language switch reaches
    // every window — both the workbench and the mini translator hang off it.
    return TranslationProvider(
      child: const LocaleRebuildScope(child: _RootBodyView()),
    );
  }
}

class _RootBodyView extends StatefulWidget {
  const _RootBodyView();

  @override
  State<_RootBodyView> createState() => _RootBodyViewState();
}

class _RootBodyViewState extends State<_RootBodyView> {
  // Construct the initial controller before initState schedules callbacks.
  // Creating a Win32 window can pump messages, so lazy initialization from
  // build() would allow the callback to re-enter the top-level initializer.
  final flutter_window.WindowController _workbenchController =
      workbenchWindowController;
  late final TrayIcon _trayIcon;
  late bool _showInMenuBar;

  @override
  void initState() {
    _showInMenuBar = settingsStore.general.showInMenuBar;
    settingsStore.addListener(_handleChanged);
    _setupTrayIcon();
    // The global keys answer for as long as the app runs, not for as long as
    // any window is up: 唤起迷你翻译 has to work before that window exists.
    ShortcutService.instance.start();
    MacAppPresentation.setHandlers(
      // The Dock icon only exists while the app is promoted, and the workbench
      // is the only window it stands for — the mini translator is
      // tray/shortcut driven. Focus rather than show: a Dock click brings the
      // window back on whatever page it was on.
      onReopen: focusWorkbenchWindow,
      onOpenSettings: showSettingsWindow,
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showWorkbenchWindow();
    });
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    _trayIcon.dispose();
    super.dispose();
  }

  Future<void> _handleChanged() async {
    // Handle language change
    final oldLocale = context.locale;
    final newLocale = languageToLocale(settingsStore.appLanguage);
    if (newLocale != oldLocale) {
      await context.setLocale(newLocale);
      _trayIcon.setContextMenu(_buildContextMenu());
    }

    // Handle show in menu bar toggle
    final newShowInMenuBar = settingsStore.general.showInMenuBar;
    if (newShowInMenuBar != _showInMenuBar) {
      _showInMenuBar = newShowInMenuBar;
      _trayIcon.setVisible(newShowInMenuBar);
      // Dropping the tray icon would leave the app with no visible entry
      // point, so the Dock icon takes over.
      dockIconController.setTrayIconVisible(newShowInMenuBar);
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Tray icon
  // ────────────────────────────────────────────────────────────────────────────

  void _setupTrayIcon() {
    _trayIcon = TrayIcon.create()!;
    final icon = ImageAsset.fromAsset('resources/images/tray_icon.png');
    if (icon != null) _trayIcon.icon = icon;
    _trayIcon.setVisible(_showInMenuBar);
    dockIconController.setTrayIconVisible(_showInMenuBar);
    _trayIcon.setContextMenu(_buildContextMenu());
    _trayIcon.setContextMenuTrigger(ContextMenuTrigger.rightClicked);
    _trayIcon.addListener((event) {
      if (event is TrayIconClickedEvent) {
        handleTrayIconClick(trayBounds: _trayIcon.getBounds());
      }
    });
  }

  Menu _buildContextMenu() {
    final menu = Menu.create()!;

    // ── 显示窗口 ──
    menu.addItem(
      MenuItem.createWithLabelAndType(
        t.app.tray.context_menu.show_window,
        MenuItemType.normal,
      )!
        ..addListener((event) {
          if (event is! MenuItemClickedEvent) return;
          // 显示窗口 keeps whatever page the workbench was on.
          focusWorkbenchWindow();
        }),
    );

    menu.addSeparator();

    // ── 🔧 开发工具 (仅 Debug 模式可见) ──
    if (kDebugMode) {
      final devToolsSubmenu = Menu.create()!;

      // 打开数据目录
      devToolsSubmenu.addItem(
        MenuItem.createWithLabelAndType(
          t.app.tray.context_menu.dev_tools.open_data_directory,
          MenuItemType.normal,
        )!
          ..addListener((event) async {
            if (event is! MenuItemClickedEvent) return;
            final dir = await getApplicationSupportDirectory();
            UrlOpener.instance.open('file://${dir.path}');
          }),
      );

      final devToolsItem = MenuItem.createWithLabelAndType(
        t.app.tray.context_menu.dev_tools.title,
        MenuItemType.submenu,
      )!;
      devToolsItem.submenu = devToolsSubmenu;
      menu.addItem(devToolsItem);
    }

    // ── Check for updates (暂不实现) ──
    menu.addItem(
      MenuItem.createWithLabelAndType(
        t.app.tray.context_menu.check_for_updates,
        MenuItemType.normal,
      ),
    );

    // ── 设置 ──
    menu.addItem(
      MenuItem.createWithLabelAndType(
        t.app.tray.context_menu.settings,
        MenuItemType.normal,
      )!
        ..addListener((event) {
          if (event is! MenuItemClickedEvent) return;
          showSettingsWindow();
        }),
    );

    menu.addSeparator();

    // ── 退出 ──
    menu.addItem(
      MenuItem.createWithLabelAndType(
        t.app.tray.context_menu.quit,
        MenuItemType.normal,
      )!
        ..addListener((event) {
          if (event is! MenuItemClickedEvent) return;
          exit(0);
        }),
    );

    return menu;
  }

  @override
  Widget build(BuildContext context) {
    return flutter_window.WindowManager(
      initialWindows: [
        flutter_window.WindowEntry(
          controller: _workbenchController,
          builder: (context) {
            // The mini translator is registered into this same registry on
            // first use; see `showMiniTranslatorWindow`.
            attachWindowRegistry(
              flutter_window.WindowRegistry.of(context),
              miniTranslatorBuilder: (_) => const MiniTranslatorApp(),
            );
            return const WorkbenchApp();
          },
        ),
      ],
    );
  }
}
