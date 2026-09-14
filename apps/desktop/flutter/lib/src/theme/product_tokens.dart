/// The tokens and type recipes only BeyondTranslate itself has a use for.
///
/// `packages/ui_flutter` is vendored from upstream and stays domain-free, so
/// anything that encodes a product concept lives here instead: the provider
/// brand colours, the marker on a preferred translation, the platform type
/// stacks, and the typography of a source / translation pair.
///
/// Two of the three extensions below only *name* things the kit already
/// carries. The kit hands out its accents as ramps plus a set of shade
/// recipes — `colorPrimary[controlColorPlainContent.normalShade!]` is "accent
/// text" — which is the right shape for a widget resolving one control's
/// state and the wrong shape to repeat at three hundred call sites. So the
/// derivations happen once, here, and the app asks for `vars.accentText`.
/// Nothing below invents a colour; every value is a grade of a kit ramp.
library;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, listEquals;
import 'package:flutter/widgets.dart';

import '../widgets/ui.dart'
    show ColorDescriptor, Colors, FontFace, ThemeVariables;
import 'app_theme.dart' show AppThemeName, ProductScope;

// ──────────────────────────────────────────────────────────────────────────────
// Faces
// ──────────────────────────────────────────────────────────────────────────────

/// The type stacks each desktop platform reads best in.
///
/// Every role names its family outright rather than leaning on the platform
/// default: a style with no `fontFamily` takes whatever family the engine
/// happens to default to, and its `fontFamilyFallback` is never consulted for
/// a glyph that default already covers — which is Ahem in a widget test, and
/// on Windows a face with no Chinese in it. The macOS branch promotes the
/// Apple faces the kit already names in its fallback lists.
///
/// [ui] and [display] are handed to the kit as its own `fontUi` and
/// `fontDisplay` (see `designThemeFor`), so its widgets are set in the same
/// faces as everything around them rather than in whatever the engine picks.
abstract final class ProductFonts {
  static bool get _isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get _isLinux => defaultTargetPlatform == TargetPlatform.linux;

  /// The UI face — labels, body copy, controls. Handed to the kit as
  /// `fontUi`, so its own widgets are set in it too.
  static FontFace get ui {
    if (_isWindows) {
      return const FontFace(
        family: 'Segoe UI',
        fallback: ['Microsoft YaHei UI', 'Microsoft YaHei'],
      );
    }
    if (_isLinux) {
      return const FontFace(
        family: 'Noto Sans',
        fallback: ['Noto Sans CJK SC', 'Noto Sans CJK TC'],
      );
    }
    return const FontFace(family: 'SF Pro Text', fallback: ['PingFang SC']);
  }

  /// The display face — headings and numerals, set tighter. The kit's
  /// `fontDisplay`.
  static FontFace get display {
    if (_isWindows) {
      return const FontFace(
        family: 'Segoe UI',
        fallback: ['Microsoft YaHei UI', 'Microsoft YaHei'],
      );
    }
    if (_isLinux) {
      return const FontFace(
        family: 'Noto Sans',
        fallback: ['Noto Sans CJK SC', 'Noto Sans CJK TC'],
      );
    }
    return const FontFace(family: 'SF Pro Display', fallback: ['PingFang SC']);
  }

  /// The face a paragraph of Chinese is set in. The kit has no role for it —
  /// nothing it draws is a paragraph — so it stays here.
  static FontFace get cjk {
    if (_isWindows) {
      return const FontFace(
        family: 'Microsoft YaHei UI',
        fallback: ['Microsoft YaHei', 'Segoe UI'],
      );
    }
    if (_isLinux) {
      return const FontFace(
        family: 'Noto Sans CJK SC',
        fallback: ['Noto Sans CJK TC', 'Noto Sans', 'Droid Sans Fallback'],
      );
    }
    return const FontFace(family: 'PingFang SC', fallback: ['SF Pro Text']);
  }

