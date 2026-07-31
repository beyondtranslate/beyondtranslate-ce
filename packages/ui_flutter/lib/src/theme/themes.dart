import 'package:beyondtranslate_ui/src/theme/tokens.dart';
import 'package:flutter/widgets.dart';

/// `studioLight` is the baseline the components were built against; the others
/// re-skin the same widgets by swapping tokens — including radii, so the Bright
/// themes' pill controls need no widget changes. `brightDark` isn't in the
/// design deck — it's a dark canvas extrapolated from `brightLight`'s palette.
enum DesignThemeName {
  studioLight,
  studioDark,
  brightLight,
  brightDark;

  /// The `data-theme` value the React package uses, so both sides can share a
  /// theme name over the wire.
  String get id => switch (this) {
        DesignThemeName.studioLight => 'studio-light',
        DesignThemeName.studioDark => 'studio-dark',
        DesignThemeName.brightLight => 'bright-light',
        DesignThemeName.brightDark => 'bright-dark',
      };

  static DesignThemeName fromId(String id) => DesignThemeName.values.firstWhere(
        (theme) => theme.id == id,
        orElse: () => DesignThemeName.studioLight,
      );

  DesignTokens get tokens => switch (this) {
        DesignThemeName.studioLight => DesignThemes.studioLight,
        DesignThemeName.studioDark => DesignThemes.studioDark,
        DesignThemeName.brightLight => DesignThemes.brightLight,
        DesignThemeName.brightDark => DesignThemes.brightDark,
      };
}

@immutable
class DesignThemeMeta {
  const DesignThemeMeta({
    required this.name,
    required this.title,
    required this.description,
  });

  final DesignThemeName name;
  final String title;
  final String description;
}

const Map<DesignThemeName, DesignThemeMeta> designThemeMeta = {
  DesignThemeName.studioLight: DesignThemeMeta(
    name: DesignThemeName.studioLight,
    title: 'Studio Light',
    description: '白卡片浮在浅灰画布上，紫电强调色略压深以保证对比。基准方案。',
  ),
  DesignThemeName.studioDark: DesignThemeMeta(
    name: DesignThemeName.studioDark,
    title: 'Studio Dark',
    description: '同一骨架、同一间距，近黑分层画布 + 紫电发光强调。',
  ),
  DesignThemeName.brightLight: DesignThemeMeta(
    name: DesignThemeName.brightLight,
    title: 'Bright Light',
    description: '暖白纸面、墨蓝文字、酸性绿只用来标记当前段；控件改为胶囊。',
  ),
  DesignThemeName.brightDark: DesignThemeMeta(
    name: DesignThemeName.brightDark,
    title: 'Bright Dark',
    description: '同一套酸性绿标记与胶囊控件，画布换成墨绿近黑；是 Bright Light 的暗色延伸。',
  ),
};

/// The four token tables. `studioLight` is the baseline; the others are
/// written as "the baseline, plus these overrides", exactly like the CSS.
abstract final class DesignThemes {
// ------------------------------------------------------------------ //
// Studio Light — the baseline
// ------------------------------------------------------------------ //

  /// Every field of [DesignColors], [DesignRadii] and [DesignShadows] already defaults to the
  /// Studio Light value, so the baseline theme only has to name the two gradients.
  static final DesignTokens studioLight = DesignTokens(
    brightness: Brightness.light,
    backdrop: linearGradientFromAngle(
      150,
      const [Color(0xFFE9E6FF), Color(0xFFDCDAF0), Color(0xFFC9C7DD)],
      const [0, 0.55, 1],
    ),
    progressGradient: linearGradientFromAngle(
      90,
      const [Color(0xFF6B4DFF), Color(0xFFA08CFF)],
    ),
  );

// ------------------------------------------------------------------ //
// Studio Dark — same skeleton, near-black canvas, violet-electric
// ------------------------------------------------------------------ //

