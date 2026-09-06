/// The window the app draws for itself.
///
/// The kit has no window chrome: a component library ships controls, and a
/// titlebar that answers `WM_NCHITTEST`, paints DWM's caption strips and
/// carries macOS traffic lights is the application's own business. It is built
/// from the kit's tokens throughout — the titlebar metric, the chrome surface,
/// the hairline — so it stays in step with everything inside it.
library;

import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductTokens, ProductTypography;
import 'ui.dart' show Pressable, ThemeDataBuildContextProps;

/// Which OS draws the window. Shape belongs to the platform the way it does on
/// iOS: the theme keeps its colours everywhere, but Windows clips corners at
/// DWM's 8px and Linux CSD draws its own 12px, so both pin the radius that the
/// theme would otherwise set.
enum WindowPlatform { macos, windows, linux }

/// The buttons a Windows/Linux control cluster carries, mirroring
/// [TrafficLights.buttons] on the macOS side.
enum CaptionButton { minimize, maximize, close }

const List<CaptionButton> kDefaultCaptionButtons = [
  CaptionButton.minimize,
  CaptionButton.maximize,
  CaptionButton.close,
];

/// DWM paints the hovered close strip in the system red — a literal constant,
/// not a theme colour, because every Windows theme shows the same red.
const Color _kWindowsCloseHover = Color(0xFFC42B1C);

String _defaultLabel(CaptionButton button) => switch (button) {
      CaptionButton.minimize => '最小化',
      CaptionButton.maximize => '最大化',
      CaptionButton.close => '关闭',
    };

/// Windows caption buttons: 46px strips flush with the window's top-right
/// corner. Hover paints the whole strip — close in the system's red — rather
/// than tinting the glyph, which is how DWM draws them.
///
/// The React component is decorative, like `TrafficLights`; this port also
/// accepts [onPressed] because on the Flutter side the cluster sits in a real
/// window and has to answer for it. Left null, the strips stay inert, matching
/// the deck.
///
/// The strips stretch to the band they sit in, so they expect a bounded
/// height — the titlebar's.
class WindowsCaptionControls extends StatelessWidget {
  const WindowsCaptionControls({
    super.key,
    this.buttons = kDefaultCaptionButtons,
    this.onPressed,
  });

  /// Which buttons the window actually carries.
  final List<CaptionButton> buttons;

