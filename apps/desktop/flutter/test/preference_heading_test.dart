// A settings heading with a control on its line.
//
// The kit's own `PreferenceSection(action: …)` cannot lay this out — its slot
// is an `OverflowBox` at `OverflowBoxFit.max`, and a `Row` hands a
// non-flexible child an unbounded main axis, so the slot takes an infinite
// width. The app draws the heading itself; these pin both halves of why.
import 'package:beyondtranslate_desktop/src/theme/app_theme.dart'
    show AppThemeProvider;
import 'package:beyondtranslate_desktop/src/widgets/preference_heading.dart'
    show PreferenceSectionWithAction;
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show Button, PreferenceRow, PreferenceSection, SectionLabel;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      AppThemeProvider(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 470, child: child),
          ),
        ),
      ),
    );
  }

  testWidgets('a heading with an action lays out', (tester) async {
    await pump(
      tester,
      PreferenceSectionWithAction(
        label: '可用服务',
        action: Button(onPressed: () {}, child: const Text('添加服务')),
        children: const [PreferenceRow(title: '一行')],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('添加服务'), findsOneWidget);
  });

  testWidgets('the action overhangs the line rather than setting its height', (
    tester,
  ) async {
    Future<double> headingBottom(Widget section) async {
      await pump(tester, section);
      return tester.getBottomLeft(find.byType(SectionLabel)).dy;
    }

    // The control is taller than the label it sits beside, and a heading that
    // grew for it would start its rows lower than a heading without one — two
    // sections on the same page would then not line up.
    final withAction = await headingBottom(
      PreferenceSectionWithAction(
        label: '可用服务',
        action: Button(onPressed: () {}, child: const Text('添加服务')),
        children: const [PreferenceRow(title: '一行')],
      ),
    );
    final without = await headingBottom(
      const PreferenceSection(
        label: '可用服务',
        children: [PreferenceRow(title: '一行')],
      ),
    );

    expect(withAction, without);
  });
}