  static final DesignTokens studioDark = DesignTokens(
    brightness: Brightness.dark,
    backdrop: linearGradientFromAngle(
      150,
      const [Color(0xFF3A2C6B), Color(0xFF171A2E), Color(0xFF0A0B10)],
      const [0, 0.55, 1],
    ),
    progressGradient: linearGradientFromAngle(
      90,
      const [Color(0xFF7C5CFF), Color(0xFFB9A8FF)],
    ),
    highlightGlow: const [
      BoxShadow(blurRadius: 10, color: Color(0xE67C5CFF)),
    ],
    colors: const DesignColors(
      canvas: Color(0xFF0A0B10),
      window: Color(0xFF0D0F14),
      chrome: Color(0xFF12141A),
      sidebar: Color(0xFF0A0C11),
      rail: Color(0xFF0B0D12),
      raised: Color(0xFF12141A),
      card: Color(0xFF12151D),
      subtle: Color(0xFF151821),
      inset: Color(0xFF1B1E26),
      control: Color(0xFF1B1E26),
      controlHover: Color(0xFF262A34),
      track: Color(0xFF262A34),
      controlOutline: Color(0xFF363C4D),
      controlRaised: Color(0xFF3A3F4D),
      selectionUnemphasized: Color(0x21FFFFFF),
      tray: Color(0xFF12141A),
      panel: Color(0xFF0D0F14),
      accentSurface: Color(0xFF141822),
      accentSurfaceAlt: Color(0xFF171A2E),
      border: Color(0x0FFFFFFF),
      borderStrong: Color(0x1AFFFFFF),
      borderHairline: Color(0x0DFFFFFF),
      accentBorder: Color(0x477C5CFF),
      fg: Color(0xFFF2F3FA),
      fgSecondary: Color(0xFFC3C8DC),
      fgTertiary: Color(0xFF9AA1BB),
      fgMuted: Color(0xFF7B8199),
      fgSubtle: Color(0xFF8B93B0),
      fgFaint: Color(0xFF6A7090),
      fgNav: Color(0xFF9AA1BB),
      fgControl: Color(0xFFC3C8DC),
      onAccent: Color(0xFFFFFFFF),
      inverse: Color(0xFF1B1E26),
      inverseFg: Color(0xFFF2F3FA),
      accent: Color(0xFF7C5CFF),
      accentHover: Color(0xFF6A48FF),
      accentText: Color(0xFFB9A8FF),
      accentTextStrong: Color(0xFFCDC0FF),
      highlight: Color(0xFF7C5CFF),
      accentRing: Color(0x387C5CFF),
      focusRing: Color(0x807C5CFF),
      accentMark: Color(0x3D7C5CFF),
      accentMarkFg: Color(0xFFCDC0FF),
      success: Color(0xFF34D399),
      successSurface: Color(0x2934D399),
      warn: Color(0xFFFFB86B),
      warnStrong: Color(0xFFFFB86B),
      warnFg: Color(0xFFFFCF9C),
      warnSurface: Color(0x1AFFB86B),
      warnBorder: Color(0x47FFB86B),
      warnMark: Color(0x38FFB86B),
      danger: Color(0xFFFF6B6B),
      dangerFg: Color(0xFFFF8F8F),
      dangerDeep: Color(0xFFFFC9C9),
      dangerSurface: Color(0x1AFF6B6B),
      dangerBorder: Color(0x52FF6B6B),
    ),
    shadows: const DesignShadows(
      window: [
        BoxShadow(
            offset: Offset(0, 16), blurRadius: 40, color: Color(0x99000000)),
      ],
      popover: [
        BoxShadow(
            offset: Offset(0, 14), blurRadius: 36, color: Color(0x94000000)),
      ],
      float: [
        BoxShadow(
            offset: Offset(0, 10), blurRadius: 28, color: Color(0x8C000000)),
      ],
      lift: [
        BoxShadow(
            offset: Offset(0, 4), blurRadius: 14, color: Color(0x73000000)),
      ],
      accent: [
        BoxShadow(
            offset: Offset(0, 1), blurRadius: 2, color: Color(0x66000000)),
      ],
      accentLg: [
        BoxShadow(
            offset: Offset(0, 1), blurRadius: 3, color: Color(0x73000000)),
      ],
      ball: [
        BoxShadow(
            offset: Offset(0, 4), blurRadius: 14, color: Color(0x80000000)),
      ],
    ),
  );

// ------------------------------------------------------------------ //
// Bright Light — warm paper, ink navy, acid green marker, pill controls
// ------------------------------------------------------------------ //

