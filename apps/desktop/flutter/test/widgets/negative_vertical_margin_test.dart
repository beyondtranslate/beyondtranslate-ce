import 'package:beyondtranslate_desktop/src/widgets/negative_vertical_margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A stand-in for the 重译 chip: 11px of text inside 6px of padding.
Widget chip() {
  return const NegativeVerticalMargin(
    shrink: 6,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SizedBox(width: 40, height: 11),
    ),
  );
}

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  // The bug: a `Row` hands non-flexible children an unbounded width, and the
  // `OverflowBox` this replaced answered that by sizing itself to
  // `constraints.biggest` — infinitely wide.
  testWidgets('takes only the width it needs beside a Spacer', (tester) async {
    await pump(
      tester,
      Center(
        child: SizedBox(
          width: 624,
          child: Row(children: [const Text('源文'), const Spacer(), chip()]),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(NegativeVerticalMargin)).width,
      40 + 8 * 2,
    );
  });

  testWidgets('claims the child height less the margin, top and bottom',
      (tester) async {
    await pump(tester, Center(child: chip()));

    // 6 + 11 + 6 of child, less 6 top and bottom.
    expect(
      tester.getSize(find.byType(NegativeVerticalMargin)),
      const Size(56, 11),
    );
  });

  testWidgets('paints the child centred on the space it claims',
      (tester) async {
    await pump(tester, Center(child: chip()));

    final box = tester.getRect(find.byType(NegativeVerticalMargin));
    final child = tester.getRect(find.byType(Padding));

    expect(child.top, box.top - 6);
    expect(child.bottom, box.bottom + 6);
  });

  // The workbench column measures itself with `IntrinsicHeight` before laying
  // out, so the row this sits in has to answer for it.
  testWidgets('reports the shortened height as its intrinsic height',
      (tester) async {
    await pump(
      tester,
      Center(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [chip()],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(IntrinsicHeight)).height, 11);
  });
}
