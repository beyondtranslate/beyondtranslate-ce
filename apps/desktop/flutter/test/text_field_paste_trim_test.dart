// 粘贴自动 trim — text copied out of a web page or a PDF carries the edges of
// the selection with it, and a translation input never wants them.
//
// macOS runs an AppKit field instead, where the same rule lives in
// `macos/Runner/Plugins/NativeTextFieldPlugin.swift`; these tests drive the
// Flutter path, so they pin the platform away from it.
import 'package:beyondtranslate_desktop/src/widgets/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter/services.dart';
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

  void putOnClipboard(String? text) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method != 'Clipboard.getData') return null;
      return text == null ? null : <String, Object?>{'text': text};
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });
  }

  /// Mounts a focused multiline field. `MaterialApp` is what carries
  /// `DefaultTextEditingShortcuts`, which is what turns ⌃V into a paste.
  Future<TextEditingController> pump(
      WidgetTester tester, String initial) async {
    final controller = TextEditingController(text: initial);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(
            controller: controller,
            autofocus: true,
            minLines: 3,
            maxLines: 8,
          ),
        ),
      ),
    );
    await tester.pump();
    return controller;
  }

  Future<void> paste(WidgetTester tester) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
  }

  testOnLinux('paste drops the whitespace around what it inserts', (t) async {
    putOnClipboard('\n\n  Attention is all you need.  \n');
    final controller = await pump(t, '');

    await paste(t);

    expect(controller.text, 'Attention is all you need.');
  });

  testOnLinux('the text inside a paste is left alone', (tester) async {
    putOnClipboard('  first line\n\n   indented second\n');
    final controller = await pump(tester, '');

    await paste(tester);

    expect(controller.text, 'first line\n\n   indented second');
  });

  testOnLinux('paste lands at the cursor, not over the field', (tester) async {
    putOnClipboard('  world  ');
    final controller = await pump(tester, 'hello ');
    controller.selection = const TextSelection.collapsed(offset: 6);

    await paste(tester);

    expect(controller.text, 'hello world');
    expect(controller.selection.baseOffset, 11);
  });

  testOnLinux('paste replaces the selection', (tester) async {
    putOnClipboard(' there ');
    final controller = await pump(tester, 'hello world');
    controller.selection = const TextSelection(baseOffset: 6, extentOffset: 11);

    await paste(tester);

    expect(controller.text, 'hello there');
  });

  testOnLinux('an empty clipboard leaves the field alone', (tester) async {
    putOnClipboard(null);
    final controller = await pump(tester, 'hello');

    await paste(tester);

    expect(controller.text, 'hello');
  });
}
