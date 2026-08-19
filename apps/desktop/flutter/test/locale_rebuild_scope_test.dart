import 'dart:ui';

import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// The shape of the app: a `MaterialApp.router` whose shell and pages read the
/// global `t`. Everything under the router lives in `Overlay` entries, so an
/// ancestor rebuild never reaches them — without [LocaleRebuildScope] a
/// language switch left the sidebar, the pages and any open dialog in the old
/// language. The router is what makes this worth a test: with a plain
/// `MaterialApp(home:)` the route content happens to rebuild anyway.
void main() {
  setUpAll(() => LocaleSettings.setLocaleRaw('zh-Hans'));

  testWidgets('a language switch reaches the shell, the page and a dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(child: const LocaleRebuildScope(child: _App())),
    );
    await tester.pumpAndSettle();

    // 翻译 in the shell, 术语库 in the page — Translate / Glossary once in en.
    final shellLabel = t.workbench.translate;
    final pageLabel = t.workbench.glossary;
    expect(find.text(shellLabel), findsOneWidget);
    expect(find.text(pageLabel), findsOneWidget);

    // Dialogs are their own overlay entries — the switch has to reach them too.
    showDialog<void>(
      context: tester.element(find.text(pageLabel)),
      builder: (_) => Text(t.workbench.history),
    );
    await tester.pumpAndSettle();
    final dialogLabel = t.workbench.history;
    expect(find.text(dialogLabel), findsOneWidget);

    await LocaleSettings.setLocaleRaw('en');
    await tester.pumpAndSettle();

    expect(find.text(shellLabel), findsNothing);
    expect(find.text(pageLabel), findsNothing);
    expect(find.text(dialogLabel), findsNothing);
    expect(find.text(t.workbench.translate), findsOneWidget);
    expect(find.text(t.workbench.glossary), findsOneWidget);
    expect(find.text(t.workbench.history), findsOneWidget);
  });

  testWidgets('the switch rebuilds without unmounting state', (tester) async {
    await LocaleSettings.setLocaleRaw('zh-Hans');
    await tester.pumpWidget(
      TranslationProvider(child: const LocaleRebuildScope(child: _App())),
    );
    await tester.pumpAndSettle();

    // A page that kept typed text or a scroll offset would lose it if the
    // scope re-keyed the subtree instead of marking it dirty.
    await tester.enterText(find.byType(EditableText), 'unsaved draft');
    await tester.pumpAndSettle();
    final page = tester.state<_PageState>(find.byType(_Page));

    await LocaleSettings.setLocaleRaw('en');
    await tester.pumpAndSettle();

    expect(tester.state<_PageState>(find.byType(_Page)), same(page));
    expect(find.text('unsaved draft'), findsOneWidget);
  });

  testWidgets('one scope above the windows refreshes both of them', (
    tester,
  ) async {
    await LocaleSettings.setLocaleRaw('zh-Hans');
    // The scope sits above the window manager, so the walk has to cross the
    // `View` boundary each window is mounted behind.
    await tester.pumpWidget(
      wrapWithView: false,
      TranslationProvider(
        child: LocaleRebuildScope(
          child: ViewCollection(
            views: [
              View(view: tester.view, child: const _App()),
              View(view: _FakeView(tester.view), child: const _App()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.workbench.translate), findsNWidgets(2));
    final before = t.workbench.translate;

    await LocaleSettings.setLocaleRaw('en');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(before), findsNothing);
    expect(find.text(t.workbench.translate), findsNWidgets(2));
  });
}

/// A second [FlutterView] so [ViewCollection] has two to mount, standing in for
/// the workbench and mini translator windows. Rendering is dropped because the
/// engine only ever observes the one real view.
class _FakeView extends TestFlutterView {
  _FakeView(FlutterView view)
      : super(
          view: view,
          platformDispatcher: view.platformDispatcher as TestPlatformDispatcher,
          display: view.display as TestDisplay,
        );

  @override
  int get viewId => 100;

  @override
  void render(Scene scene, {Size? size}) {}

  @override
  void updateSemantics(SemanticsUpdate update) {}
}

class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/translate',
    routes: [
      ShellRoute(
        builder: (_, __, child) => _Shell(child: child),
        routes: [
          GoRoute(
            path: '/translate',
            pageBuilder: (_, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const _Page(),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

/// Stands in for the workbench sidebar: built by the shell route, so it is the
/// one the report named — 切换语言时侧边栏没有刷新.
class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text(t.workbench.translate), Expanded(child: child)],
      ),
    );
  }
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(t.workbench.glossary),
        TextField(controller: _controller),
      ],
    );
  }
}