  static final DesignTokens brightLight = DesignTokens(
    brightness: Brightness.light,
    backdrop: linearGradientFromAngle(
      140,
      const [Color(0xFFDFE7D5), Color(0xFFB9C3AE), Color(0xFF8B9782)],
      const [0, 0.5, 1],
    ),
    progressGradient: linearGradientFromAngle(
      90,
      const [Color(0xFF111C2E), Color(0xFFD6FF3F)],
    ),
    // The preferred block gets a heavier acid rule here.
    highlightRule: 2,
    colors: const DesignColors(
      canvas: Color(0xFFE6EADE),
      window: Color(0xFFFBFAF7),
      chrome: Color(0xFFFFFFFF),
      sidebar: Color(0xFFF4F3EE),
      rail: Color(0xFFF8F7F3),
      raised: Color(0xFFFFFFFF),
      card: Color(0xFFF6F5F1),
      subtle: Color(0xFFF6F5F1),
      inset: Color(0xFFF0EFE9),
      control: Color(0xFFF0EFE9),
      controlHover: Color(0xFFE8E6DD),
      track: Color(0xFFE4E2D9),
      controlOutline: Color(0x40111C2E),
      controlRaised: Color(0xFFFFFFFF),
      selectionUnemphasized: Color(0x1A111C2E),
      // Inverted relative to the Studio themes: the tray is the warm paper and
      // the panel inside it is pure white.
      tray: Color(0xFFFBFAF7),
      panel: Color(0xFFFFFFFF),
      accentSurface: Color(0xFFF6FAE2),
      accentSurfaceAlt: Color(0xFFF1F7D2),
      border: Color(0x14111C2E),
      borderStrong: Color(0x1F111C2E),
      borderHairline: Color(0x12111C2E),
      accentBorder: Color(0xFFD6FF3F),
      fg: Color(0xFF111C2E),
      fgSecondary: Color(0xC7111C2E),
      fgTertiary: Color(0xA8111C2E),
      fgMuted: Color(0x80111C2E),
      fgSubtle: Color(0x73111C2E),
      fgFaint: Color(0x61111C2E),
      fgNav: Color(0xB2111C2E),
      fgControl: Color(0xFF111C2E),
      // Primary actions are ink navy printed with acid green; the marker itself
      // is the acid green. This is why `accent` and `highlight` are separate.
      accent: Color(0xFF111C2E),
      accentHover: Color(0xFF1C2A41),
      onAccent: Color(0xFFD6FF3F),
      accentText: Color(0xFF111C2E),
      accentTextStrong: Color(0xFF111C2E),
      highlight: Color(0xFFD6FF3F),
      accentRing: Color(0x80D6FF3F),
      focusRing: Color(0x73111C2E),
      accentMark: Color(0xFFE6F77A),
      accentMarkFg: Color(0xFF111C2E),
      inverse: Color(0xFF111C2E),
      inverseFg: Color(0xFFD6FF3F),
      success: Color(0xFF3F7D54),
      successSurface: Color(0x243F7D54),
      warn: Color(0xFFC98420),
      warnStrong: Color(0xFFA06712),
      warnFg: Color(0xFF7A4F0E),
      warnSurface: Color(0xFFFBF3E2),
      warnBorder: Color(0x4CC98420),
      warnMark: Color(0xFFFBE3BB),
      danger: Color(0xFFC0392B),
      dangerFg: Color(0xFFA62F23),
      dangerDeep: Color(0xFF6D1B13),
      dangerSurface: Color(0xFFFBEEEC),
      dangerBorder: Color(0x52C0392B),
      engineDict: Color(0xFF5B7F6B),
    ),
    // Pill controls are this theme's signature, so they stay — but only on the
    // `control` axis, where height sets the curve. Containers take a finite,
    // generous corner instead; a pill textarea reads as a lozenge, not a field.
    radii: const DesignRadii(
      control: 999,
      controlSm: 999,
      chip: 999,
      box: 14,
      card: 12,
    ),
    shadows: const DesignShadows(
      window: [
        BoxShadow(
            offset: Offset(0, 12), blurRadius: 32, color: Color(0x33111C2E)),
      ],
      popover: [
        BoxShadow(
            offset: Offset(0, 10), blurRadius: 30, color: Color(0x2E111C2E)),
      ],
      float: [
        BoxShadow(
            offset: Offset(0, 8), blurRadius: 24, color: Color(0x2E111C2E)),
      ],
      lift: [
        BoxShadow(
            offset: Offset(0, 4), blurRadius: 12, color: Color(0x24111C2E)),
      ],
      accent: [
        BoxShadow(
            offset: Offset(0, 1), blurRadius: 2, color: Color(0x1F111C2E)),
      ],
      accentLg: [
        BoxShadow(
            offset: Offset(0, 1), blurRadius: 3, color: Color(0x24111C2E)),
      ],
      ball: [
        BoxShadow(
            offset: Offset(0, 4), blurRadius: 12, color: Color(0x3D111C2E)),
      ],
    ),
  );

// ------------------------------------------------------------------ //
// Bright Dark — not in the deck: Bright Light's ink-navy/acid-green identity
// carried onto a dark canvas. Acid green moves from "marker only" to the
// accent fill itself, since ink navy has no contrast left to give.
// ------------------------------------------------------------------ //

