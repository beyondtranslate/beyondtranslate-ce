// Per-block goldens for the 业务组件 — the widgets that compose the design
// system's atoms into BeyondTranslate's own vocabulary.
//
// The atoms' own goldens live in `packages/ui_flutter/test/golden_test.dart`;
// this suite is its twin on this side of the boundary, and shares its harness:
// each block renders on its own at DPR 1 into a few tens of kilobytes, so a
// regression names the block it broke and the image is small enough to look at.
// Refresh with `flutter test --update-goldens` after a deliberate visual change.
//
// The faces are the real ones, so a host without them skips the suite rather
// than reporting a wall of false diffs — `design_widget_alignment_test.dart` is
// the part that holds everywhere.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beyondtranslate_desktop/src/routes/mini_translator/limited_functionality_banner.dart';
import 'package:beyondtranslate_desktop/src/theme/app_theme.dart'
    show AppThemeProvider, AppThemeName, DesignThemeFamily;
import 'package:beyondtranslate_desktop/src/widgets/avatar.dart';
import 'package:beyondtranslate_desktop/src/widgets/block_heading.dart';
import 'package:beyondtranslate_desktop/src/widgets/blocks.dart';
import 'package:beyondtranslate_desktop/src/widgets/data_display.dart';
import 'package:beyondtranslate_desktop/src/widgets/popover_panel.dart';
import 'package:beyondtranslate_desktop/src/widgets/swap_pair.dart';
import 'package:beyondtranslate_desktop/src/widgets/theme_picker.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show Badge, PreferenceRow, Switch, ThemeDataBuildContextProps;
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

const _sf = '/System/Library/Fonts/SFNS.ttf';
const _pingFang = '/System/Library/Fonts/STHeiti Medium.ttc';
const _menlo = '/System/Library/Fonts/Menlo.ttc';
const _symbols = '/System/Library/Fonts/Apple Symbols.ttf';

/// The host faces, registered under the names `ProductFonts` asks for on this
/// platform — which is what the kit is handed too, so one set covers both.
///
/// `flutter test` resolves nothing on its own: a family nothing registered
/// comes out as tofu, and a style with no family at all comes out as Ahem's
/// filled boxes. ⌕ ⇄ ✕ ✓ sit outside SF's own coverage and macOS reaches them
/// through Apple Symbols, so it is loaded *into* each family rather than
/// beside it — a family's later fonts are its own fallbacks, and the fallback
/// lists themselves belong to the theme rather than to the test.
const _hostFaces = <String, List<String>>{
  'SF Pro Text': [_sf, _symbols],
  'SF Pro Display': [_sf, _symbols],
  'PingFang SC': [_pingFang],
  'SF Mono': [_menlo, _symbols],
};

Future<void> _load(String family, List<Uint8List> faces) async {
  final loader = FontLoader(family);
  for (final bytes in faces) {
    loader.addFont(Future.value(bytes.buffer.asByteData()));
  }
  await loader.load();
}

