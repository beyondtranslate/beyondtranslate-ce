import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Windows/Linux window chrome, as the React `window-controls` and
/// `WindowTitlebar` state it: the platform swaps the control cluster, the
/// cluster answers presses, and the brand mark's path parses and paints.
void main() {
  Widget specimen(Widget child) => DesignThemeProvider(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: child),
        ),
      );

  testWidgets('the Windows cluster carries three 46px strips', (tester) async {
    await tester.pumpWidget(
      specimen(
        SizedBox(
          height: 52,
          child: WindowsCaptionControls(onPressed: (_) {}),
        ),
      ),
    );

    final cluster = find.byType(WindowsCaptionControls);
    expect(tester.getSize(cluster).width, 46.0 * 3);
    // The strips stretch to the band they sit in.
    expect(tester.getSize(cluster).height, 52);
  });

  testWidgets('caption presses name their button', (tester) async {
    final pressed = <CaptionButton>[];
    await tester.pumpWidget(
      specimen(
        SizedBox(
          height: 52,
          child: WindowsCaptionControls(onPressed: pressed.add),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('最小化'));
    await tester.tap(find.bySemanticsLabel('关闭'));
    expect(pressed, [CaptionButton.minimize, CaptionButton.close]);
  });

  testWidgets('the titlebar swaps its cluster with the platform', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(
        SizedBox(
          width: 600,
          child: WindowTitlebar(
            platform: WindowPlatform.windows,
            title: const Text('翻译'),
          ),
        ),
      ),
    );
    expect(find.byType(TrafficLights), findsNothing);
    expect(find.byType(WindowsCaptionControls), findsOneWidget);

    // The strips run flush to the window's edge — the band's own padding is
    // cancelled on that side.
    final band = tester.getRect(find.byType(WindowTitlebar));
    final cluster = tester.getRect(find.byType(WindowsCaptionControls));
    expect(cluster.right, band.right);

    await tester.pumpWidget(
      specimen(
        SizedBox(
          width: 600,
          child: WindowTitlebar(
            platform: WindowPlatform.linux,
            buttons: const [CaptionButton.close],
            title: const Text('翻译'),
          ),
        ),
      ),
    );
    expect(find.byType(LinuxWindowControls), findsOneWidget);
    expect(find.bySemanticsLabel('关闭'), findsOneWidget);
    expect(find.bySemanticsLabel('最小化'), findsNothing);

    // macOS keeps the lights and draws no cluster.
    await tester.pumpWidget(
      specimen(
        SizedBox(width: 600, child: WindowTitlebar(title: const Text('翻译'))),
      ),
    );
    expect(find.byType(TrafficLights), findsOneWidget);
    expect(find.byType(WindowsCaptionControls), findsNothing);
    expect(find.byType(LinuxWindowControls), findsNothing);
  });

  testWidgets('the brand mark parses its path and paints', (tester) async {
    await tester.pumpWidget(specimen(const BrandLogo(size: 20)));
    expect(tester.getSize(find.byType(BrandLogo)), const Size(20, 20));
    // The glyph sits at 68% of the tile.
    expect(
      tester.getSize(find.byType(BrandGlyph)),
      const Size(20 * 0.68, 20 * 0.68),
    );
    expect(tester.takeException(), isNull);
  });
}