  static final DesignTokens brightDark = DesignTokens(
    brightness: Brightness.dark,
    backdrop: linearGradientFromAngle(
      140,
      const [Color(0xFF2E3A28), Color(0xFF1A2318), Color(0xFF0B0F09)],
      const [0, 0.5, 1],
    ),
    progressGradient: linearGradientFromAngle(
      90,
      const [Color(0xFF6B8F22), Color(0xFFD6FF3F)],
    ),
    highlightRule: 2,
    highlightGlow: const [
      BoxShadow(blurRadius: 10, color: Color(0xB3D6FF3F)),
    ],
    colors: const DesignColors(
      canvas: Color(0xFF0E120B),
      window: Color(0xFF14180F),
      chrome: Color(0xFF191D13),
      sidebar: Color(0xFF10130B),
      rail: Color(0xFF12160D),
      raised: Color(0xFF191D13),
      card: Color(0xFF171B11),
      subtle: Color(0xFF1A1E14),
      inset: Color(0xFF20251A),
      control: Color(0xFF20251A),
      controlHover: Color(0xFF292F20),
      track: Color(0xFF292F20),
      controlOutline: Color(0xFF3C4331),
      controlRaised: Color(0xFF363D29),
      selectionUnemphasized: Color(0x21F3F6EA),
      tray: Color(0xFF191D13),
      panel: Color(0xFF14180F),
      accentSurface: Color(0xFF1D2416),
      accentSurfaceAlt: Color(0xFF222A19),
      border: Color(0x14E6F79A),
      borderStrong: Color(0x24E6F79A),
      borderHairline: Color(0x0FE6F79A),
      accentBorder: Color(0x66D6FF3F),
      fg: Color(0xFFF3F6EA),
      fgSecondary: Color(0xC7F3F6EA),
      fgTertiary: Color(0x9EF3F6EA),
      fgMuted: Color(0x7AF3F6EA),
      fgSubtle: Color(0x66F3F6EA),
      fgFaint: Color(0x52F3F6EA),
      fgNav: Color(0xB2F3F6EA),
      fgControl: Color(0xFFF3F6EA),
      // Ink navy can't carry a fill on a dark canvas, so accent and highlight
      // converge back onto acid green here — dark text prints on top of it.
      accent: Color(0xFFD6FF3F),
      accentHover: Color(0xFFC2EA2C),
      onAccent: Color(0xFF12180A),
      accentText: Color(0xFFD6FF3F),
      accentTextStrong: Color(0xFFE4FF70),
      highlight: Color(0xFFD6FF3F),
      accentRing: Color(0x59D6FF3F),
      focusRing: Color(0x8CD6FF3F),
      accentMark: Color(0x38D6FF3F),
      accentMarkFg: Color(0xFFEAFFA0),
      inverse: Color(0xFF262C1C),
      inverseFg: Color(0xFFF3F6EA),
      success: Color(0xFF5FD88A),
      successSurface: Color(0x295FD88A),
      warn: Color(0xFFFFB84D),
      warnStrong: Color(0xFFFFB84D),
      warnFg: Color(0xFFFFD28F),
      warnSurface: Color(0x1AFFB84D),
      warnBorder: Color(0x47FFB84D),
      warnMark: Color(0x38FFB84D),
      danger: Color(0xFFFF7A68),
      dangerFg: Color(0xFFFF9585),
      dangerDeep: Color(0xFFFFCFC7),
      dangerSurface: Color(0x1FFF7A68),
      dangerBorder: Color(0x52FF7A68),
      engineDict: Color(0xFF82A690),
    ),
    radii: const DesignRadii(
      control: 999,
      controlSm: 999,
      chip: 999,
      box: 14,
      card: 12,
    ),
    shadows: const DesignShadows(
      window: [
        BoxShadow(
            offset: Offset(0, 16), blurRadius: 40, color: Color(0x8C000000)),
      ],
      popover: [
        BoxShadow(
            offset: Offset(0, 14), blurRadius: 36, color: Color(0x85000000)),
      ],
      float: [
        BoxShadow(
            offset: Offset(0, 10), blurRadius: 28, color: Color(0x80000000)),
      ],
      lift: [
        BoxShadow(
            offset: Offset(0, 4), blurRadius: 14, color: Color(0x6B000000)),
      ],
      accent: [
        BoxShadow(
            offset: Offset(0, 1), blurRadius: 2, color: Color(0x66000000)),
      ],
      accentLg: [
        BoxShadow(
            offset: Offset(0, 1), blurRadius: 3, color: Color(0x73000000)),
      ],
      ball: [
        BoxShadow(
            offset: Offset(0, 4), blurRadius: 14, color: Color(0x80000000)),
      ],
    ),
  );
}