void main() {
  final missing = [
    for (final entry in _hostFaces.entries)
      for (final path in entry.value)
        if (!File(path).existsSync()) '${entry.key} ($path)',
  ];

  group('goldens', () {
    setUpAll(() async {
      for (final entry in _hostFaces.entries) {
        await _load(entry.key, [
          for (final path in entry.value) File(path).readAsBytesSync(),
        ]);
      }
      final icons = _packageRoot('fluentui_system_icons');
      for (final font in const ['Regular', 'Filled']) {
        final file = File(
          '${icons.path}/lib/fonts/FluentSystemIcons-$font.ttf',
        );
        if (!file.existsSync()) fail('missing icon font: ${file.path}');
        await _load(
          'packages/fluentui_system_icons/FluentSystemIcons-$font',
          [file.readAsBytesSync()],
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
      AppThemeName theme = AppThemeName.studioLight,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 1200);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        AppThemeProvider(
          theme: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: const ValueKey('golden'),
                child: Builder(
                  builder: (context) => Container(
                    width: width,
                    color: context.vars.colorSurface,
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

    testWidgets('limited functionality banner', (tester) async {
      await expectGolden(
        tester,
        'limited_functionality_banner',
        width: 396,
        // The mini window's tray behind it — the paper, which is what the
        // banner hangs on between the top bar and the panel — so the strip's
        // own gap to whatever sits below is visible in the image.
        Builder(
          builder: (context) => ColoredBox(
            color: context.vars.colorSurface,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: LimitedFunctionalityBanner(
                isAllowedScreenCaptureAccess: false,
                isAllowedScreenSelectionAccess: false,
                onTappedRecheckIsAllowedAllAccess: _noop,
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('translation blocks', (tester) async {
      await expectGolden(
        tester,
        'translation_blocks',
        width: 460,
        column([
          TextBlock(
            label: BlockHeading.of(role: '原文', details: const ['English']),
            meta: const Text('⌥⏎ 重译'),
            child: const Text('Attention is all you need.'),
          ),
          HighlightBlock(
            rule: HighlightRule.top,
            label: BlockHeading.of(role: '译文', details: const ['简体中文']),
            meta: const Text('2 处术语已对齐'),
            child: const Text('注意力就是你所需要的一切。'),
          ),
        ], gap: 0),
      );
    });

    // The shape 提供商 and 服务 actually draw: the kit's row, with the app's
    // own mark on the left and its controls on the right.
    testWidgets('list rows', (tester) async {
      await expectGolden(
        tester,
        'list_rows',
        width: 420,
        column([
          PreferenceRow(
            icon: const Avatar(label: 'C', color: Color(0xFFD97757)),
            title: 'Claude',
            subtitle: 'claude-sonnet-4-5 · 密钥有效',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Badge(child: Text('默认')),
                const SizedBox(width: 8),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),
          ),
          PreferenceRow(
            icon: const Avatar(label: 'D', color: Color(0xFF3A7BFD)),
            title: 'DeepL',
            subtitle: '密钥已过期',
            onPressed: () {},
          ),
        ]),
      );
    });

    testWidgets('language capsule and gauge', (tester) async {
      await expectGolden(
        tester,
        'capsule_and_gauge',
        column([
          SwapPair(
            start: 'English',
            end: '简体中文',
            onSwap: () {},
            onStartPressed: () {},
            onEndPressed: () {},
          ),
          const SegmentGauge(filled: 2, partial: true),
        ]),
      );
    });

    // The mini window's two surfaces, in the palette where they used to be
    // one: the tray is the paper and the panel is the card off it, and Bright
    // steps that card *up* to white where Studio steps it down. Rendered on
    // the tray colour rather than the page, since a card that matches its own
    // tray is exactly the failure.
    for (final (String name, AppThemeName theme) in const [
      ('mini_panel_on_tray', AppThemeName.studioLight),
      ('mini_panel_on_tray_bright', AppThemeName.brightLight),
    ]) {
      testWidgets('mini panel on its tray — $name', (tester) async {
        await expectGolden(
          tester,
          name,
          theme: theme,
          Builder(
            builder: (context) => ColoredBox(
              color: context.vars.colorSurface,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: PopoverPanel(
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('原文'),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }

    // 外观 › 主题风格: a closed menu of the palettes, in the same box as the
    // display language's beside it.
    testWidgets('theme family picker', (tester) async {
      await expectGolden(
        tester,
        'theme_picker',
        column([
          // Studio selected under Studio: picking a family repaints the
          // window, so the selection and the theme in force are never a
          // different family.
          ThemeFamilyPicker(
            value: DesignThemeFamily.studio,
            onChanged: (_) {},
          ),
        ]),
      );
    });

    testWidgets('theme family picker in the dark', (tester) async {
      await expectGolden(
        tester,
        'theme_picker_dark',
        theme: AppThemeName.studioDark,
        column([
          ThemeFamilyPicker(
            value: DesignThemeFamily.studio,
            onChanged: (_) {},
          ),
        ]),
      );
    });

    // The same capsule under Bright, whose `radiusSmall`/`radiusMedium` are
    // pills rather than corners. Everything inside the capsule has to round
    // with it; a fixed corner in there reads as a square button in a lozenge,
    // which is what this image is here to catch.
    testWidgets('language capsule under bright', (tester) async {
      await expectGolden(
        tester,
        'capsule_bright',
        theme: AppThemeName.brightLight,
        column([
          SwapPair(
            start: 'English',
            end: '简体中文',
            onSwap: () {},
            // An end paints its surface only while open or hovered, so one is
            // opened here — a resting capsule would hide the very corner this
            // image is watching.
            onStartPressed: () {},
            startOpen: true,
            onEndPressed: () {},
          ),
        ]),
      );
    });
  }, skip: missing.isEmpty ? false : 'host is missing ${missing.join(', ')}');
}

void _noop() {}