  /// Numerals in a column, shortcut glyphs, raw JSON. Also the kit's to do
  /// without.
  static FontFace get mono {
    if (_isWindows) {
      return const FontFace(
        family: 'Roboto Mono',
        fallback: ['Cascadia Mono', 'Consolas'],
      );
    }
    if (_isLinux) {
      return const FontFace(
        family: 'Noto Sans Mono',
        fallback: ['Noto Sans Mono CJK SC', 'DejaVu Sans Mono', 'monospace'],
      );
    }
    return const FontFace(family: 'SF Mono', fallback: ['Menlo', 'monospace']);
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Palette
// ──────────────────────────────────────────────────────────────────────────────

/// The colours the product asks for by name that the kit exposes only as ramps.
///
/// Every grade below is the one a kit widget would resolve for the same job:
/// a fill takes the `filled` surface shade, a label takes the `plain` content
/// shade — a label is read, not pressed — and a wash takes the shared
/// `washSurface` / `washEdge` alphas rather than the chip recipe's heavier fill.
extension ProductPalette on ThemeVariables {
  ColorDescriptor get _fill => controlColorFilledSurface;
  ColorDescriptor get _ink => controlColorPlainContent;

  /// Whether the theme marks in the same hue it accents with.
  ///
  /// Bright Light does not: it accents in ink — a text ramp, chosen so a
  /// filled button reads as type — and marks in the acid green it sets on
  /// those fills instead. Every other theme marks in its own accent, Bright
  /// Dark included, where the acid *is* the accent. One rule covers all four:
  /// a theme that accents in ink marks in acid.
  bool get _marksInAccent => colorPrimary != Colors.ink;

  ColorSwatch<int> get _mark => _marksInAccent ? colorPrimary : Colors.acid;

  /// The accent fill — what a filled button paints with.
  Color get accent => colorPrimary[_fill.normalShade!]!;

  Color get accentHover => colorPrimary[_fill.hoveredShade!]!;

  /// Accent *text*, one grade deeper than the fill so it reads on paper.
  Color get accentText => colorPrimary[_ink.normalShade!]!;

  Color get accentTextStrong => colorPrimary[_ink.hoveredShade!]!;

  /// The current row's fill while its window is not key — AppKit's
  /// *unemphasized* selection. The key window's row fills with [accent]; see
  /// `WindowFocus` for where the two are swapped. The ink on it is
  /// `colorContent`.
  ///
  /// The palettes do not share a rule, so each takes the value the React
  /// themes give `--selection-unemphasized`. The Studio pair draws a fixed
  /// neutral — a cool ink at 9% on the light paper, white at 13% on the dark
  /// one — and the Bright pair washes its own ink, 10% light and 13% dark:
  /// denser than a hover, so a blurred window still says which row is current,
  /// and hueless, so it stops competing with the window that is key. The
  /// other four families leave it to the kit and take its subtle surface.
  ///
  /// The family is read off the accent ramp, the same signal [_marksInAccent]
  /// reads — Studio accents in `brand` and the Bright pair in `ink` / `acid`,
  /// ramps no other family uses — and the brightness off which of the paper
  /// and the ink is the lighter.
  Color get selectionUnemphasized {
    final bool dark =
        colorContent.computeLuminance() > colorSurface.computeLuminance();
    if (colorPrimary == Colors.brand) {
      return dark
          ? const Color.fromRGBO(255, 255, 255, 0.13)
          : const Color.fromRGBO(20, 22, 40, 0.09);
    }
    if (colorPrimary == Colors.ink || colorPrimary == Colors.acid) {
      return colorContent.withValues(alpha: dark ? 0.13 : 0.10);
    }
    return colorSurfaceSubtle;
  }

  /// A tint laid over the theme's paper — opaque, not a wash.
  ///
  /// The kit washes its own tinted surfaces and lets whatever is behind them
  /// show through, which is right for a card that always sits on the paper.
  /// The app puts these on two grounds: the workbench pane is the paper, the
  /// mini window's is a raised panel. A translation that changed colour
  /// between the two windows would read as two different states, so the wash
  /// is resolved against the paper once, here.
  Color _tinted(Color hue) =>
      Color.alphaBlend(hue.withValues(alpha: washSurface), colorSurface);

  /// The surface behind a marked passage.
  Color get accentSurface => _tinted(highlight);

  /// The rule at the edge of one.
  ///
  /// Acid is drawn at full strength: it is a light hue, picked to be laid
  /// *on* things, and a wash of it disappears into the paper. The violet the
  /// Studio pair marks with would shout at full strength, so it is washed to
  /// the same edge alpha the kit gives its own tinted surfaces.
  Color get accentHairline =>
      _mark == Colors.acid ? highlight : highlight.withValues(alpha: washEdge);

  /// The two navigation columns, stepping back from the content pane.
  ///
  /// The design draws a workbench window as three surfaces: the content is
  /// the paper, the rail sits back from it and the sidebar further still, each
  /// one nearer the ground the window floats on. The kit's named steps cannot
  /// spell that — the Bright pair gives `colorSurfaceMuted` and
  /// `colorSurfaceSubtle` the same value, and on the dark themes every step
  /// above the surface runs *lighter*, which would bring the columns forward
  /// instead of setting them back. The ladder is the run from the paper to the
  /// canvas, so it is walked directly, and it comes out right way round in all
  /// four themes.
  Color get railSurface => Color.lerp(colorSurface, colorCanvas, 0.3)!;

  Color get sidebarSurface => Color.lerp(colorSurface, colorCanvas, 0.65)!;

  /// The focus ring's colour, at the ring's own grade and alpha.
  Color get accentRing =>
      colorPrimary[focusRingShade]!.withValues(alpha: focusRingAlpha);

  /// The marker hue itself — the dot beside a preferred translation, the rule
  /// down the side of a marked block.
  ///
  /// A theme that marks in its own accent takes the grade its filled controls
  /// already use, so the dot and a primary button agree. A theme that marks in
  /// a ramp of its own takes that ramp's mid grade: the shade descriptors are
  /// tuned for the accent it fills with, not for the hue it marks with.
  Color get highlight => _marksInAccent ? accent : _mark[500]!;

  /// The marker behind a preferred translation, and the ink that sits on it.
  Color get accentMark => highlight.withValues(alpha: 0.24);

  /// On a marked passage the ink is the deep grade of the hue behind it —
  /// unless that hue is not the accent, and the content ink already contrasts
  /// with it.
  Color get accentMarkFg => _marksInAccent ? accentTextStrong : colorContent;

  Color get danger => colorDanger[_fill.normalShade!]!;

  Color get dangerFg => colorDanger[_ink.normalShade!]!;

  Color get dangerDeep => colorDanger[_ink.hoveredShade!]!;

  Color get dangerSurface => _tinted(colorDanger[600]!);

  Color get dangerHairline => colorDanger[600]!.withValues(alpha: washEdge);

  Color get warn => colorWarning[600]!;

  Color get warnStrong => colorWarning[_fill.normalShade!]!;

  Color get warnFg => colorWarning[_ink.normalShade!]!;

  Color get warnSurface => _tinted(colorWarning[600]!);

  Color get warnHairline => colorWarning[600]!.withValues(alpha: washEdge);

  Color get warnMark => colorWarning[600]!.withValues(alpha: 0.24);

  Color get success => colorSuccess[_fill.normalShade!]!;

  Color get successFg => colorSuccess[_ink.normalShade!]!;

  Color get successSurface => _tinted(colorSuccess[600]!);
}

// ──────────────────────────────────────────────────────────────────────────────
// Type
// ──────────────────────────────────────────────────────────────────────────────

/// CSS distributes leading evenly above and below the text box; Flutter's
/// default is proportional. Matching CSS is what keeps a `leading-none` chip
/// the same height in both implementations.
const TextLeadingDistribution _kEvenLeading = TextLeadingDistribution.even;

/// The product's type recipes.
///
/// The kit ships a fixed scale — `bodyMedium`, `labelSmall` and the rest — for
/// its own widgets. The app sets type at sizes the kit never needed (a
/// translation pane, a mono JSON dump, a CJK paragraph), and on platforms whose
/// faces the kit does not name, so it composes its own recipes from the same
/// scale. Sizes follow AppKit's: 11 secondary · 12 small · 13 body ·
/// 15 emphasis · 17 title.
extension ProductTypography on ThemeVariables {
  /// The type sizes the product sets by name.
  static const double caption = 11;
  static const double small = 12;
  static const double body = 13;
  static const double emphasis = 15;
  static const double title = 17;

  TextStyle _face(
    FontFace face, {
    required double fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
    double? letterSpacing,
    List<FontFeature>? fontFeatures,
  }) =>
      TextStyle(
        fontFamily: face.family,
        fontFamilyFallback: face.fallback,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        color: color,
        letterSpacing: letterSpacing,
        fontFeatures: fontFeatures,
        leadingDistribution: _kEvenLeading,
      );

  /// The UI face. `height` maps to CSS `line-height`; pass `1.0` wherever the
  /// React source says `leading-none`.
  TextStyle sansStyle({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
    double? letterSpacing,
  }) {
    return _face(
      fontUi,
      fontSize: fontSize ?? body,
      fontWeight: fontWeight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// The display face — headings, numerals, anything set tight.
  TextStyle displayStyle({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
    double? letterSpacing,
    List<FontFeature>? fontFeatures,
  }) {
    return _face(
      fontDisplay,
      fontSize: fontSize ?? body,
      fontWeight: fontWeight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: fontFeatures,
    );
  }

  /// A paragraph of Chinese.
  TextStyle cjkStyle({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
  }) =>
      _face(
        ProductFonts.cjk,
        fontSize: fontSize ?? body,
        fontWeight: fontWeight,
        height: height,
        color: color,
      );

  TextStyle monoStyle({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
  }) =>
      _face(
        ProductFonts.mono,
        fontSize: fontSize ?? body,
        fontWeight: fontWeight,
        height: height,
        color: color,
      );

  /// The micro section label ("原文 · 第 12 / 38 段", "质量信号"). AppKit sets
  /// these at 11pt semibold in sentence case: no uppercasing, no added
  /// tracking — which is the kit's `labelSmall`, given the product's face.
  TextStyle labelStyle({Color? color}) => _face(
        fontUi,
        fontSize: caption,
        fontWeight: FontWeight.w600,
        height: 1,
        color: color,
      );

  /// Numerals and shortcut glyphs.
  TextStyle numericStyle({double? fontSize, Color? color, double? height}) =>
      displayStyle(
        fontSize: fontSize ?? body,
        fontWeight: FontWeight.w600,
        height: height,
        color: color,
        letterSpacing: -0.01 * (fontSize ?? body),
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 译文正文：CJK face, larger and airier than the source it answers to.
  TextStyle translationStyle({Color? color}) => cjkStyle(
        fontSize: ProductTokens.translationSize,
        fontWeight: FontWeight.w400,
        height: ProductTokens.translationLeading,
        color: color,
      );

  /// 迷你窗口的译文正文：same face and leading, one step smaller.
  TextStyle miniTranslationStyle({Color? color}) => cjkStyle(
        fontSize: ProductTokens.miniTranslationSize,
        fontWeight: FontWeight.w400,
        height: ProductTokens.translationLeading,
        color: color,
      );

  /// 原文：same body size as the surrounding chrome, receded in colour.
  TextStyle sourceStyle({Color? color}) =>
      sansStyle(fontSize: body, height: 1.7, color: color);
}

// ──────────────────────────────────────────────────────────────────────────────
// Tokens
// ──────────────────────────────────────────────────────────────────────────────

/// The tokens the product layer adds to the design system.
///
/// Only [highlightGlow] varies by theme, so one const instance covers the other
/// three palettes. It rides on Material's theme as an extension, which is how
/// `context.product` reaches a widget under no closer scope.
@immutable
class ProductTokens {
  const ProductTokens({this.highlightGlow = const <BoxShadow>[]});

  /// The preferred translation's type — larger and airier than the source it
  /// answers to.
  /// 译文的排版 —— 一套行高，两级字号。1.7 让 CJK 字面透气，又和 13px/1.7 的
  /// 原文同一节奏；此前主窗口 1.75、迷你窗口 1.9 各走各的，同一段译文在两个
  /// 窗口里读起来不像同一种东西。字号按阅读面分两级：主窗口的窗格是读稿的
  /// 地方，比迷你窗口高一级，但 17px 相对 13px 的原文跨了 4px，字号阶梯
  /// 11 → 13 → 17 在中间断了一档，收到 16px 就接得上。
  static const double translationLeading = 1.7;
  static const double translationSize = 16;

  /// 迷你窗口的译文 —— 同一套行高，小一级字号。
  static const double miniTranslationSize = 15;

  /// Provider identity — brand colours, deliberately stable across all four
  /// themes.
  static const Color providerBuiltin = Color(0xFF6B4DFF);
  static const Color providerClaude = Color(0xFFD97757);
  static const Color providerDeepl = Color(0xFF3A7BFD);
  static const Color providerDict = Color(0xFF5B7F6B);

  /// The marker on a preferred translation: the weight of its rule. 2px in
  /// every theme, and a token rather than a literal because the marker's
  /// weight is a scheme decision, not a widget's.
  static const double highlightRule = 2;

  /// macOS window buttons. The same three reds, ambers and greens in every
  /// theme, because that is what the OS draws.
  static const Color trafficClose = Color(0xFFFF5F57);
  static const Color trafficMinimize = Color(0xFFFEBC2E);
  static const Color trafficZoom = Color(0xFF28C840);

  /// The corner of the mini window's backdrop — the one radius the kit has no
  /// step for, because nothing in it is that large.
  static const double backdropRadius = 26;

  /// The floating ball's shadow. Heavier than any of the kit's steps: it is
  /// the only thing in the app that floats over other applications.
  static const List<BoxShadow> ballShadow = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 12, color: Color(0x47000000)),
  ];

  /// Glow behind the marker dot — Studio Dark only. Bright Dark is flat by
  /// design: its canvas is bright enough that a glow would only glare.
  final List<BoxShadow> highlightGlow;

  static const ProductTokens _flat = ProductTokens();

  static const ProductTokens _studioDark = ProductTokens(
    highlightGlow: [BoxShadow(blurRadius: 10, color: Color(0xE67C5CFF))],
  );

  static ProductTokens forTheme(AppThemeName theme) =>
      theme == AppThemeName.studioDark ? _studioDark : _flat;

  ProductTokens copyWith({List<BoxShadow>? highlightGlow}) =>
      ProductTokens(highlightGlow: highlightGlow ?? this.highlightGlow);

  @override
  bool operator ==(Object other) =>
      other is ProductTokens && listEquals(other.highlightGlow, highlightGlow);

  @override
  int get hashCode => Object.hashAll(highlightGlow);
}

extension ProductTokensContext on BuildContext {
  /// The product layer's tokens for the active palette.
  ///
  /// They ride on the [ProductScope] every window installs beside the kit's
  /// theme, so a widget reaches them without a scope of its own.
  ProductTokens get product => ProductScope.of(this);
}
