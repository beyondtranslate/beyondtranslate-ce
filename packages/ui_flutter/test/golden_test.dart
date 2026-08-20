// Per-block goldens for the widgets whose geometry the deck pins.
//
// These are assertions, not a picture book: each block renders on its own at
// DPR 1 into a few tens of kilobytes, so a regression names the block it broke
// and the image is small enough to look at. Refresh them with
// `flutter test --update-goldens` after a deliberate visual change.
//
// The faces are the real ones: `-apple-system` and PingFang SC are what the
// tokens resolve to on the machines this ships from, and half of what these
// images are for is reading the type — a wall of placeholder boxes would show
// the boxes but not the typography. The icon font comes out of the pub package,
// so the chevrons and arrows are real glyphs too.
//
// The trade is that a host without those faces cannot reproduce the images, so
// the suite skips itself there rather than reporting a wall of false diffs.
// That makes these a macOS-local guard; `widget_metrics_test.dart` is the part
// that holds everywhere.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Where pub put a dependency, read off the package config rather than the
/// asset bundle: the bundle's root depends on which directory `flutter test`
/// was invoked from, and these goldens have to render the same either way.
Directory _packageRoot(String package) {
  for (var dir = Directory.current;; dir = dir.parent) {
    final config = File('${dir.path}/.dart_tool/package_config.json');
    if (config.existsSync()) {
      final packages =
          (jsonDecode(config.readAsStringSync()) as Map)['packages'] as List;
      for (final entry in packages.cast<Map<String, dynamic>>()) {
        if (entry['name'] != package) continue;
        return Directory.fromUri(
          config.uri.resolve(entry['rootUri'] as String),
        );
      }
    }
    if (dir.parent.path == dir.path) {
      fail(
        '$package is not in any package_config.json above ${Directory.current.path}',
      );
    }
  }
}

/// The host faces the tokens resolve to. `-apple-system` is SF; the CJK
/// fallback is PingFang SC; ⌕ ⇄ ✕ ✓ sit outside SF's own coverage and macOS
/// resolves them through Apple Symbols, which the test environment has to be
/// told about — it goes in as its own family and is reached through the
/// fallback lists, so it never outranks the CJK face.
const _hostFaces = {
  'SF': '/System/Library/Fonts/SFNS.ttf',
  'PingFang SC': '/System/Library/Fonts/STHeiti Medium.ttc',
  'SF Mono': '/System/Library/Fonts/Menlo.ttc',
  'Symbols': '/System/Library/Fonts/Apple Symbols.ttf',
};

/// The type roles bound to those faces. `flutter test` does not resolve
/// `family: null` to the platform UI font the way the running app does, so the
/// roles have to name the families that were just registered.
const _typography = DesignTypography(
  display: DesignFont(family: 'SF', fallback: ['PingFang SC', 'Symbols']),
  sans: DesignFont(family: 'SF', fallback: ['PingFang SC', 'Symbols']),
  label: DesignFont(family: 'SF', fallback: ['PingFang SC', 'Symbols']),
  cjk: DesignFont(family: 'PingFang SC', fallback: ['SF', 'Symbols']),
  mono: DesignFont(family: 'SF Mono', fallback: ['PingFang SC', 'Symbols']),
);

Future<void> _load(String family, Uint8List bytes) async {
  final loader = FontLoader(family)
    ..addFont(Future.value(bytes.buffer.asByteData()));
  await loader.load();
}

