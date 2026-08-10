import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

enum SegmentedSize { sm, md }

enum SegmentedActiveStyle {
  /// Fills the active segment with the accent colour — louder, and worth
  /// reserving for places the choice needs to shout.
  accent,

  /// Lifts the active segment off the track, the way AppKit draws it.
  raised,
}

@immutable
class SegmentedItem<T> {
  const SegmentedItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final Widget label;
  final bool enabled;
}

/// The 正式 / 口语 / 技术 style switch — also used for reading modes, provider
/// protocol tabs and the browser popup's alignment picker.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
    this.activeStyle = SegmentedActiveStyle.raised,
    this.size = SegmentedSize.md,
    this.stretch = false,
    this.semanticsLabel,
  });

  final List<SegmentedItem<T>> items;
  final T value;
  final ValueChanged<T>? onChanged;
  final SegmentedActiveStyle activeStyle;
  final SegmentedSize size;

  /// Fill the available width, splitting it evenly between the segments.
  final bool stretch;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final trackRadius = BorderRadius.circular(
      size == SegmentedSize.sm ? tokens.radii.controlSm : tokens.radii.control,
    );
    final segmentRadius = BorderRadius.circular(tokens.radii.chip);
    // Both sizes draw a fixed 22px segment; only the inset and the type size
    // change, so a sm track and an md track stack to the same rhythm.
    final segmentPadding = switch (size) {
      SegmentedSize.sm => const EdgeInsets.symmetric(horizontal: 11),
      SegmentedSize.md => const EdgeInsets.symmetric(horizontal: 12),
    };
    final fontSize = size == SegmentedSize.sm ? 11.0 : 12.0;

    Widget buildSegment(SegmentedItem<T> item) {
      final active = item.value == value;
      return Pressable(
        enabled: item.enabled,
        onPressed: onChanged == null || !item.enabled
            ? null
            : () => onChanged!(item.value),
        borderRadius: segmentRadius,
        checked: active,
        isButton: false,
        builder: (context, state) {
          final activeAccent =
              active && activeStyle == SegmentedActiveStyle.accent;
          final activeRaised =
              active && activeStyle == SegmentedActiveStyle.raised;

          return Opacity(
            opacity: item.enabled ? 1 : 0.5,
            child: AnimatedContainer(
              duration: kTransitionDuration,
              height: 22,
              padding: segmentPadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: activeAccent
                    ? colors.accent
                    : (activeRaised ? colors.controlRaised : null),
                borderRadius: segmentRadius,
                boxShadow: active ? tokens.shadows.accent : null,
              ),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                softWrap: false,
                style: tokens.typography.sansStyle(
                  fontSize: fontSize,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  height: 1,
                  color: activeAccent
                      ? colors.onAccent
                      : active
                          ? colors.fg
                          : (state.hovered ? colors.fg : colors.fgSecondary),
                ),
                child: item.label,
              ),
            ),
          );
        },
      );
    }

    return Semantics(
      label: semanticsLabel,
      container: semanticsLabel != null,
      child: Container(
        width: stretch ? double.infinity : null,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: colors.inset,
          borderRadius: trackRadius,
        ),
        child: Row(
          mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
          children: [
            for (final item in items)
              if (stretch)
                Expanded(child: buildSegment(item))
              else
                buildSegment(item),
          ],
        ),
      ),
    );
  }
}
