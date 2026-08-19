// 提交方式 — which key sends an input box. The setting is a runtime one, but
// what it *does* is here: the field only takes Enter into its own hands once
// it has been told which key submits, and ⇧⏎ stays a newline either way.
//
// macOS runs an AppKit field instead, where the same rules live in
// `macos/Runner/Plugins/NativeTextFieldPlugin.swift`; these tests drive the
// Flutter path, so they pin the platform away from it.
import 'package:beyondtranslate_desktop/src/widgets/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// [testWidgets], with the target platform pinned off macOS for the length
  /// of the body — the framework checks the override is back to null before
  /// the test ends, so it cannot be undone from `tearDown`.
  void testOnLinux(String description, WidgetTesterCallback body) {
    testWidgets(description, (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      try {
        await body(tester);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  }

  /// Mounts a multiline field in the given mode and reports every submit it
  /// makes, in order.
  Future<List<String>> pump(
    WidgetTester tester, {
    required bool submitOnEnter,
    required bool submitOnMetaEnter,
  }) async {
    final submitted = <String>[];
    final controller = TextEditingController(text: 'hello');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 8,
          submitOnEnter: submitOnEnter,
          submitOnMetaEnter: submitOnMetaEnter,
          onSubmitted: submitted.add,
        ),
      ),
    );
    await tester.pump();
    return submitted;
  }

  Future<void> press(
    WidgetTester tester, {
    LogicalKeyboardKey? modifier,
    LogicalKeyboardKey key = LogicalKeyboardKey.enter,
  }) async {
    if (modifier != null) await tester.sendKeyDownEvent(modifier);
    await tester.sendKeyEvent(key);
    if (modifier != null) await tester.sendKeyUpEvent(modifier);
    await tester.pump();
  }

  testOnLinux('按 Enter 提交: ⏎ sends, ⇧⏎ writes a newline', (tester) async {
    final submitted = await pump(
      tester,
      submitOnEnter: true,
      submitOnMetaEnter: false,
    );

    await press(tester, modifier: LogicalKeyboardKey.shiftLeft);
    expect(submitted, isEmpty);

    await press(tester);
    expect(submitted, ['hello']);
  });

  testOnLinux('按 ⌘ + Enter 提交: a bare ⏎ writes a newline', (tester) async {
    final submitted = await pump(
      tester,
      submitOnEnter: false,
      submitOnMetaEnter: true,
    );

    await press(tester);
    expect(submitted, isEmpty);

    await press(tester, modifier: LogicalKeyboardKey.metaLeft);
    expect(submitted, ['hello']);

    // Ctrl sits where ⌘ does on the keyboards this path runs on.
    await press(tester, modifier: LogicalKeyboardKey.controlLeft);
    expect(submitted, ['hello', 'hello']);
  });

  testOnLinux('a field with no submit mode keeps Enter to itself',
      (tester) async {
    final submitted = await pump(
      tester,
      submitOnEnter: false,
      submitOnMetaEnter: false,
    );

    await press(tester);
    await press(tester, modifier: LogicalKeyboardKey.metaLeft);
    expect(submitted, isEmpty);
  });
}
