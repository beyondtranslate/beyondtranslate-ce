import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

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
    final colors = context.colors;

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
            builder: (context, state) {
              final isClose = button == CaptionButton.close;
              final foreground = state.hovered
                  ? (isClose ? const Color(0xFFFFFFFF) : colors.fg)
                  : colors.fgMuted;

              return AnimatedContainer(
                duration: kTransitionDuration,
                width: 46,
                height: double.infinity,
                alignment: Alignment.center,
                color: state.hovered
                    ? (isClose ? _kWindowsCloseHover : colors.subtle)
                    : null,
                // `transition-colors` covers the glyph as well as the strip
                // behind it.
                child: TweenAnimationBuilder<Color?>(
                  duration: kTransitionDuration,
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
    final colors = context.colors;

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
            builder: (context, state) => AnimatedContainer(
              duration: kTransitionDuration,
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: state.hovered ? colors.controlHover : colors.control,
                shape: BoxShape.circle,
              ),
              child: CustomPaint(
                size: const Size.square(8),
                painter: _LinuxGlyphPainter(buttons[i], colors.fgControl),
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