  /// Real-window wiring; null keeps the cluster decorative.
  final ValueChanged<CaptionButton>? onPressed;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final button in buttons)
          Pressable(
            onPressed: onPressed == null ? null : () => onPressed!(button),
            // Native caption buttons never take the pointer cursor or a focus
            // ring — they belong to the frame, not to the page's tab order.
            cursor: SystemMouseCursors.basic,
            showFocusRing: false,
            semanticsLabel: _defaultLabel(button),
            builder: (context, states) {
              final isClose = button == CaptionButton.close;
              final foreground = states.contains(WidgetState.hovered)
                  ? (isClose ? const Color(0xFFFFFFFF) : vars.colorContent)
                  : vars.colorContentMuted;

              return AnimatedContainer(
                duration: context.vars.motionDuration,
                width: 46,
                height: double.infinity,
                alignment: Alignment.center,
                color: states.contains(WidgetState.hovered)
                    ? (isClose ? _kWindowsCloseHover : vars.colorSurfaceSubtle)
                    : null,
                // `transition-colors` covers the glyph as well as the strip
                // behind it.
                child: TweenAnimationBuilder<Color?>(
                  duration: context.vars.motionDuration,
                  tween: ColorTween(end: foreground),
                  builder: (context, color, _) => CustomPaint(
                    size: const Size.square(10),
                    painter: _WindowsGlyphPainter(button, color!),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Adwaita-style CSD buttons: circular pads inset from the corner, hover
/// brightening the pad. GNOME's stock config shows close alone; the trio is
/// for environments configured to carry all three.
class LinuxWindowControls extends StatelessWidget {
  const LinuxWindowControls({
    super.key,
    this.buttons = kDefaultCaptionButtons,
    this.onPressed,
  });

  /// Which buttons the window actually carries.
  final List<CaptionButton> buttons;

  /// Real-window wiring; null keeps the pads decorative.
  final ValueChanged<CaptionButton>? onPressed;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) const SizedBox(width: 13),
          Pressable(
            onPressed: onPressed == null ? null : () => onPressed!(buttons[i]),
            cursor: SystemMouseCursors.basic,
            showFocusRing: false,
            semanticsLabel: _defaultLabel(buttons[i]),
            builder: (context, states) => AnimatedContainer(
              duration: context.vars.motionDuration,
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: states.contains(WidgetState.hovered)
                    ? vars.colorSurfaceSunken
                    : vars.colorSurfaceInset,
                shape: BoxShape.circle,
              ),
              child: CustomPaint(
                size: const Size.square(8),
                painter: _LinuxGlyphPainter(buttons[i], vars.colorContent),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Segoe Fluent-style caption glyphs: a 10×10 box with 1px strokes.
class _WindowsGlyphPainter extends CustomPainter {
  const _WindowsGlyphPainter(this.button, this.color);

  final CaptionButton button;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color;

    switch (button) {
      case CaptionButton.minimize:
        canvas.drawLine(const Offset(0.5, 5), const Offset(9.5, 5), paint);
      case CaptionButton.maximize:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTRB(0.5, 0.5, 9.5, 9.5),
            const Radius.circular(2),
          ),
          paint,
        );
      case CaptionButton.close:
        canvas.drawLine(const Offset(0.5, 0.5), const Offset(9.5, 9.5), paint);
        canvas.drawLine(const Offset(9.5, 0.5), const Offset(0.5, 9.5), paint);
    }
  }

  @override
  bool shouldRepaint(_WindowsGlyphPainter oldDelegate) =>
      button != oldDelegate.button || color != oldDelegate.color;
}

/// GNOME symbolic glyphs: an 8×8 box, round caps, minimise is a floor line.
class _LinuxGlyphPainter extends CustomPainter {
  const _LinuxGlyphPainter(this.button, this.color);

  final CaptionButton button;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = color;

    switch (button) {
      case CaptionButton.minimize:
        canvas.drawLine(const Offset(0.5, 7.5), const Offset(7.5, 7.5), paint);
      case CaptionButton.maximize:
        canvas.drawRect(const Rect.fromLTRB(0.5, 0.5, 7.5, 7.5), paint);
      case CaptionButton.close:
        canvas.drawLine(const Offset(0.5, 0.5), const Offset(7.5, 7.5), paint);
        canvas.drawLine(const Offset(7.5, 0.5), const Offset(0.5, 7.5), paint);
    }
  }

  @override
  bool shouldRepaint(_LinuxGlyphPainter oldDelegate) =>
      button != oldDelegate.button || color != oldDelegate.color;
}

enum TrafficLightsSize { sm, md }

enum TrafficLight { close, minimize, zoom }

/// macOS window buttons. Decorative — they carry no behaviour in the design.
class TrafficLights extends StatelessWidget {
  const TrafficLights({
    super.key,
    this.size = TrafficLightsSize.md,
    this.buttons = const [
      TrafficLight.close,
      TrafficLight.minimize,
      TrafficLight.zoom,
    ],
  });

  final TrafficLightsSize size;

  /// Which buttons the window actually carries. A window that can neither be
  /// minimised nor zoomed — the setup assistant, an About panel — is drawn with
  /// the close button alone.
  final List<TrafficLight> buttons;

  @override
  Widget build(BuildContext context) {
    final dot = size == TrafficLightsSize.md ? 11.0 : 10.0;
    final gap = size == TrafficLightsSize.md ? 8.0 : 7.0;

    Color fill(TrafficLight button) => switch (button) {
          TrafficLight.close => ProductTokens.trafficClose,
          TrafficLight.minimize => ProductTokens.trafficMinimize,
          TrafficLight.zoom => ProductTokens.trafficZoom,
        };

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < buttons.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Container(
              width: dot,
              height: dot,
              decoration: BoxDecoration(
                color: fill(buttons[i]),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Carries `--bt-body-floor` down to [WindowBody].
class _WindowBodyFloor extends InheritedWidget {
  const _WindowBodyFloor({required this.floor, required super.child});

  final double floor;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WindowBodyFloor>()?.floor ??
      452;

  @override
  bool updateShouldNotify(_WindowBodyFloor oldWidget) =>
      floor != oldWidget.floor;
}

/// The toolbar band. Its height is fixed by the titlebar metric rather than
/// derived from its contents: a view that parks a segmented control here must
/// not sit taller than one showing only a title, and the band has to line up
/// with the sidebar's header strip.
class WindowTitlebar extends StatelessWidget {
  const WindowTitlebar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.lights = true,
    this.platform,
    this.buttons = kDefaultCaptionButtons,
    this.onCaptionPressed,
    this.children = const [],
  });

  final Widget? title;

  /// De-emphasised context after the title — 设置 / 术语库 / file name.
  final Widget? subtitle;

  /// Control parked immediately left of the title, after the traffic lights —
  /// where AppKit puts the sidebar toggle once the sidebar is collapsed.
  final Widget? leading;
  final bool lights;

  /// Swaps the window-control cluster: macOS keeps the traffic lights on the
  /// left, Windows parks caption strips flush with the top-right corner, Linux
  /// insets Adwaita pads on the right. The band itself — height, title on the
  /// left, toolbar content — stays identical across platforms.
  final WindowPlatform? platform;

  /// Which buttons the Windows/Linux cluster carries.
  final List<CaptionButton> buttons;

  /// Real-window wiring for the Windows/Linux cluster; left null the cluster
  /// stays decorative, like the deck's.
  final ValueChanged<CaptionButton>? onCaptionPressed;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final isMac = platform == null || platform == WindowPlatform.macos;

    return Container(
      height: vars.frameTitlebarSize,
      // Windows caption strips run to the window's edge and the band's full
      // height, so the padding is cancelled on that side.
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: platform == WindowPlatform.windows ? 0 : 16,
      ),
      decoration: BoxDecoration(
        color: vars.colorSurfaceChrome,
        border: Border(
          bottom: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isMac && lights) ...[
            const TrafficLights(),
            const SizedBox(width: 14),
          ],
          if (leading != null) ...[leading!, const SizedBox(width: 14)],
          if (title != null) ...[
            DefaultTextStyle(
              style: vars.displayStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: -0.13,
                color: vars.colorContent,
              ),
              child: title!,
            ),
            const SizedBox(width: 14),
          ],
          if (subtitle != null) ...[
            DefaultTextStyle(
              style: vars.sansStyle(
                fontSize: 12,
                color: vars.colorContentSubtle,
              ),
              child: subtitle!,
            ),
            const SizedBox(width: 14),
          ],
          if (isMac)
            ...children
          else ...[
            // Toolbar content resolves its own trailing Spacer inside this
            // group, so right-aligned controls stop at the caption cluster
            // instead of splitting the free space with it.
            Expanded(child: Row(children: children)),
            const SizedBox(width: 14),
            if (platform == WindowPlatform.windows)
              WindowsCaptionControls(
                buttons: buttons,
                onPressed: onCaptionPressed,
              )
            else
              LinuxWindowControls(
                buttons: buttons,
                onPressed: onCaptionPressed,
              ),
          ],
        ],
      ),
    );
  }
}

/// The horizontal band below the titlebar: sidebar, rail, main pane, aside.
/// It clips rather than grows, so with a fixed-height [WindowFrame] the
/// panes scroll internally. The floor keeps the window from collapsing on the
/// sparser views when no height is set.
class WindowBody extends StatelessWidget {
  const WindowBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final floor = _WindowBodyFloor.of(context);
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: floor),
        child: ClipRect(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// The pane beside a full-height sidebar. It owns its own toolbar, so the
/// sidebar can run from the window's top edge to its bottom the way Finder,
/// Mail and System Settings draw it.
class WindowMain extends StatelessWidget {
  const WindowMain({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Expanded(
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      );
}

/// The row band under a [WindowMain] toolbar. Views render a rail, a main
/// column and an aside as siblings, so this stays a row.
class WindowContent extends StatelessWidget {
  const WindowContent({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Expanded(
        child: ClipRect(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      );
}

/// Footer strip inside a window or dialog.
class WindowFooter extends StatelessWidget {
  const WindowFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: vars.colorSurfaceChrome,
        border: Border(
          top:
              BorderSide(color: vars.colorBorder, width: context.hairlineWidth),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            children[i],
          ],
        ],
      ),
    );
  }
}
