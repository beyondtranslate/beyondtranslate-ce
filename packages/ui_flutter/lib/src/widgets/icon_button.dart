import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// The flat 24px chrome button the mini-window toolbars use — pin, capture,
/// clipboard, settings. AppKit style: no box by default, an accent read when
/// [active], and a soft hover wash so the row still feels tappable.
///
/// The glyph is a plain [Icon] (usually a `FluentIcons.*_20_regular`, the same
/// set the React kit draws via `@fluentui/react-icons`); its colour is fed
/// through [IconTheme], so pass it without an explicit colour.
class IconButton extends StatelessWidget {
  const IconButton({
    super.key,
    required this.label,
    required this.icon,
    this.active = false,
    this.iconSize = 14,
    this.onPressed,
  });

  /// Accessible name — the `aria-label` of the React component.
  final String label;

  /// Persistent on-state — the pin button, for instance.
  final bool active;
  final Widget icon;

  /// Glyph size, fed through [IconTheme]. The React kit sets it per call site
  /// on the `<Icon>` child — 18 in the mini-window toolbar, 16 in the sidebar
  /// header, 13 on the document zoom stepper.
  final double iconSize;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.controlSm);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      semanticsLabel: label,
      builder: (context, state) {
        final foreground = active
            ? colors.accentText
            : (state.hovered ? colors.fg : colors.fgMuted);

        return Opacity(
          // The deck dims a disabled affordance rather than recolouring it —
          // `disabled:opacity-35`, with the hover wash withheld.
          opacity: onPressed == null ? 0.35 : 1,
          child: AnimatedContainer(
            duration: kTransitionDuration,
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: !active && state.hovered ? colors.subtle : null,
              borderRadius: radius,
            ),
            child: IconTheme(
              data: IconThemeData(color: foreground, size: iconSize),
              child: icon,
            ),
          ),
        );
      },
    );
  }
}
