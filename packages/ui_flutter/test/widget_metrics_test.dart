import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The fixed geometry the React kit pins with Tailwind height utilities. These
/// are the metrics a font's own line box would otherwise drift off, so they are
/// asserted rather than left to look right.
void main() {
  Widget specimen(Widget child) => DesignThemeProvider(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(alignment: Alignment.topLeft, child: child),
        ),
      );

  Future<Size> sizeOf(WidgetTester tester, Widget child, Type type) async {
    await tester.pumpWidget(specimen(child));
    // Controls are AnimatedContainers, so a specimen swapped into the same
    // element starts at the previous geometry and eases to the new one.
    await tester.pumpAndSettle();
    return tester.getSize(find.byType(type));
  }

  testWidgets('Button keeps the 24 / 26 / 28 / 32 control range', (
    tester,
  ) async {
    for (final (size, height) in const [
      (ButtonSize.xs, 24.0),
      (ButtonSize.sm, 26.0),
      (ButtonSize.md, 28.0),
      (ButtonSize.lg, 32.0),
    ]) {
      final box = await sizeOf(
        tester,
        Button(size: size, onPressed: () {}, child: const Text('翻译')),
        Button,
      );
      expect(box.height, height, reason: '$size');
    }
  });

  testWidgets('a text-only Button keeps its height and drops its box', (
    tester,
  ) async {
    final box = await sizeOf(
      tester,
      Button(
        variant: ButtonVariant.quiet,
        onPressed: () {},
        child: const Text('设为首选'),
      ),
      Button,
    );
    expect(box.height, 26);
  });

  testWidgets('Input and SearchField sit on the md-Button line', (
    tester,
  ) async {
    final input = await sizeOf(
      tester,
      const SizedBox(width: 240, child: Input(placeholder: 'sk-…')),
      Input,
    );
    expect(input.height, 28);

    final search = await sizeOf(
      tester,
      SizedBox(
        width: 240,
        child: SearchField(value: '', onChanged: (_) {}),
      ),
      SearchField,
    );
    expect(search.height, 28);
  });

  testWidgets('Switch draws the AppKit small switch', (tester) async {
    expect(
      await sizeOf(tester, const Switch(checked: true), Switch),
      const Size(32, 18),
    );
    expect(
      await sizeOf(
        tester,
        const Switch(checked: false, size: SwitchSize.sm),
        Switch,
      ),
      const Size(28, 16),
    );
  });

  testWidgets('a segmented track is 28px over its 22px segments', (
    tester,
  ) async {
    final box = await sizeOf(
      tester,
      SegmentedControl<String>(
        value: 'light',
        onChanged: (_) {},
        items: const [
          SegmentedItem(value: 'light', label: Text('浅色')),
          SegmentedItem(value: 'dark', label: Text('深色')),
        ],
      ),
      SegmentedControl<String>,
    );
    // 22px segment + the track's 3px inset on both edges.
    expect(box.height, 28);
  });

  testWidgets('a boxed Kbd and a filter pill keep their fixed boxes', (
    tester,
  ) async {
    final key = await sizeOf(
      tester,
      const Kbd('⌘F', variant: KbdVariant.key),
      Kbd,
    );
    expect(key.height, 22);

    final pills = await sizeOf(
      tester,
      Tabs<String>(
        value: 'all',
        onChanged: (_) {},
        items: const [
          TabItem(value: 'all', label: Text('全部历史')),
          TabItem(value: 'starred', label: Text('收藏'), count: 64),
        ],
      ),
      Tabs<String>,
    );
    expect(pills.height, 24);
  });

  testWidgets('a NavItem row stays at 28px, with or without a glyph', (
    tester,
  ) async {
    final plain = await sizeOf(
      tester,
      const SizedBox(width: 152, child: NavItem(child: Text('翻译'))),
      NavItem,
    );
    expect(plain.height, 28);

    final withIcon = await sizeOf(
      tester,
      const SizedBox(
        width: 152,
        child: NavItem(icon: Icon(IconData(0xe000)), child: Text('翻译')),
      ),
      NavItem,
    );
    expect(withIcon.height, 28);
  });

  testWidgets('a sidebar group spaces its label like another row', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        SizedBox(
          height: 400,
          child: Sidebar(
            children: [
              SidebarGroup(
                first: true,
                label: const Text('工作区'),
                children: [
                  NavItem(
                      active: true, onPressed: () {}, child: const Text('翻译')),
                  NavItem(onPressed: () {}, child: const Text('文档翻译')),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final label = tester.getRect(find.text('工作区'));
    final rows = tester.widgetList<NavItem>(find.byType(NavItem)).length;
    expect(rows, 2);

    final first = tester.getRect(find.byType(NavItem).first);
    final second = tester.getRect(find.byType(NavItem).last);

    // `pb-1` under the label, then the group's own 3px gap.
    expect(first.top - label.bottom, 4 + 3);
    // …the same 3px that separates one row from the next.
    expect(second.top - first.bottom, 3);
    // `px-2.5` on the label lines it up with the rows' 11px text inset.
    expect(label.left - tester.getRect(find.byType(SidebarGroup)).left, 10);
  });

  testWidgets('a Rail pins its trailing action and its footer to the foot', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        SizedBox(
          height: 300,
          child: Rail(
            footer: const Text('已完成'),
            children: [
              RailItem(onPressed: () {}, child: const Text('通用')),
              RailAction(onPressed: () {}, child: const Text('＋ 新建术语库')),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(Rail)).width, 150);
    // The footer keeps the column's 14px bottom inset…
    expect(tester.getBottomLeft(find.text('已完成')).dy, 286);
    // …and `mt-auto` pushes the action down to sit just above it.
    expect(
      tester.getBottomLeft(find.byType(RailAction)).dy,
      greaterThan(200),
    );
  });
}
