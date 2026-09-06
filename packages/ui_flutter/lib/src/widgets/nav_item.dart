import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// One row of a navigation column, in a sidebar or a rail.
///
/// The idle row rests in the navigation ink at the quiet weight — a column of
/// full-ink rows would leave the selected one nothing to win by — and its
/// hover is the accent's quiet wash, a preview of the filled selection
/// sitting far below it. A menu item or a table row hovers neutral instead;
/// the difference is what the selected state is.
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.label,
    this.icon,
    this.trailing,
    this.current = false,
    this.size = WidgetSize.medium,
    required this.onPressed,
  });

  final String label;
  final IconData? icon;
  final Widget? trailing;

  /// The current page. It fills rather than washes.
  final bool current;

  /// The sidebar row is the regular control height; the rail row is a step
  /// tighter on both axes.
  final WidgetSize size;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final BorderRadius radius = BorderRadius.circular(vars.radiusSmall);
    final bool enabled = onPressed != null;

    return Pressable(
      onPressed: onPressed,
      enabled: enabled,
      selected: current,
      borderRadius: radius,
      builder: (context, states) {
        final bool hovered = states.contains(WidgetState.hovered);

        Color? surface;
        Color content = vars.colorContentNav;
        if (!enabled) {
          content = vars.controlColorNormalContent.disabledColor!;
        } else if (current) {
          surface =
              vars.colorPrimary[vars.controlColorFilledSurface.normalShade!]!;
          content = vars.colorOnAccent;
        } else if (hovered) {
          surface = vars
              .colorPrimary[vars.controlColorPlainSurface.hoveredShade!]!
              .withValues(alpha: vars.controlColorPlainSurface.hoveredOpacity);
          content = vars.colorContent;
        }

        return AnimatedContainer(
          duration: vars.motionDuration,
          curve: vars.motionEasing,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: size == WidgetSize.small
                ? vars.menuItemPadding
                : vars.spacing2,
            horizontal: vars.spacing25,
          ),
          decoration: BoxDecoration(color: surface, borderRadius: radius),
          child: Row(
            spacing: vars.spacing15,
            children: [
              if (icon != null)
                // The glyph is taller than the label, so it is boxed to the
                // row's line height and allowed to overflow rather than
                // stretching the row.
                SizedBox(
                  width: vars.spacing4,
                  height: vars.labelQuiet.fontSize,
                  child: OverflowBox(
                    maxHeight: vars.spacing4,
                    child: Icon(icon, size: vars.spacing4, color: content),
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: vars.labelQuiet.copyWith(height: 1, color: content),
                ),
              ),
              if (trailing != null)
                IconTheme(
                  data: IconTheme.of(context).copyWith(color: content),
                  child: trailing!,
                ),
            ],
          ),
        );
      },
    );
  }
}
