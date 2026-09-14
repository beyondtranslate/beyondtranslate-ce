import 'package:beyondtranslate_desktop/src/theme/app_theme.dart'
    show AppThemeName, designThemeFor;
import 'package:beyondtranslate_desktop/src/theme/product_tokens.dart'
    show ProductPalette;
import 'package:beyondtranslate_desktop/src/widgets/nav_columns.dart'
    show Rail, RailItem, Sidebar, SidebarItem;
import 'package:beyondtranslate_desktop/src/widgets/window_focus.dart'
    show WindowFocus;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  Widget columns(
      {bool? focused, AppThemeName theme = AppThemeName.studioLight}) {
    final Widget body = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Sidebar(
          children: [
            SidebarItem(
              label: '翻译',
              icon: FluentIcons.translate_20_regular,
              current: true,
              onPressed: () {},
            ),
            SidebarItem(
              label: '历史',
              icon: FluentIcons.history_20_regular,
              onPressed: () {},
            ),
          ],
        ),
        Rail(
          children: [
            RailItem(active: true, onPressed: () {}, child: const Text('通用')),
          ],
        ),
      ],
    );
    return appHarness(
      focused == null ? body : WindowFocus(focused: focused, child: body),
      size: const Size(480, 320),
      theme: theme,
    );
  }

  Color? fillOf(WidgetTester tester, Type row) {
    final container = tester.widget<AnimatedContainer>(
      find
          .descendant(
            of: find.byType(row),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    return (container.decoration as BoxDecoration?)?.color;
  }

  testWidgets('a key window fills the current rows with the accent', (
    tester,
  ) async {
    final vars = designThemeFor(AppThemeName.studioLight).vars;
    await tester.pumpWidget(columns(focused: true));

    expect(fillOf(tester, SidebarItem), vars.accent);
    expect(fillOf(tester, RailItem), vars.accent);
  });

  testWidgets('no scope reads as a key window', (tester) async {
    final vars = designThemeFor(AppThemeName.studioLight).vars;
    await tester.pumpWidget(columns());

    expect(fillOf(tester, SidebarItem), vars.accent);
  });

  for (final theme in [
    AppThemeName.studioLight,
    AppThemeName.studioDark,
    AppThemeName.brightLight,
    AppThemeName.frostDark,
  ]) {
    testWidgets('a blurred window drops the accent (${theme.name})', (
      tester,
    ) async {
      final vars = designThemeFor(theme).vars;
      await tester.pumpWidget(columns(focused: false, theme: theme));
      await tester.pumpAndSettle();

      for (final row in [SidebarItem, RailItem]) {
        final fill = fillOf(tester, row);
        expect(fill, isNot(vars.accent));
        expect(fill, vars.selectionUnemphasized);
      }
      final label = tester.widget<Text>(
        find.descendant(
            of: find.byType(SidebarItem), matching: find.text('翻译')),
      );
      expect(label.style?.color, vars.colorContent);
    });
  }

  test('the unemphasized fills are the React themes\' values', () {
    Color of(AppThemeName name) =>
        designThemeFor(name).vars.selectionUnemphasized;

    expect(
        of(AppThemeName.studioLight), const Color.fromRGBO(20, 22, 40, 0.09));
    expect(
        of(AppThemeName.studioDark), const Color.fromRGBO(255, 255, 255, 0.13));
    final bright = designThemeFor(AppThemeName.brightLight).vars;
    expect(of(AppThemeName.brightLight),
        bright.colorContent.withValues(alpha: 0.10));
    final frost = designThemeFor(AppThemeName.frostLight).vars;
    expect(of(AppThemeName.frostLight), frost.colorSurfaceSubtle);
  });
}
