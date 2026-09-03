import 'package:flutter/widgets.dart';

import '../i18n/i18n.dart';
import '../services/system_translation.dart';
import '../utils/language_util.dart';
import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Pressable,
        kTransitionDuration;

/// 系统翻译 without a pair's language files — the deck's wording for it.
///
/// Apple's Translation framework installs language files per pair, in System
/// Settings, and the app cannot start that download itself; so every place
/// this failure shows names the pair and points at the pane.
abstract final class MissingLanguageText {
  /// 系统翻译还没有下载「English → 简体中文」的语言文件。
  static String sentence(SystemLanguageNotInstalled missing) =>
      t.mini_translator.result.language_missing_sentence(
        source: getLanguageName(missing.source),
        target: getLanguageName(missing.target),
      );

  /// The main window's body: the sentence, then the full settings path.
  static String body(SystemLanguageNotInstalled missing) =>
      '${sentence(missing)}'
      '${t.mini_translator.result.language_missing_body_main(path: t.mini_translator.result.language_missing_settings_path)}';

  /// 「English → 简体中文」语言文件未下载 — the compare row's short form.
  static String note(SystemLanguageNotInstalled missing) =>
      t.mini_translator.result.language_missing_note(
        source: getLanguageName(missing.source),
        target: getLanguageName(missing.target),
      );
}

/// 前往系统设置 / 系统设置 as an inline text link — accent, underlined on hover —
/// that opens 翻译语言 in System Settings.
class SystemSettingsLink extends StatelessWidget {
  const SystemSettingsLink({
    super.key,
    required this.label,
    required this.style,
    this.bold = true,
  });

  final String label;
  final TextStyle style;

  /// The compare row's link is semibold; the mini's sentence link keeps the
  /// sentence's own weight.
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onPressed: openTranslationLanguagesSettings,
      semanticsLabel: label,
      builder: (context, state) => AnimatedDefaultTextStyle(
        duration: kTransitionDuration,
        style: style.copyWith(
          color: colors.accentText,
          fontWeight: bold ? FontWeight.w600 : null,
          decoration:
              state.hovered ? TextDecoration.underline : TextDecoration.none,
          decorationColor: colors.accentText,
        ),
        child: Text(label),
      ),
    );
  }
}

/// A compare row's second line when the service lacks the pair's language
/// files: no translation to show, so the reason, with the fix inline.
class MissingLanguageNote extends StatelessWidget {
  const MissingLanguageNote({super.key, required this.missing});

  final SystemLanguageNotInstalled missing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final style = tokens.typography.sansStyle(fontSize: 12, height: 1.7);

    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(
          MissingLanguageText.note(missing),
          style: style.copyWith(color: colors.warnFg),
        ),
        SystemSettingsLink(
          label: t.mini_translator.result.open_system_settings,
          style: style,
        ),
      ],
    );
  }
}
