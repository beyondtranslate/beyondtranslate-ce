import 'package:flutter/widgets.dart';

import 'app_tooltip.dart' show AppTooltip;
import 'ui.dart'
    show
        IconButton,
        IconButtonTint,
        IconButtonVariant,
        ThemeDataBuildContextProps;

/// The design system's 24pt flat toolbar affordance, taking an [IconData]
/// instead of a widget, wearing a hover label, and adding the optional
/// rotation the mini translator's pin needs.
///
/// Everything visual — geometry, hover wash, disabled dimming — comes from the
/// package's [IconButton], so this stays a convenience adapter rather than a
/// second implementation. A glyph that latches stays that same button: held on,
/// only its tint turns to the accent. A row of these has to read as chrome
/// until touched, and the kit's `Toggle` draws its held state as a tinted chip
/// — a filled box in the titlebar for a state as ordinary as "pinned". React's
/// product `IconButton` settled on the accent glyph for the same reason.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    this.tooltip,
    required this.onPressed,
    this.selected,
    this.iconTurns = 0,
    this.iconSize = 14,
  });

  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;

  /// Null for a button with no held state at all — not `false`, which would
  /// say it has one and is currently off, and would announce a toggle to
  /// assistive tech where there is only a verb.
  final bool? selected;

  /// The deck sizes the glyph per call site: 18 in the mini-window toolbar,
  /// 16 in the sidebar header.
  final double iconSize;

  /// Animated rotation of the glyph, in turns — the pin lies at -45° until
  /// pinned, matching the deck.
  final double iconTurns;

  @override
  Widget build(BuildContext context) {
    // The kit's icon slot is the glyph itself, so the turn is applied to the
    // button rather than to a widget handed in as its icon.
    Widget button = AnimatedRotation(
      turns: iconTurns,
      duration: context.vars.motionDuration,
      child: IconButton(
        semanticsLabel: tooltip ?? '',
        iconSize: iconSize,
        // Plain either way, so the ground stays transparent. Neutral is the
        // kit's quiet toolbar chrome; primary leaves the recipes to ink the
        // glyph in the accent. Driven from outside: what the pin is pressed
        // against is the window's own always-on-top, not a bit the button
        // keeps.
        variant: IconButtonVariant.plain,
        tint:
            selected == true ? IconButtonTint.primary : IconButtonTint.neutral,
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
      ),
    );

    // The colour alone cannot say the button is held, so the state is
    // announced as well. Merged, so it lands on the button's own node rather
    // than on whichever ancestor a loose annotation would fold into.
    if (selected != null) {
      button = MergeSemantics(
        child: Semantics(toggled: selected, child: button),
      );
    }

    if (tooltip == null) return button;
    return AppTooltip(message: tooltip!, child: button);
  }
}
