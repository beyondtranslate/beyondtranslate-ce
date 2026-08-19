import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The divider's contract, as the React `Sidebar` states it: it walks between
/// a floor and a ceiling, collapses rather than shrinking past the floor, and
/// goes home on a double-click.
void main() {
  Widget specimen(Widget child) => DesignThemeProvider(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(height: 400, child: child),
          ),
        ),
      );

  Future<void> dragBy(WidgetTester tester, double dx) async {
    // Grab the handle at its own centre — it sits inside the sidebar's right
    // edge, which is what makes it hit-testable at all.
    final handle = tester.getRect(find.byType(MouseRegion).last);
    final gesture = await tester.startGesture(handle.center);
    // The recogniser needs to see the slop cleared before it claims the
    // gesture; `DragStartBehavior.down` means none of it is lost.
    await gesture.moveBy(Offset(dx.sign * kDragSlopDefault, 0));
    await gesture.moveBy(Offset(dx - dx.sign * kDragSlopDefault, 0));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  testWidgets('the divider walks between the floor and the ceiling', (
    tester,
  ) async {
    double? width;
    await tester.pumpWidget(
      specimen(
        Sidebar(
          resizable: true,
          onWidthChange: (value) => width = value,
          children: const [NavItem(child: Text('翻译'))],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Starts on the token's own width.
    expect(tester.getSize(find.byType(Sidebar)).width, 172);

    await dragBy(tester, 60);
    expect(width, 232);
    expect(tester.getSize(find.byType(Sidebar)).width, 232);

    // The ceiling holds.
    await dragBy(tester, 400);
    expect(width, kMaxSidebarWidth);

    // …and so does the floor, when collapsing is not on offer.
    await dragBy(tester, -400);
    expect(width, kMinSidebarWidth);
  });

  testWidgets('dragging well past the floor collapses instead of shrinking', (
    tester,
  ) async {
    var collapsed = 0;
    double? width;
    await tester.pumpWidget(
      specimen(
        Sidebar(
          resizable: true,
          onWidthChange: (value) => width = value,
          onCollapse: () => collapsed++,
          children: const [NavItem(child: Text('翻译'))],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 172 → past 150 − 32 = 118.
    await dragBy(tester, -80);
    expect(collapsed, 1);
    // The width handed back is the one the drag began from, not a
    // half-dragged number re-opening would inherit.
    expect(width, 172);
  });

  testWidgets('double-clicking the divider puts it back where it started', (
    tester,
  ) async {
    double? width;
    await tester.pumpWidget(
      specimen(
        Sidebar(
          resizable: true,
          onWidthChange: (value) => width = value,
          children: const [NavItem(child: Text('翻译'))],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await dragBy(tester, 90);
    expect(width, 262);

    final handle = tester.getRect(find.byType(MouseRegion).last);
    await tester.tapAt(handle.center);
    await tester.pump(kDoubleTapMinTime);
    await tester.tapAt(handle.center);
    await tester.pumpAndSettle();
    expect(width, 172);
  });

  testWidgets('the rail walks between its own floor and ceiling', (
    tester,
  ) async {
    double? width;
    await tester.pumpWidget(
      specimen(
        Rail(
          resizable: true,
          onWidthChange: (value) => width = value,
          children: const [RailItem(child: Text('常规'))],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Starts on the rail metric.
    expect(tester.getSize(find.byType(Rail)).width, 150);

    await dragBy(tester, 50);
    expect(width, 200);
    expect(tester.getSize(find.byType(Rail)).width, 200);

    await dragBy(tester, 400);
    expect(width, kMaxRailWidth);

    // No collapse on offer: the floor is where the drag stops.
    await dragBy(tester, -400);
    expect(width, kMinRailWidth);
    expect(tester.getSize(find.byType(Rail)).width, kMinRailWidth);
  });

  testWidgets('a rail that is not resizable draws no handle', (tester) async {
    await tester.pumpWidget(
      specimen(const Rail(children: [RailItem(child: Text('常规'))])),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Rail)).width, 150);
    expect(find.bySemanticsLabel('调整栏宽度'), findsNothing);
  });

  testWidgets('a sidebar that is not resizable draws no handle', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(const Sidebar(children: [NavItem(child: Text('翻译'))])),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Sidebar)).width, 172);
    expect(find.bySemanticsLabel('调整侧边栏宽度'), findsNothing);
  });
}
