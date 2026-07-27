import 'package:flutter/material.dart';

abstract final class DesignColors {
  static const paper = Color(0xfff2f2f3);
  static const panel = Color(0xffe9e9ea);
  static const white = Color(0xffffffff);
  static const ink = Color(0xff1d1f20);
  static const accent = Color(0xff5980a6);
  static const deepBlue = Color(0xff416180);
  static const danger = Color(0xffb54a43);
}

abstract final class UiSpace {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

@immutable
class DesignThemeData extends ThemeExtension<DesignThemeData> {
  const DesignThemeData({
    this.paper = DesignColors.paper,
    this.panel = DesignColors.panel,
    this.translatedSurface = const Color(0xfff6f6f7),
    this.text = DesignColors.ink,
    this.accent = DesignColors.accent,
    this.accentDark = DesignColors.deepBlue,
    this.border = const Color(0x291d1f20),
    this.mutedText = const Color(0x991d1f20),
    this.quietText = const Color(0x731d1f20),
    this.shadow = const Color(0x382b2b2d),
  });

  final Color paper;
  final Color panel;
  final Color translatedSurface;
  final Color text;
  final Color accent;
  final Color accentDark;
  final Color border;
  final Color mutedText;
  final Color quietText;
  final Color shadow;

  static const fallback = DesignThemeData();
  static const dark = DesignThemeData(
    paper: Color(0xff1d1f20),
    panel: Color(0xff272a2c),
    translatedSurface: Color(0xff222527),
    text: Color(0xfff2f2f3),
    accent: Color(0xff7fa5c8),
    accentDark: Color(0xffa9c5de),
    border: Color(0x33f2f2f3),
    mutedText: Color(0xb3f2f2f3),
    quietText: Color(0x80f2f2f3),
    shadow: Color(0x99000000),
  );

  @override
  DesignThemeData copyWith({
    Color? paper,
    Color? panel,
    Color? translatedSurface,
    Color? text,
    Color? accent,
    Color? accentDark,
    Color? border,
    Color? mutedText,
    Color? quietText,
    Color? shadow,
  }) =>
      DesignThemeData(
        paper: paper ?? this.paper,
        panel: panel ?? this.panel,
        translatedSurface: translatedSurface ?? this.translatedSurface,
        text: text ?? this.text,
        accent: accent ?? this.accent,
        accentDark: accentDark ?? this.accentDark,
        border: border ?? this.border,
        mutedText: mutedText ?? this.mutedText,
        quietText: quietText ?? this.quietText,
        shadow: shadow ?? this.shadow,
      );

  @override
  DesignThemeData lerp(DesignThemeData? other, double t) {
    if (other is! DesignThemeData) return this;
    return DesignThemeData(
      paper: Color.lerp(paper, other.paper, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      translatedSurface:
          Color.lerp(translatedSurface, other.translatedSurface, t)!,
      text: Color.lerp(text, other.text, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDark: Color.lerp(accentDark, other.accentDark, t)!,
      border: Color.lerp(border, other.border, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      quietText: Color.lerp(quietText, other.quietText, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension DesignThemeContext on BuildContext {
  DesignThemeData get design =>
      Theme.of(this).extension<DesignThemeData>() ?? DesignThemeData.fallback;

  TextStyle get eyebrowTextStyle => TextStyle(
        color: design.accent,
        fontFamily: 'Roboto Mono',
        fontFamilyFallback: const ['MiSans'],
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      );
}

ThemeData designTheme(ThemeData base) {
  final colors = base.brightness == Brightness.dark
      ? DesignThemeData.dark
      : DesignThemeData.fallback;
  return base.copyWith(
    scaffoldBackgroundColor: colors.paper,
    canvasColor: colors.translatedSurface,
    dividerColor: colors.border,
    colorScheme: base.colorScheme.copyWith(
      primary: colors.accent,
      onPrimary: colors.paper,
      surface: colors.paper,
      onSurface: colors.text,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: colors.text.withValues(alpha: 0.40)),
      ),
      titleTextStyle: TextStyle(
        color: colors.text,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFamily: 'MiSans',
      ),
      contentTextStyle: TextStyle(
        color: colors.text,
        fontSize: 13,
        fontFamily: 'MiSans',
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[colors],
    textTheme: base.textTheme.apply(
      fontFamily: 'MiSans',
      bodyColor: colors.text,
      displayColor: colors.text,
    ),
  );
}
