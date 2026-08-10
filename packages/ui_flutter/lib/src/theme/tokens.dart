import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// BeyondTranslate design tokens — the Dart mirror of `tokens.css`.
///
/// Every visual decision a widget makes reads from a token, so an
/// alternative palette (Studio Dark, Bright Light, Bright Dark) is a pure
/// token swap: no widget needs to know which theme is active.
///
/// The default value of every field is the **Studio Light** value. That
/// mirrors the CSS exactly: `:root` declares the baseline and each
/// `[data-theme=…]` block only overrides the handful of tokens it changes, so
/// a theme here is likewise written as "the baseline, plus these overrides".
@immutable
class DesignColors {
  const DesignColors({
    // Presentation backdrop (the plate a window floats on in the design deck)
    this.canvas = const Color(0xFFEEECF6),
    // Surfaces, from the outside in
    this.window = const Color(0xFFFFFFFF),
    this.chrome = const Color(0xFFF7F7FA),
    this.sidebar = const Color(0xFFF4F4F8),
    this.rail = const Color(0xFFFBFBFD),
    this.raised = const Color(0xFFFFFFFF),
    this.card = const Color(0xFFF7F7FA),
    this.subtle = const Color(0xFFF5F5F9),
    this.inset = const Color(0xFFF0F0F5),
    this.control = const Color(0xFFECECF3),
    this.controlHover = const Color(0xFFE5E5EE),
    this.track = const Color(0xFFE3E3EC),

    /// Outline of unselected radios, checkboxes and idle step markers.
    this.controlOutline = const Color(0xFFCFD2DE),

    /// The lifted segment of a segmented control — always lighter than the
    /// track.
    this.controlRaised = const Color(0xFFFFFFFF),

    /// Selection fill when the window is not key (AppKit's unemphasized
    /// state). `rgba(20, 22, 40, 0.09)`
    this.selectionUnemphasized = const Color(0x17141628),

    // The menu-bar popover: a tray with a raised panel inside. Which of the
    // two is the brighter one differs per theme, so they get their own tokens.
    this.tray = const Color(0xFFF7F7FA),
    this.panel = const Color(0xFFFFFFFF),

    // Accent-tinted surfaces
    this.accentSurface = const Color(0xFFF4F1FE),
    this.accentSurfaceAlt = const Color(0xFFF0EEFE),

    // Hairlines
    this.hairline = const Color(0x12141628), // rgba(20, 22, 40, 0.07)
    this.hairlineStrong = const Color(0x1A141628), // rgba(20, 22, 40, 0.1)
    this.hairlineSoft = const Color(0x0F141628), // rgba(20, 22, 40, 0.06)
    this.accentHairline = const Color(0x336B4DFF), // rgba(107, 77, 255, 0.2)
    // Foreground ramp
    this.fg = const Color(0xFF12142A),
    this.fgSecondary = const Color(0xFF3C405C),
    this.fgTertiary = const Color(0xFF565B78),
    this.fgMuted = const Color(0xFF7A7F99),
    this.fgSubtle = const Color(0xFF8C92AA),
    this.fgFaint = const Color(0xFFA2A7BD),
    this.fgNav = const Color(0xFF4A4F6B),
    this.fgControl = const Color(0xFF2B2F4A),
    this.onAccent = const Color(0xFFFFFFFF),

    // Inverted chip — the dark capsule of the expanded floating ball
    this.inverse = const Color(0xFF12142A),
    this.inverseFg = const Color(0xFFFFFFFF),

    // Accent. `accent` paints primary actions, `highlight` paints the markers
    // that point at the preferred translation (dot, rule, left border). Here
    // they are the same violet; in the Bright themes they deliberately differ.
    this.accent = const Color(0xFF6B4DFF),
    this.accentHover = const Color(0xFF5B3FE0),
    this.accentText = const Color(0xFF5B3FE0),
    this.accentTextStrong = const Color(0xFF4C33CC),
    this.highlight = const Color(0xFF6B4DFF),
    this.accentRing = const Color(0x246B4DFF), // rgba(107, 77, 255, 0.14)
    /// Keyboard focus: a ring hugging the control, no gap.
    /// `rgba(107, 77, 255, 0.45)`
    this.focusRing = const Color(0x736B4DFF),
    this.accentMark = const Color(0x296B4DFF), // rgba(107, 77, 255, 0.16)
    this.accentMarkFg = const Color(0xFF4C33CC),

    // Semantics
    this.success = const Color(0xFF1F9D5E),
    this.successSurface = const Color(0x241F9D5E), // rgba(31, 157, 94, 0.14)
    this.warn = const Color(0xFFE0912A),
    this.warnStrong = const Color(0xFFB96F12),
    this.warnFg = const Color(0xFF8A5210),
    this.warnSurface = const Color(0xFFFDF6EA),
    this.warnHairline = const Color(0x4CE0912A), // rgba(224, 145, 42, 0.3)
    this.warnMark = const Color(0xFFFFE6C7),
    this.danger = const Color(0xFFD64040),
    this.dangerFg = const Color(0xFFC4342F),
    this.dangerDeep = const Color(0xFF7E1F1C),
    this.dangerSurface = const Color(0xFFFDF2F2),
    this.dangerHairline = const Color(0x57D64040), // rgba(214, 64, 64, 0.34)
    // macOS traffic lights
    this.trafficClose = const Color(0xFFFF5F57),
    this.trafficMinimize = const Color(0xFFFEBC2E),
    this.trafficZoom = const Color(0xFF28C840),
  });

