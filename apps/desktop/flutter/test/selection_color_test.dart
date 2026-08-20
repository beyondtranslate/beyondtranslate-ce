// 光标和选中颜色 — the caret and the wash behind selected glyphs.
//
// Neither side reaches for the app's theme on its own: AppKit falls back to
// the system accent from System Settings, Flutter to Material's blue. Both had
// to be told, so both are pinned here.
import 'package:beyondtranslate_desktop/src/widgets/native_text.dart';
import 'package:beyondtranslate_desktop/src/widgets/native_text_field.dart';
import 'package:beyondtranslate_desktop/src/widgets/text_field.dart';
import 'package:beyondtranslate_desktop/src/widgets/translation_text.dart';
import 'package:beyondtranslate_ui/beyondtranslate_ui.dart'
    show DesignTheme, DesignThemes;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tokens = DesignThemes.brightLight;
  final accent = tokens.colors.accent;
  final selection = accent.withValues(alpha: 0.2);

  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: DesignTheme(tokens: tokens, child: child),
      ),
    );
  }

  /// [testWidgets] with the platform pinned for the length of the body — the
  /// framework checks the override is back to null before the test ends, so it
  /// cannot be undone from `tearDown`.
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

  group('译文', () {
    testOn(TargetPlatform.macOS, 'hands the accent to AppKit', (tester) async {
      await pump(tester, const TranslationText('hello'));

      final text = tester.widget<NativeText>(find.byType(NativeText));
      expect(text.selectionColor, selection);
      expect(text.brightness, tokens.brightness);
    });

    testOn(TargetPlatform.linux, 'dresses the Flutter selection to match',
        (tester) async {
      await pump(tester, const TranslationText('hello'));

      expect(
        tester
            .widget<DefaultSelectionStyle>(find.byType(DefaultSelectionStyle))
            .selectionColor,
        selection,
      );
    });
  });

  group('输入框', () {
    testOn(TargetPlatform.macOS, 'hands the accent to AppKit', (tester) async {
      await pump(tester, const TextField());

      final field = tester.widget<NativeTextField>(
        find.byType(NativeTextField),
      );
      expect(field.cursorColor, accent);
      expect(field.selectionColor, selection);
      expect(field.brightness, tokens.brightness);
    });

    testOn(TargetPlatform.linux, 'carries the accent into EditableText',
        (tester) async {
      await pump(tester, const TextField());

      final editable = tester.widget<EditableText>(
        find.byWidgetPredicate((w) => w is EditableText),
      );
      expect(editable.cursorColor, accent);
      expect(editable.selectionColor, selection);
    });
  });

  testOn(TargetPlatform.macOS, 'a dark theme reaches AppKit as dark',
      (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: DesignTheme(
          tokens: DesignThemes.brightDark,
          child: const TranslationText('hello'),
        ),
      ),
    );

    expect(
      tester.widget<NativeText>(find.byType(NativeText)).brightness,
      Brightness.dark,
    );
  });

  testWidgets('a different theme moves the colours with it', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: DesignTheme(
          tokens: DesignThemes.studioDark,
          child: const TranslationText('hello'),
        ),
      ),
    );

    final dressed = tester.widget<DefaultSelectionStyle>(
      find.byType(DefaultSelectionStyle),
    );
    expect(
      dressed.selectionColor,
      DesignThemes.studioDark.colors.accent.withValues(alpha: 0.2),
    );
    expect(dressed.selectionColor, isNot(selection));
  });
}
