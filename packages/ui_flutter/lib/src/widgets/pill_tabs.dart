import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// One filter pill.
@immutable
class PillTabItem<T> {
  const PillTabItem({
    required this.value,
    required this.label,
    this.count,
    this.enabled = true,
  });

  final T value;
  final String label;

  /// Runs on in the label's own ink — "收藏 64" reads as one label, not a
  /// label wearing a badge.
  final int? count;

  final bool enabled;
}

/// Free-standing filter pills.
///
/// Unlike a segmented control there is no track: each pill stands on the page,
/// so an unselected one needs its own fill to be a target at all — the inset
/// step, one deeper than the cards around it, with the groove as its hover.
///
/// One size, drawn tight: the tiny control height on the caption face. The
/// active pill jumps two weight steps as well as filling, because at this size
/// the fill alone can vanish under a thumb.
class PillTabs<T> extends StatelessWidget {
  const PillTabs({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<PillTabItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: vars.spacing2,
      children: [
        for (final PillTabItem<T> item in items)
          _Pill<T>(
            item: item,
            selected: item.value == value,
            onPressed: onChanged == null || !item.enabled
                ? null
                : () => onChanged!(item.value),
          ),
      ],
    );
  }
}

class _Pill<T> extends StatelessWidget {
  const _Pill({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final PillTabItem<T> item;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final BorderRadius radius = BorderRadius.circular(vars.radiusFull);

    return Pressable(
      onPressed: onPressed,
      enabled: item.enabled,
      selected: selected,
      borderRadius: radius,
      builder: (context, states) {
        final bool hovered = states.contains(WidgetState.hovered);

        final Color surface = selected
            ? vars.colorPrimary[vars.controlColorFilledSurface.normalShade!]!
            : (hovered ? vars.colorSurfaceSunken : vars.colorSurfaceInset);
        final Color content = selected
            ? vars.colorOnAccent
            : (hovered ? vars.colorContent : vars.colorContentNav);

        return Opacity(
          opacity: item.enabled ? 1 : 0.5,
          child: SizedBox(
            height: vars.controlTinySize,
            child: AnimatedContainer(
              duration: vars.motionDuration,
              curve: vars.motionEasing,
              padding: EdgeInsets.symmetric(horizontal: vars.spacing3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: radius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: vars.controlTinyGap,
                children: [
                  Text(
                    item.label,
                    style: vars.labelSmall.copyWith(
                      height: 1,
                      fontWeight: selected
                          ? vars.labelStrong.fontWeight
                          : vars.labelSmall.fontWeight,
                      color: content,
                    ),
                  ),
                  if (item.count != null)
                    Text(
                      '${item.count}',
                      style: vars.labelSmall.copyWith(
                        height: 1,
                        fontWeight: selected
                            ? vars.labelStrong.fontWeight
                            : vars.labelSmall.fontWeight,
                        color: content,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