  final Color canvas;
  final Color window;
  final Color chrome;
  final Color sidebar;
  final Color rail;
  final Color raised;
  final Color card;
  final Color subtle;
  final Color inset;
  final Color control;
  final Color controlHover;
  final Color track;
  final Color controlOutline;
  final Color controlRaised;
  final Color selectionUnemphasized;
  final Color tray;
  final Color panel;
  final Color accentSurface;
  final Color accentSurfaceAlt;
  final Color hairline;
  final Color hairlineStrong;
  final Color hairlineSoft;
  final Color accentHairline;
  final Color fg;
  final Color fgSecondary;
  final Color fgTertiary;
  final Color fgMuted;
  final Color fgSubtle;
  final Color fgFaint;
  final Color fgNav;
  final Color fgControl;
  final Color onAccent;
  final Color inverse;
  final Color inverseFg;
  final Color accent;
  final Color accentHover;
  final Color accentText;
  final Color accentTextStrong;
  final Color highlight;
  final Color accentRing;
  final Color focusRing;
  final Color accentMark;
  final Color accentMarkFg;
  final Color success;
  final Color successSurface;
  final Color warn;
  final Color warnStrong;
  final Color warnFg;
  final Color warnSurface;
  final Color warnHairline;
  final Color warnMark;
  final Color danger;
  final Color dangerFg;
  final Color dangerDeep;
  final Color dangerSurface;
  final Color dangerHairline;
  final Color trafficClose;
  final Color trafficMinimize;
  final Color trafficZoom;
}

/// Radii. `control` and `box` are separate axes on purpose: `control` is for
/// things whose height defines the curve — buttons, the language pair,
/// segments, search fields — and a theme may legitimately make it a full pill.
/// `box` is for containers that hold stacked content, where a pill would turn
/// into a lozenge as the box grows.
@immutable
class DesignRadii {
  const DesignRadii({
    this.backdrop = 26,
    this.window = 18,
    this.popover = 16,
    this.card = 12,
    this.box = 12,
    this.control = 10,
    this.controlSm = 8,
    this.chip = 7,
    this.avatar = 8,
    this.pill = 999,
  });

  final double backdrop;
  final double window;
  final double popover;
  final double card;
  final double box;
  final double control;
  final double controlSm;
  final double chip;
  final double avatar;
  final double pill;
}

/// Fixed layout metrics. A real toolbar is a fixed band: it does not grow when
/// a view happens to put a segmented control in it, and it has to match the
/// sidebar's header strip exactly or the separator under them steps.
@immutable
class DesignMetrics {
  const DesignMetrics({
    this.titlebarHeight = 52,
    this.sidebarWidth = 172,
    this.railWidth = 150,
    this.asideWidth = 214,
    this.windowWidth = 840,
    this.miniWidth = 396,
    this.navGap = 3,
  });

  final double titlebarHeight;
  final double sidebarWidth;
  final double railWidth;
  final double asideWidth;
  final double windowWidth;
  final double miniWidth;
  final double navGap;
}

/// A typeface role: a family plus its fallbacks. `family == null` means the
/// platform's system UI font, which is what `-apple-system` resolves to.
@immutable
class DesignFont {
  const DesignFont({this.family, this.fallback = const []});

  final String? family;
  final List<String> fallback;
}

