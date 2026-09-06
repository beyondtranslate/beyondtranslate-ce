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
    show AppThemeProvider, AppThemeName;
import 'package:beyondtranslate_desktop/src/widgets/avatar.dart';
import 'package:beyondtranslate_desktop/src/widgets/block_heading.dart';
import 'package:beyondtranslate_desktop/src/widgets/blocks.dart';
import 'package:beyondtranslate_desktop/src/widgets/data_display.dart';
import 'package:beyondtranslate_desktop/src/widgets/list_tile.dart';
import 'package:beyondtranslate_desktop/src/widgets/swap_pair.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show Badge, Switch, ThemeDataBuildContextProps;
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

/// The host faces, registered under the names the kit's type recipes name.
///
/// `flutter test` resolves nothing on its own: a family the recipes ask for
/// and the test never registered comes out as tofu. ⌕ ⇄ ✕ ✓ sit outside SF's
/// own coverage and macOS resolves them through Apple Symbols, so it is loaded
/// *into* each family rather than beside it — a family's later fonts are its
/// own fallbacks, which is the only way in when the recipe's
/// `fontFamilyFallback` is the kit's and not the test's to extend.
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
        // The mini window's tray colour behind it, so the strip's own gap to
        // whatever sits below is visible in the image.
        Builder(
          builder: (context) => ColoredBox(
            color: context.vars.colorSurfaceMuted,
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

    testWidgets('list rows', (tester) async {
      await expectGolden(
        tester,
        'list_rows',
        width: 420,
        column([
          ListTile(
            leading: const Avatar(label: 'C', color: Color(0xFFD97757)),
            title: const Text('Claude'),
            meta: const Text('claude-sonnet-4-5 · 密钥有效'),
            badge: const Badge(child: Text('默认')),
            trailing: [Switch(value: true, onChanged: (_) {})],
          ),
          ListTile(
            variant: ListTileVariant.row,
            tone: ListTileTone.warn,
            leading: const Avatar(label: 'D', color: Color(0xFF3A7BFD)),
            title: const Text('DeepL'),
            meta: const Text('密钥已过期'),
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
  }, skip: missing.isEmpty ? false : 'host is missing ${missing.join(', ')}');
}

void _noop() {}
