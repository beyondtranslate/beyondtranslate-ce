import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// How the chosen segment is picked out.
enum SegmentedActiveStyle {
  /// Lifts a lighter capsule off the track, which is what a desktop
  /// segmented control does. The default.
  raised,

  /// Paints it with the tint — louder, and worth keeping for a choice that
  /// has to shout.
  filled,
}

/// One segment.
@immutable
class SegmentedItem<T> {
  const SegmentedItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// A recessed track with one segment picked out.
///
/// The nesting is derived, not restated: the track takes the control corner,
/// the capsule sits `segmented-control.inset` inside it, and its corner is the
/// track's minus the inset — the only relationship that keeps the two curves
/// concentric. The segment's height is likewise the control height minus the
/// inset on both sides, so a segmented control lines up with the buttons
/// beside it.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.size = WidgetSize.small,
    this.activeStyle = SegmentedActiveStyle.raised,
    this.stretch = false,
  });

  final List<SegmentedItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final WidgetSize size;
  final SegmentedActiveStyle activeStyle;
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final double inset = vars.segmentedControlInset;

    final (
      double controlSize,
      double trackRadius,
      TextStyle face,
    ) = switch (size.namedSize) {
      NamedSize.tiny => (
        vars.controlTinySize,
        vars.controlTinyRadius,
        vars.labelSmall,
      ),
      // The medium track takes the regular control corner — one step above
      // the button beside it, because the track is a container for
      // capsules rather than a control face itself.
      NamedSize.medium => (
        vars.controlMediumSize,
        vars.radiusMedium,
        vars.labelMedium,
      ),
      NamedSize.large => (
        vars.controlLargeSize,
        vars.radiusMedium,
        vars.labelMedium,
      ),
      _ => (
        vars.controlSmallSize,
        vars.controlSmallRadius,
        vars.labelMedium,
      ),
    };

    final List<Widget> segments = [
      for (final SegmentedItem<T> item in items)
        _Segment<T>(
          item: item,
          selected: item.value == value,
          activeStyle: activeStyle,
          height: controlSize - 2 * inset,
          radius: trackRadius - inset,
          face: face,
          onPressed: onChanged == null || !item.enabled
              ? null
              : () => onChanged!(item.value),
        ),
    ];

    return Container(
      padding: EdgeInsets.all(inset),
      decoration: BoxDecoration(
        color: vars.colorSurfaceInset,
        borderRadius: BorderRadius.circular(trackRadius),
      ),
      child: Row(
        mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final Widget segment in segments)
            if (stretch) Expanded(child: segment) else segment,
        ],
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.item,
    required this.selected,
    required this.activeStyle,
    required this.height,
    required this.radius,
    required this.face,
    required this.onPressed,
  });

  final SegmentedItem<T> item;
  final bool selected;
  final SegmentedActiveStyle activeStyle;
  final double height;
  final double radius;
  final TextStyle face;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final BorderRadius corner = BorderRadius.circular(radius);

    return Pressable(
      onPressed: onPressed,
      enabled: item.enabled,
      selected: selected,
      borderRadius: corner,
      builder: (context, states) {
        final bool hovered = states.contains(WidgetState.hovered);

        Color? surface;
        Color content = hovered
            ? vars.colorContent
            : vars.colorContentSecondary;
        if (selected) {
          switch (activeStyle) {
            case SegmentedActiveStyle.raised:
              surface = vars.colorSurfaceRaised;
              content = vars.colorContent;
            case SegmentedActiveStyle.filled:
              surface = vars
                  .colorPrimary[vars.controlColorFilledSurface.normalShade!]!;
              content = vars.colorOnAccent;
          }
        }

        return Opacity(
          opacity: item.enabled ? 1 : 0.5,
          child: SizedBox(
            height: height,
            child: AnimatedContainer(
              duration: vars.motionDuration,
              curve: vars.motionEasing,
              padding: EdgeInsets.symmetric(horizontal: vars.spacing3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: corner,
                // Both active styles lift with the hairline shadow.
                boxShadow: selected ? vars.shadow2xs : const <BoxShadow>[],
              ),
              child: Text(
                item.label,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: vars.labelQuiet.copyWith(
                  fontSize: face.fontSize,
                  height: 1,
                  // Selection is a weight shift as much as a fill.
                  fontWeight: selected
                      ? vars.labelMedium.fontWeight
                      : vars.labelQuiet.fontWeight,
                  color: content,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