/// A native app has one typeface, not a display/text pair. The roles stay
/// separate so widgets keep their intent, but they resolve to the system
/// face. AppKit's practical scale: 11 secondary · 13 body · 15 emphasis ·
/// 17 title.
@immutable
class DesignTypography {
  const DesignTypography({
    this.display = const DesignFont(fallback: ['PingFang SC']),
    this.sans = const DesignFont(fallback: ['PingFang SC']),
    this.cjk = const DesignFont(family: 'PingFang SC'),
    this.label = const DesignFont(),
    this.mono = const DesignFont(
      family: 'SF Mono',
      fallback: ['Menlo', 'monospace'],
    ),
    this.caption = 11,
    this.small = 12,
    this.body = 13,
    this.emphasis = 15,
    this.title = 17,
  });

  final DesignFont display;
  final DesignFont sans;
  final DesignFont cjk;
  final DesignFont label;
  final DesignFont mono;
  final double caption;
  final double small;
  final double body;
  final double emphasis;
  final double title;
}

/// Window shadows are tight and neutral, and controls carry no coloured glow —
/// AppKit buttons are flat. `accent` survives as a hairline lift so the primary
/// action still separates from a tinted surface.
@immutable
class DesignShadows {
  const DesignShadows({
    this.window = const [
      BoxShadow(
        offset: Offset(0, 12),
        blurRadius: 32,
        color: Color(0x3D000000),
      ),
    ],
    this.popover = const [
      BoxShadow(
        offset: Offset(0, 10),
        blurRadius: 30,
        color: Color(0x38000000),
      ),
    ],
    this.float = const [
      BoxShadow(offset: Offset(0, 8), blurRadius: 24, color: Color(0x33000000)),
    ],
    this.lift = const [
      BoxShadow(offset: Offset(0, 4), blurRadius: 12, color: Color(0x24000000)),
    ],
    this.accent = const [
      BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1A000000)),
    ],
    this.accentLg = const [
      BoxShadow(offset: Offset(0, 1), blurRadius: 3, color: Color(0x1F000000)),
    ],
    this.ball = const [
      BoxShadow(offset: Offset(0, 4), blurRadius: 12, color: Color(0x47000000)),
    ],
  });

  final List<BoxShadow> window;
  final List<BoxShadow> popover;
  final List<BoxShadow> float;
  final List<BoxShadow> lift;
  final List<BoxShadow> accent;
  final List<BoxShadow> accentLg;
  final List<BoxShadow> ball;
}

/// Builds the Flutter equivalent of a CSS `linear-gradient(<deg>, …)`.
///
/// CSS measures the angle clockwise from "to top", so the direction vector in
/// screen space (x right, y down) is `(sin θ, -cos θ)`.
LinearGradient linearGradientFromAngle(
  double degrees,
  List<Color> colors, [
  List<double>? stops,
]) {
  final radians = degrees * math.pi / 180;
  final dx = math.sin(radians);
  final dy = -math.cos(radians);
  return LinearGradient(
    begin: Alignment(-dx, -dy),
    end: Alignment(dx, dy),
    colors: colors,
    stops: stops,
  );
}

/// The complete token set for one theme.
@immutable
class DesignTokens {
  const DesignTokens({
    required this.brightness,
    required this.backdrop,
    required this.progressGradient,
    this.colors = const DesignColors(),
    this.radii = const DesignRadii(),
    this.metrics = const DesignMetrics(),
    this.typography = const DesignTypography(),
    this.shadows = const DesignShadows(),
    Color? selection,
    Color? selectionFg,
  })  : _selection = selection,
        _selectionFg = selectionFg;

  final Brightness brightness;
  final DesignColors colors;
  final DesignRadii radii;
  final DesignMetrics metrics;
  final DesignTypography typography;
  final DesignShadows shadows;
  final Gradient backdrop;
  final Gradient progressGradient;

  final Color? _selection;
  final Color? _selectionFg;

  /// The active selection pair. It resolves to the accent while the window is
  /// key; [WindowFrame] swaps it for the unemphasized pair when the window
  /// loses focus, so every list row picks the change up without anyone
  /// threading state down.
  Color get selection => _selection ?? colors.accent;

  Color get selectionFg => _selectionFg ?? colors.onAccent;

  DesignTokens copyWith({
    Color? selection,
    Color? selectionFg,
    DesignTypography? typography,
  }) =>
      DesignTokens(
        brightness: brightness,
        colors: colors,
        radii: radii,
        metrics: metrics,
        typography: typography ?? this.typography,
        shadows: shadows,
        backdrop: backdrop,
        progressGradient: progressGradient,
        selection: selection ?? _selection,
        selectionFg: selectionFg ?? _selectionFg,
      );
}
