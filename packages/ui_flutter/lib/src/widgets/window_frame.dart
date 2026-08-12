import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/window_controls.dart';
import 'package:flutter/widgets.dart';

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
    final colors = context.colors;
    final dot = size == TrafficLightsSize.md ? 11.0 : 10.0;
    final gap = size == TrafficLightsSize.md ? 8.0 : 7.0;

    Color fill(TrafficLight button) => switch (button) {
          TrafficLight.close => colors.trafficClose,
          TrafficLight.minimize => colors.trafficMinimize,
          TrafficLight.zoom => colors.trafficZoom,
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

/// The rounded, shadowed app window every desktop screen sits inside.
class WindowFrame extends StatelessWidget {
  const WindowFrame({
    super.key,
    this.width,
    this.height,
    this.unfocused = false,
    this.platform,
    this.degraded = false,
    required this.children,
  });

  /// Fixed pixel width, matching the deck's mockup sizes (840 / 966 / 440).
  final double? width;

  /// Fixed outer height. A real window doesn't grow with its content, so pass
  /// this and let the panes scroll inside. Left out, the window sizes to its
  /// content, with [WindowBody] holding a floor.
  final double? height;

  /// Whether the window has lost key status. AppKit desaturates list selection
  /// when the window is not frontmost, and because the pair lives in the
  /// tokens every row inside picks the change up on its own.
  final bool unfocused;

  /// Which OS draws the window. Shape belongs to the platform, colour to the
  /// theme: Windows clips at DWM's 8px, Linux CSD draws its own 12px, and both
  /// override the theme's window radius. macOS keeps the theme radius.
  final WindowPlatform? platform;

  /// The platform's degraded chrome: square corners on Windows 10 (DWM still
  /// shadows); square, shadowless and hard-edged on Linux without a
  /// compositor. No effect on macOS.
  final bool degraded;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final scoped = unfocused
        ? tokens.copyWith(
            selection: colors.selectionUnemphasized,
            selectionFg: colors.fg,
          )
        : tokens;

    // Platform shape constants; the themable radius only survives on macOS.
    final radius = switch (platform) {
      WindowPlatform.windows => degraded ? 0.0 : 8.0,
      WindowPlatform.linux => degraded ? 0.0 : 12.0,
      _ => tokens.radii.window,
    };
    final hardEdged = platform == WindowPlatform.linux && degraded;

    return DesignTheme(
      tokens: scoped,
      child: _WindowBodyFloor(
        // A fixed height owns the layout, so the body's content floor steps
        // aside and lets the panes scroll instead.
        floor: height == null ? 452 : 0,
        child: Container(
          width: width ?? tokens.metrics.windowWidth,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.window,
            border: Border.all(
              color: hardEdged ? colors.hairlineStrong : colors.hairline,
              width: context.hairlineWidth,
            ),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: hardEdged ? null : tokens.shadows.window,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
            children: children,
          ),
        ),
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
    final tokens = context.tokens;
    final colors = tokens.colors;
    final isMac = platform == null || platform == WindowPlatform.macos;

    return Container(
      height: tokens.metrics.titlebarHeight,
      // Windows caption strips run to the window's edge and the band's full
      // height, so the padding is cancelled on that side.
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: platform == WindowPlatform.windows ? 0 : 16,
      ),
      decoration: BoxDecoration(
        color: colors.chrome,
        border: Border(
          bottom: BorderSide(
            color: colors.hairline,
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
              style: tokens.typography.displayStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: -0.13,
                color: colors.fg,
              ),
              child: title!,
            ),
            const SizedBox(width: 14),
          ],
          if (subtitle != null) ...[
            DefaultTextStyle(
              style: tokens.typography.sansStyle(
                fontSize: 12,
                color: colors.fgSubtle,
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
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colors.chrome,
        border: Border(
          top: BorderSide(color: colors.hairline, width: context.hairlineWidth),
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
