import 'package:beyondtranslate_desktop/src/routes/mini_translator/limited_functionality_banner.dart';
import 'package:beyondtranslate_desktop/src/theme/app_theme.dart'
    show AppThemeProvider;
import 'package:beyondtranslate_desktop/src/widgets/blocks.dart';
import 'package:beyondtranslate_desktop/src/widgets/icon_action_button.dart';
import 'package:beyondtranslate_desktop/src/widgets/language_selector.dart';
import 'package:beyondtranslate_desktop/src/widgets/nav_columns.dart'
    show Sidebar;
import 'package:beyondtranslate_desktop/src/widgets/navigation_item.dart';
import 'package:beyondtranslate_desktop/src/widgets/swap_pair.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show Aside, Callout, NavItem, SidebarCard;
import 'package:beyondtranslate_desktop/src/widgets/workbench.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget specimen(Widget child) {
    return AppThemeProvider(
      child: MaterialApp(
        home: Scaffold(body: SizedBox(width: 840, height: 560, child: child)),
      ),
    );
  }

  testWidgets('workbench supplies WindowBody with a Flex parent', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        const Workbench(
          sidebar: [
            NavigationItem(
              label: '翻译',
              icon: FluentIcons.translate_20_regular,
              selected: true,
            ),
          ],
          child: SizedBox.expand(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(Sidebar)).width, 172);
  });

  testWidgets('toolbar icon adapter keeps the 24 point widget metric', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        Center(
          child: IconActionButton(
            icon: Icons.more_horiz,
            tooltip: '更多',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(IconActionButton)), const Size(24, 24));
  });

  testWidgets('workspace navigation carries the deck\'s leading glyph', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 172,
            child: NavigationItem(
              label: '历史',
              icon: FluentIcons.history_20_regular,
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(FluentIcons.history_20_regular), findsOneWidget);
    expect(find.text('历史'), findsOneWidget);
    // px-[11px] py-2 over a 12px line: the row stays at 28.
    expect(tester.getSize(find.byType(NavItem)).height, 28);
  });

  testWidgets('language selector matches the 30 point LanguagePair capsule', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        Center(
          child: LanguageSelector(
            sourceLanguage: 'en',
            targetLanguage: 'zh-Hans',
            commonLanguageCodes: const [],
            onSourceChanged: (_) {},
            onTargetChanged: (_) {},
            onManageCommonLanguages: () {},
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(LanguageSelector)).height, 30);
    // Both ends are menu triggers, so both carry a disclosure chevron.
    expect(find.byIcon(FluentIcons.chevron_down_20_regular), findsNWidgets(2));
    expect(find.byIcon(FluentIcons.arrow_swap_20_regular), findsOneWidget);
  });

  testWidgets('aside stacks its cards from the top', (tester) async {
    await tester.pumpWidget(
      specimen(
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 300,
            child: Aside(
              children: [
                SizedBox(height: 20),
                SidebarCard(children: [Text('快捷键')]),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // The kit's aside is a scrolling column: cards take their own height and
    // stack from the top, rather than the last one stretching to the foot.
    // 16 of padding, the 20 spacer, then the column's own 20 gap.
    expect(tester.getTopLeft(find.byType(SidebarCard)).dy, 56);
    expect(
      tester.getBottomRight(find.byType(SidebarCard)).dy,
      lessThan(300),
    );
  });

  testWidgets('the highlight rule fences the block on the requested edge', (
    tester,
  ) async {
    Border borderOf() {
      final decoration = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(HighlightBlock),
              matching: find.byType(Container),
            ),
          )
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((decoration) => decoration.border != null);
      return decoration.border! as Border;
    }

    for (final (rule, top, bottom) in const [
      (HighlightRule.top, true, false),
      (HighlightRule.bottom, false, true),
    ]) {
      await tester.pumpWidget(
        specimen(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              child: HighlightBlock(
                rule: rule,
                label: const Text('内置模型 · 首选译文'),
                child: const Text('注意力就是你所需要的一切。'),
              ),
            ),
          ),
        ),
      );

      final border = borderOf();
      // 2px in every theme, and only on the edge the block was asked for.
      expect(border.top.width, top ? 2 : 0, reason: '$rule top');
      expect(border.bottom.width, bottom ? 2 : 0, reason: '$rule bottom');
    }
  });

  testWidgets('the language capsule is 30px tall at both ends', (tester) async {
    await tester.pumpWidget(
      specimen(
        const Center(
          child: SwapPair(start: 'English', end: '简体中文'),
        ),
      ),
    );
    // The capsule is an AnimatedContainer, so let it reach its resting size.
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(SwapPair)).height, 30);

    await tester.pumpWidget(
      specimen(
        Center(
          child: SwapPair(
            start: 'English',
            end: '简体中文',
            onStartPressed: () {},
            onEndPressed: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(SwapPair)).height, 30);
  });

  /// 功能受限 hangs between the mini window's top bar and its panel, and the
  /// gap to the panel is the strip's own — React carries it as `mb-2` on the
  /// Callout, so the banner brings its own breathing room wherever it is hung.
  /// Flutter had no such margin at all and the notice sat flush against the
  /// panel below it.
  testWidgets('the 功能受限 banner reserves the deck\'s gap below itself', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 396,
            child: LimitedFunctionalityBanner(
              isAllowedScreenCaptureAccess: false,
              isAllowedScreenSelectionAccess: false,
              onTappedRecheckIsAllowedAllAccess: _noop,
            ),
          ),
        ),
      ),
    );

    final banner = tester.getRect(find.byType(LimitedFunctionalityBanner));
    final callout = tester.getRect(find.byType(Callout));
    // 8px of the banner's height is below the tinted box, and none above it:
    // the strip pushes the panel down, it does not float away from the bar.
    expect(banner.bottom - callout.bottom, 8);
    expect(callout.top - banner.top, 0);

    // The kit's small density — tighter than the medium 16/12, which is a lot
    // of air at 396px.
    final box = tester.widget<Container>(
      find
          .descendant(
              of: find.byType(Callout), matching: find.byType(Container))
          .first,
    );
    expect(
      box.padding,
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  });
}

void _noop() {}