void main() {
  final missing = [
    for (final entry in _hostFaces.entries)
      if (!File(entry.value).existsSync()) entry.key,
  ];

  group('goldens', () {
    setUpAll(() async {
      for (final entry in _hostFaces.entries) {
        await _load(entry.key, File(entry.value).readAsBytesSync());
      }
      final icons = _packageRoot('fluentui_system_icons');
      for (final font in const ['Regular', 'Filled']) {
        final file = File(
          '${icons.path}/lib/fonts/FluentSystemIcons-$font.ttf',
        );
        if (!file.existsSync()) fail('missing icon font: ${file.path}');
        await _load(
          'packages/fluentui_system_icons/FluentSystemIcons-$font',
          file.readAsBytesSync(),
        );
      }
    });

    /// Renders [child] at [width] on the theme's window surface and compares it
    /// with `goldens/<name>.png`.
    Future<void> expectGolden(
      WidgetTester tester,
      String name,
      Widget child, {
      double width = 380,
      DesignThemeName theme = DesignThemeName.studioLight,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 1200);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        DesignThemeProvider(
          theme: theme,
          tokens: theme.tokens.copyWith(typography: _typography),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: const ValueKey('golden'),
                child: Builder(
                  builder: (context) => Container(
                    width: width,
                    color: context.colors.window,
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('goldens/$name.png'),
      );
    }

    Widget column(List<Widget> children, {double gap = 10}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(height: gap),
              children[i],
            ],
          ],
        );

    Widget row(List<Widget> children, {double gap = 8}) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              children[i],
            ],
          ],
        );

    testWidgets('button variants', (tester) async {
      await expectGolden(
        tester,
        'button_variants',
        column([
          row([
            Button(
              variant: ButtonVariant.primary,
              onPressed: () {},
              child: const Text('翻译'),
            ),
            Button(
              variant: ButtonVariant.secondary,
              onPressed: () {},
              child: const Text('朗读'),
            ),
            Button(onPressed: () {}, child: const Text('收藏')),
          ]),
          row([
            Button(
              variant: ButtonVariant.tint,
              onPressed: () {},
              child: const Text('对比'),
            ),
            Button(
              variant: ButtonVariant.quiet,
              onPressed: () {},
              child: const Text('设为首选'),
            ),
            Button(
              variant: ButtonVariant.plain,
              onPressed: () {},
              child: const Text('测试连接'),
            ),
            Button(
              variant: ButtonVariant.warning,
              onPressed: () {},
              child: const Text('冲突'),
            ),
          ]),
          // Disabled: the filled variants swap to the track fill, the text-only
          // ones just dim.
          row([
            const Button(
              variant: ButtonVariant.primary,
              enabled: false,
              child: Text('翻译'),
            ),
            const Button(enabled: false, child: Text('收藏')),
            const Button(
              variant: ButtonVariant.quiet,
              enabled: false,
              child: Text('设为首选'),
            ),
          ]),
        ]),
      );
    });

    testWidgets('button sizes', (tester) async {
      await expectGolden(
        tester,
        'button_sizes',
        row([
          for (final size in ButtonSize.values)
            Button(
              size: size,
              variant: ButtonVariant.primary,
              shortcut: const Text('⏎'),
              onPressed: () {},
              child: const Text('翻译'),
            ),
        ]),
      );
    });

    testWidgets('form controls', (tester) async {
      await expectGolden(
        tester,
        'form_controls',
        column([
          const Field(
            label: Text('API Key'),
            hint: Text('存放在系统钥匙串'),
            child: Input(placeholder: 'sk-…', mono: true),
          ),
          Select<String>(
            items: const [SelectItem(value: 'a', label: '标准')],
            value: 'a',
            onChanged: (_) {},
          ),
          SearchField(value: '', onChanged: (_) {}),
          SegmentedControl<String>(
            value: 'light',
            onChanged: (_) {},
            items: const [
              SegmentedItem(value: 'light', label: Text('浅色')),
              SegmentedItem(value: 'dark', label: Text('深色')),
              SegmentedItem(value: 'auto', label: Text('跟随')),
            ],
          ),
          row([
            const Switch(checked: true),
            const Switch(checked: false),
            const Switch(checked: true, size: SwitchSize.sm),
          ]),
          row([
            Checkbox(checked: true, onChanged: (_) {}, child: const Text('原文')),
            Radio(checked: true, onSelect: () {}, child: const Text('译文')),
          ], gap: 16),
        ]),
      );
    });

    testWidgets('chips', (tester) async {
      await expectGolden(
        tester,
        'chips',
        column([
          row([
            for (final tone in BadgeTone.values)
              Badge(tone: tone, child: const Text('默认')),
          ], gap: 6),
          row([
            const Badge(size: BadgeSize.sm, child: Text('3 SERVICES')),
            const Kbd('⌘K'),
            const Kbd('⌘F', variant: KbdVariant.key),
          ]),
          Tabs<String>(
            value: 'all',
            onChanged: (_) {},
            items: const [
              TabItem(value: 'all', label: Text('全部')),
              TabItem(value: 'starred', label: Text('收藏'), count: 64),
            ],
          ),
        ]),
      );
    });

    testWidgets('toasts', (tester) async {
      // No Spinner variant here: its repeat animation never settles under
      // pumpAndSettle. The in-flight story lives in the example app instead.
      await expectGolden(
        tester,
        'toasts',
        width: 460,
        column([
          const Toast(child: Text('已存至「下载」· 3.6 MB')),
          const Toast(tone: ToastTone.success, child: Text('已复制译文')),
          const Toast(
            tone: ToastTone.warn,
            child: Text('DeepL 超时 —— 已切换到 OpenAI 兜底'),
          ),
          Toast(
            tone: ToastTone.danger,
            onDismiss: () {},
            child: const Text('连接已断开 —— 正在重试'),
          ),
          Toast(
            action: Button(
              variant: ButtonVariant.quiet,
              onPressed: () {},
              child: const Text('撤销'),
            ),
            child: const Text('已存入生词本'),
          ),
        ]),
      );
    });

    testWidgets('sidebar group', (tester) async {
      await expectGolden(
        tester,
        'sidebar_group',
        width: 172,
        SizedBox(
          height: 220,
          child: Sidebar(
            footer: const SidebarCard(
              gap: 6,
              children: [Text('2.4.0'), Text('已是最新')],
            ),
            children: [
              SidebarGroup(
                first: true,
                label: const Text('工作区'),
                children: [
                  NavItem(
                    active: true,
                    onPressed: () {},
                    icon: const Icon(FluentIcons.translate_20_regular),
                    child: const Text('翻译'),
                  ),
                  NavItem(
                    onPressed: () {},
                    icon: const Icon(FluentIcons.book_20_regular),
                    child: const Text('术语库'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });

    testWidgets('surfaces in every theme', (tester) async {
      for (final theme in DesignThemeName.values) {
        await expectGolden(
          tester,
          'surfaces_${theme.id}',
          theme: theme,
          width: 300,
          column([
            const Callout(
              tone: CalloutTone.accent,
              child: Text('正在测试连接 · 已用 1.4s'),
            ),
            const Surface(tone: SurfaceTone.raised, child: Text('白卡片')),
            const Meter(label: Text('术语一致性'), value: 92),
          ]),
        );
      }
    });
  }, skip: missing.isEmpty ? false : 'host is missing ${missing.join(', ')}');
}
