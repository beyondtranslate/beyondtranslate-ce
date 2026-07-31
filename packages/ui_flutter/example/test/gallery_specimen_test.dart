@Tags(['specimen'])
library;

import 'dart:io';
import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:beyondtranslate_ui_example/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The type roles bound to the real macOS faces. `flutter test` ships a
/// placeholder font that draws every glyph as a box, which would make the
/// specimens useless.
const DesignTypography _hostFonts = DesignTypography(
  display: DesignFont(family: 'SF', fallback: ['PingFang SC', 'Symbols']),
  sans: DesignFont(family: 'SF', fallback: ['PingFang SC', 'Symbols']),
  label: DesignFont(family: 'SF', fallback: ['PingFang SC', 'Symbols']),
  cjk: DesignFont(family: 'PingFang SC', fallback: ['SF', 'Symbols']),
  mono: DesignFont(family: 'SF Mono', fallback: ['PingFang SC', 'Symbols']),
);

/// Renders the gallery under each theme into `test/specimens/<theme>.png`.
///
/// This is a visual specimen, not an assertion: run
/// `flutter test --update-goldens --tags specimen` to refresh the images, then
/// look at them beside the Storybook stories. It is tagged so a normal
/// `flutter test` run skips it — the images depend on which faces the host has
/// installed, which is not something CI should gate on.
void main() {
  setUpAll(() async {
    await _loadFont('SF', '/System/Library/Fonts/SFNS.ttf');
    await _loadFont('PingFang SC', '/System/Library/Fonts/STHeiti Medium.ttc');
    await _loadFont('SF Mono', '/System/Library/Fonts/Menlo.ttc');
    // ⌕ ⇄ ✕ ✓ sit outside SF's own coverage; macOS resolves them through
    // Apple Symbols, which the test environment has to be told about. It goes
    // in as its own family and is reached through the fallback lists below,
    // so it never outranks the CJK face.
    await _loadFont('Symbols', '/System/Library/Fonts/Apple Symbols.ttf');
  });

  for (final theme in DesignThemeName.values) {
    testWidgets('specimen · ${theme.id}', (tester) async {
      tester.view.physicalSize = const Size(2560, 10000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(devicePixelRatio: 2),
            child: Gallery(initialTheme: theme, typography: _hostFonts),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(Gallery),
        matchesGoldenFile('specimens/${theme.id}.png'),
      );
    });
  }
}

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final loader = FontLoader(family)
    ..addFont(
      file.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
    );
  await loader.load();
}
