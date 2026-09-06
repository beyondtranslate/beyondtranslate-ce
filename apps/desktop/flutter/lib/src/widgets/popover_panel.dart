/// The mini window's inner card.
///
/// The floating translator is a menu-bar popover: a tray with a card inside
/// it, which is a window shape rather than a control, so the app draws it. The
/// surfaces and the radius are the kit's.
library;

import 'package:flutter/widgets.dart';

import 'ui.dart' show ThemeDataBuildContextProps;

/// The inner card of the mini window (and of the extension popup). `panel` is
/// its own token rather than `window`, because which of tray/panel is the
/// brighter surface flips between the Studio and Bright palettes.
class PopoverPanel extends StatelessWidget {
  const PopoverPanel({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: vars.colorSurfaceRaised,
        border: Border.all(
          color: vars.colorBorder,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(vars.radiusLarge),
      ),
      child: child,
    );
  }
}
