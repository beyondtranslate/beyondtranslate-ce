import 'package:beyondtranslate_ui/src/theme/tokens.dart';
import 'package:flutter/widgets.dart';

/// `studioLight` is the baseline the widgets were built against; the others
/// re-skin the same widgets by swapping tokens — including radii, so the Bright
/// themes' pill controls need no widget changes. The Bright pair maps to deck
/// sections 4b (light) and 4e (dark).
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
    description: '墨蓝从文字变画布、暖白从纸面变文字；酸性绿分工不变，高亮改 8% 低透明填色，不发光。',
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
    progressGradient: linearGradientFromAngle(90, const [
      Color(0xFF6B4DFF),
      Color(0xFFA08CFF),
    ]),
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
    progressGradient: linearGradientFromAngle(90, const [
      Color(0xFF7C5CFF),
      Color(0xFFB9A8FF),
    ]),
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
      hairline: Color(0x0FFFFFFF),
      hairlineStrong: Color(0x1AFFFFFF),
      hairlineSoft: Color(0x0DFFFFFF),
      accentHairline: Color(0x477C5CFF),
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
      warnHairline: Color(0x47FFB86B),
      warnMark: Color(0x38FFB86B),
      danger: Color(0xFFFF6B6B),
      dangerFg: Color(0xFFFF8F8F),
      dangerDeep: Color(0xFFFFC9C9),
      dangerSurface: Color(0x1AFF6B6B),
      dangerHairline: Color(0x52FF6B6B),
    ),
    shadows: const DesignShadows(
      window: [
        BoxShadow(
          offset: Offset(0, 16),
          blurRadius: 40,
          color: Color(0x99000000),
        ),
      ],
      popover: [
        BoxShadow(
          offset: Offset(0, 14),
          blurRadius: 36,
          color: Color(0x94000000),
        ),
      ],
      float: [
        BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 28,
          color: Color(0x8C000000),
        ),
      ],
      lift: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 14,
          color: Color(0x73000000),
        ),
      ],
      accent: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Color(0x66000000),
        ),
      ],
      accentLg: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 3,
          color: Color(0x73000000),
        ),
      ],
      ball: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 14,
          color: Color(0x80000000),
        ),
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
    progressGradient: linearGradientFromAngle(90, const [
      Color(0xFF111C2E),
      Color(0xFFD6FF3F),
    ]),
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
      track: Color(0xFFE5E3DB),
      controlOutline: Color(0x40111C2E),
      controlRaised: Color(0xFFFFFFFF),
      selectionUnemphasized: Color(0x1A111C2E),
      // Inverted relative to the Studio themes: the tray is the warm paper and
      // the panel inside it is pure white.
      tray: Color(0xFFFBFAF7),
      panel: Color(0xFFFFFFFF),
      accentSurface: Color(0xFFF6FAE2),
      accentSurfaceAlt: Color(0xFFF1F7D2),
      hairline: Color(0x14111C2E),
      hairlineStrong: Color(0x1F111C2E),
      hairlineSoft: Color(0x12111C2E),
      accentHairline: Color(0xFFD6FF3F),
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
      warnHairline: Color(0x4CC98420),
      warnMark: Color(0xFFFFE0B8),
      danger: Color(0xFFC0392B),
      dangerFg: Color(0xFFA62F23),
      dangerDeep: Color(0xFF6D1B13),
      dangerSurface: Color(0xFFFBEEEC),
      dangerHairline: Color(0x52C0392B),
    ),
    // Pill controls are this theme's signature, so they stay — but only on the
    // `control` axis, where height sets the curve. Containers take a finite,
    // generous corner instead; a pill textarea reads as a lozenge, not a field.
    // The window / popover / backdrop / avatar radii are pinned at Studio's old
    // base so a Studio-side bump doesn't round the Bright chrome.
    radii: const DesignRadii(
      backdrop: 24,
      window: 16,
      popover: 14,
      avatar: 7,
      control: 999,
      controlSm: 999,
      chip: 999,
      box: 14,
      card: 12,
    ),
    shadows: const DesignShadows(
      window: [
        BoxShadow(
          offset: Offset(0, 12),
          blurRadius: 32,
          color: Color(0x33111C2E),
        ),
      ],
      popover: [
        BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 30,
          color: Color(0x2E111C2E),
        ),
      ],
      float: [
        BoxShadow(
          offset: Offset(0, 8),
          blurRadius: 24,
          color: Color(0x2E111C2E),
        ),
      ],
      lift: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 12,
          color: Color(0x24111C2E),
        ),
      ],
      accent: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Color(0x1F111C2E),
        ),
      ],
      accentLg: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 3,
          color: Color(0x24111C2E),
        ),
      ],
      ball: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 12,
          color: Color(0x3D111C2E),
        ),
      ],
    ),
  );

  // ------------------------------------------------------------------ //
  // Bright Dark — deck section 4e: Bright Light with the roles swapped.
  // Ink navy moves from text to canvas, warm paper from canvas to text.
  // Acid green keeps its single job (marking the block being read) but its
  // surface becomes a low-alpha tint — "8% 低透明填色，不发光不刺眼" — while
  // primary actions invert to acid green printed with ink navy.
  // ------------------------------------------------------------------ //

  static final DesignTokens brightDark = DesignTokens(
    brightness: Brightness.dark,
    backdrop: linearGradientFromAngle(
      140,
      const [Color(0xFF3F4A3A), Color(0xFF232A2C), Color(0xFF0E1216)],
      const [0, 0.5, 1],
    ),
    // The deck fills progress solid acid; two identical stops keep the token
    // a gradient because Progress paints it as one.
    progressGradient: linearGradientFromAngle(90, const [
      Color(0xFFD6FF3F),
      Color(0xFFD6FF3F),
    ]),
    // Explicitly no glow — the deck: "不发光不刺眼".
    colors: const DesignColors(
      canvas: Color(0xFF0A111A),
      window: Color(0xFF0C141E),
      chrome: Color(0xFF111A26),
      sidebar: Color(0xFF0A111A),
      rail: Color(0xFF0B1219),
      raised: Color(0xFF111A26),
      card: Color(0xFF141D29),
      subtle: Color(0xFF101923),
      inset: Color(0xFF16202C),
      control: Color(0xFF1C2734),
      controlHover: Color(0xFF24303F),
      track: Color(0xFF1C2734),
      controlOutline: Color(0xFF35414F),
      controlRaised: Color(0xFF2A3644),
      selectionUnemphasized: Color(0x21F2F4EF),
      tray: Color(0xFF111A26),
      panel: Color(0xFF0C141E),
      // Low-alpha on purpose: the deck floats the tint over whichever surface
      // the block sits on instead of committing to an opaque green-dark mix.
      accentSurface: Color(0x14D6FF3F),
      accentSurfaceAlt: Color(0x1FD6FF3F),
      hairline: Color(0x14F2F4EF),
      hairlineStrong: Color(0x24F2F4EF),
      hairlineSoft: Color(0x0FF2F4EF),
      // The rules fencing the current block stay solid acid, same as light.
      accentHairline: Color(0xFFD6FF3F),
      fg: Color(0xFFF2F4EF),
      fgSecondary: Color(0xC7F2F4EF),
      fgTertiary: Color(0xA8F2F4EF),
      fgMuted: Color(0x80F2F4EF),
      fgSubtle: Color(0x73F2F4EF),
      fgFaint: Color(0x61F2F4EF),
      fgNav: Color(0xB2F2F4EF),
      fgControl: Color(0xFFF2F4EF),
      // The exact inversion of Bright Light's primary pair: acid green fill,
      // ink navy printed on top.
      accent: Color(0xFFD6FF3F),
      accentHover: Color(0xFFC2EA2C),
      onAccent: Color(0xFF111C2E),
      accentText: Color(0xFFD6FF3F),
      accentTextStrong: Color(0xFFE9FF8F),
      highlight: Color(0xFFD6FF3F),
      accentRing: Color(0x59D6FF3F),
      focusRing: Color(0x8CD6FF3F),
      // Term marks lift the text along with the tint (#e9ff8f), where the
      // light theme leaves marked text at full ink.
      accentMark: Color(0x38D6FF3F),
      accentMarkFg: Color(0xFFE9FF8F),
      inverse: Color(0xFF1C2734),
      inverseFg: Color(0xFFF2F4EF),
      success: Color(0xFF5FD88A),
      successSurface: Color(0x295FD88A),
      warn: Color(0xFFFFB86B),
      warnStrong: Color(0xFFFFB86B),
      warnFg: Color(0xFFFFC98A),
      warnSurface: Color(0x1AFFB86B),
      warnHairline: Color(0x47FFB86B),
      warnMark: Color(0x3DFFB86B),
      danger: Color(0xFFFF7A68),
      dangerFg: Color(0xFFFF9585),
      dangerDeep: Color(0xFFFFCFC7),
      dangerSurface: Color(0x1FFF7A68),
      dangerHairline: Color(0x52FF7A68),
    ),
    // Same layout scheme as Bright Light: pill controls, finite containers,
    // and the window / popover / backdrop / avatar radii pinned at Studio's
    // old base so a Studio-side bump doesn't round the Bright chrome.
    radii: const DesignRadii(
      backdrop: 24,
      window: 16,
      popover: 14,
      avatar: 7,
      control: 999,
      controlSm: 999,
      chip: 999,
      box: 14,
      card: 12,
    ),
    shadows: const DesignShadows(
      window: [
        BoxShadow(
          offset: Offset(0, 16),
          blurRadius: 40,
          color: Color(0x8C000000),
        ),
      ],
      popover: [
        BoxShadow(
          offset: Offset(0, 14),
          blurRadius: 36,
          color: Color(0x85000000),
        ),
      ],
      float: [
        BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 28,
          color: Color(0x80000000),
        ),
      ],
      lift: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 14,
          color: Color(0x6B000000),
        ),
      ],
      accent: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Color(0x66000000),
        ),
      ],
      accentLg: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 3,
          color: Color(0x73000000),
        ),
      ],
      ball: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 14,
          color: Color(0x80000000),
        ),
      ],
    ),
  );
}
