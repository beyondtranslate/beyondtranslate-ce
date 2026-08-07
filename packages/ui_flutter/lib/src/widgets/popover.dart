import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

/// The menu-bar popover shell: a padded tray whose contents sit on an inner
/// card, so the tray colour reads as a frame around the result.
class PopoverWindow extends StatelessWidget {
  const PopoverWindow({super.key, this.width, this.child});

  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      width: width ?? tokens.metrics.miniWidth,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.tray,
        border: Border.all(
          color: colors.hairline,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.popover),
        boxShadow: tokens.shadows.popover,
      ),
      child: child,
    );
  }
}

/// The inner card of the mini window (and of the extension popup). `panel` is
/// its own token rather than `window`, because which of tray/panel is the
/// brighter surface flips between the Studio and Bright palettes.
class PopoverPanel extends StatelessWidget {
  const PopoverPanel({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border.all(
          color: colors.hairline,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.card),
      ),
      child: child,
    );
  }
}
