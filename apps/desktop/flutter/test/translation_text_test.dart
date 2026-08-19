// 译文 — which widget draws it. On macOS the string goes to AppKit through
// `NativeText`, so the whole native text menu (拷贝, 查询, 朗读, 共享) comes with
// it; everywhere else it stays on Flutter's `SelectableText`.
//
// AppKit owns the mouse over a platform view, so 双击复制 cannot ride on a
// surrounding `GestureDetector` — the callback lives on the widget, and both
// paths have to honour it.
import 'package:beyondtranslate_desktop/src/widgets/native_text.dart';
import 'package:beyondtranslate_desktop/src/widgets/translation_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// [testWidgets] with the target platform pinned for the length of the body —
  /// the framework checks the override is back to null before the test ends, so
  /// it cannot be undone from `tearDown`.
  void testOn(
    TargetPlatform platform,
    String description,
    WidgetTesterCallback body,
  ) {
    testWidgets(description, (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      try {
        await body(tester);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  }

  Future<void> pump(
    WidgetTester tester,
    Widget child,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    );
  }

  testOn(TargetPlatform.linux, 'off macOS the text stays a Flutter widget',
      (tester) async {
    await pump(
      tester,
      const TranslationText('注意力就是你所需要的一切。'),
    );

    expect(find.byType(NativeText), findsNothing);
    expect(
      tester.widget<SelectableText>(find.byType(SelectableText)).data,
      '注意力就是你所需要的一切。',
    );
  });

  testOn(TargetPlatform.linux, '双击复制 reaches the callback off macOS',
      (tester) async {
    var doubleTaps = 0;
    await pump(
      tester,
      SizedBox(
        width: 300,
        child: TranslationText(
          '注意力就是你所需要的一切。',
          onDoubleTap: () => doubleTaps++,
        ),
      ),
    );

    await tester.tap(find.byType(TranslationText));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(TranslationText));
    await tester.pumpAndSettle();

    expect(doubleTaps, 1);
  });

  testOn(TargetPlatform.macOS, 'on macOS the text is handed to AppKit',
      (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 300,
        child: TranslationText('注意力就是你所需要的一切。'),
      ),
    );

    expect(find.byType(SelectableText), findsNothing);
    expect(
      tester.widget<NativeText>(find.byType(NativeText)).text,
      '注意力就是你所需要的一切。',
    );
  });

  // The workbench stacks 原文 / 译文 / 释义 inside an `IntrinsicHeight`, which
  // asks the box how tall it wants to be before laying it out. A `LayoutBuilder`
  // cannot answer that, so the platform view is sized by a layout delegate.
  testOn(TargetPlatform.macOS, 'the box answers an intrinsic height query',
      (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 300,
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [TranslationText('注意力就是你所需要的一切。')],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testOn(TargetPlatform.macOS, 'the box is the text plus its padding',
      (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 300,
        child: TranslationText(
          'hello',
          // The test font draws every line exactly `fontSize * height` tall.
          style: TextStyle(fontSize: 10, height: 2),
          padding: EdgeInsets.symmetric(vertical: 5),
        ),
      ),
    );

    expect(tester.getSize(find.byType(NativeText)), const Size(300, 30));
  });

  testOn(TargetPlatform.linux, 'the platform view draws nothing off macOS',
      (tester) async {
    await pump(
      tester,
      const SizedBox(width: 300, child: NativeText(text: 'hello')),
    );

    // The parent still forces its width; what matters is that nothing is drawn.
    expect(tester.getSize(find.byType(NativeText)).height, 0);
  });
}
