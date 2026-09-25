// 主题风格 —— the palette is chosen apart from the light/dark pair, so the two
// have to stay independent: switching one must not disturb the other.
import 'package:beyondtranslate_desktop/src/theme/app_theme.dart';
import 'package:beyondtranslate_desktop/src/theme/product_tokens.dart'
    show ProductPalette;
import 'package:beyondtranslate_desktop/src/widgets/theme_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    DesignThemeFamily value,
    ValueChanged<DesignThemeFamily> onChanged, {
    AppThemeName theme = AppThemeName.brightLight,
  }) {
    return tester.pumpWidget(
      // A hover label needs an Overlay overhead, which the shell gives it.
      appHarness(
        Center(child: ThemeFamilyPicker(value: value, onChanged: onChanged)),
        theme: theme,
      ),
    );
  }

  testWidgets('shows the family it is set to', (tester) async {
    await pump(tester, DesignThemeFamily.omarchyRosePine, (_) {});

    expect(find.text(DesignThemeFamily.omarchyRosePine.label), findsOneWidget);
  });

  test('offers every family once, a separator opening each group', () {
    final items = ThemeFamilyPicker.items;

    expect([for (final item in items) item.value], DesignThemeFamily.values);
    expect(
      [
        for (final item in items)
          if (item.separatorBefore) item.value,
      ],
      [DesignThemeFamily.macos27, DesignThemeFamily.omarchyTokyoNight],
    );
  });

  test('a family and a brightness pick exactly one palette', () {
    for (final family in DesignThemeFamily.values) {
      for (final brightness in Brightness.values) {
        final name = family.themeFor(brightness);
        expect(name.family, family);
        expect(name.brightness, brightness);
        // And the kit has a token set for it.
        expect(designThemeFor(name).brightness, brightness);
      }
    }
  });

  // The imported themes are derived from a few colours rather than drawn, so
  // nothing but this says the product's palette still finds every ramp step
  // it reads under them.
  test('the product palette resolves under every palette', () {
    for (final name in AppThemeName.values) {
      final vars = designThemeFor(name).vars;
      expect(
        () => [
          vars.accent,
          vars.accentHover,
          vars.accentText,
          vars.accentTextStrong,
          vars.highlight,
          vars.accentMarkFg,
          vars.danger,
          vars.dangerFg,
          vars.dangerDeep,
          vars.warnStrong,
          vars.warnFg,
          vars.success,
          vars.successFg,
        ],
        returnsNormally,
        reason: name.name,
      );
    }
  });

  test('an id that is no longer a family falls back rather than throwing', () {
    expect(DesignThemeFamily.fromId('studio'), DesignThemeFamily.studio);
    expect(DesignThemeFamily.fromId('ember'), DesignThemeFamily.ember);
    expect(DesignThemeFamily.fromId('omarchy-rose-pine'),
        DesignThemeFamily.omarchyRosePine);
    expect(DesignThemeFamily.fromId('nope'), DesignThemeFamily.bright);
  });
}
