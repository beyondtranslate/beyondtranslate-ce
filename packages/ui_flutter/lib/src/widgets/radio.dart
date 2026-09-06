import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// The tint a [Radio] marks itself with when it is selected.
enum RadioTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// A ring and a label on one row.
///
/// The row, the label and the disabled treatment are shared with [Checkbox].
/// What differs is the shape: a radio is a ring that keeps its outline when
/// selected and grows a dot inside it, where a checkbox fills solid.
class Radio<T> extends StatelessWidget {
  const Radio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.tint = RadioTint.primary,
    this.size = WidgetSize.medium,
    this.focusNode,
    this.autofocus = false,
    this.semanticsLabel,
  });

  final T value;

  final T? groupValue;

  final ValueChanged<T?>? onChanged;

  /// The row's label. Without one the radio is the bare ring.
  final Widget? label;

  final RadioTint tint;

  final WidgetSize size;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticsLabel;

  bool get _selected => value == groupValue;

  bool get _enabled => onChanged != null;

  ColorSwatch<int> _ramp(ThemeVariables vars) {
    return switch (tint) {
      RadioTint.primary => vars.colorPrimary,
      RadioTint.neutral => vars.colorNeutral,
      RadioTint.info => vars.colorInfo,
      RadioTint.success => vars.colorSuccess,
      RadioTint.warning => vars.colorWarning,
      RadioTint.danger => vars.colorDanger,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    final (double box, double dot) = switch (size.namedSize) {
      NamedSize.large => (vars.radioLargeBox, vars.radioLargeDot),
      NamedSize.medium => (vars.radioMediumBox, vars.radioMediumDot),
      _ => (vars.radioSmallBox, vars.radioSmallDot),
    };
    final Color mark = _ramp(
      vars,
    )[vars.controlColorFilledSurface.normalShade!]!;

    return Pressable(
      enabled: _enabled,
      onPressed: _enabled ? () => onChanged!(value) : null,
      borderRadius: BorderRadius.circular(vars.radiusFull),
      checked: _selected,
      isButton: false,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticsLabel: semanticsLabel,
      builder: (context, states) => Opacity(
        opacity: _enabled ? 1 : 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: vars.motionDuration,
              curve: vars.motionEasing,
              width: box,
              height: box,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // The ring is neutral while empty and the accent once
                // selected, and it keeps its outline either way — a filled
                // circle is a checkbox's signal, not a radio's.
                border: Border.all(
                  color: _selected ? mark : vars.colorBorderMuted,
                  width: vars.radioThickness,
                ),
              ),
              child: _selected
                  ? Container(
                      width: dot,
                      height: dot,
                      decoration: BoxDecoration(
                        color: mark,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            if (label != null) ...[
              SizedBox(width: vars.spacing25),
              Flexible(
                child: DefaultTextStyle(
                  style: vars.labelQuiet.copyWith(
                    fontWeight: _selected
                        ? vars.labelMedium.fontWeight
                        : vars.labelQuiet.fontWeight,
                    color: _selected
                        ? vars.colorContent
                        : vars.colorContentMuted,
                  ),
                  child: label!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// One option in a [RadioGroup].
@immutable
class RadioItem<T> {
  const RadioItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final Widget label;
  final bool enabled;
}

/// A column of radios, spaced the way the stylesheet's `.ff-radio-group` is.
class RadioGroup<T> extends StatelessWidget {
  const RadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.tint = RadioTint.primary,
    this.size = WidgetSize.medium,
    this.semanticsLabel,
  });

  final List<RadioItem<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final RadioTint tint;
  final WidgetSize size;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Semantics(
      label: semanticsLabel,
      container: semanticsLabel != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: vars.spacing25,
        children: [
          for (final RadioItem<T> option in options)
            Radio<T>(
              value: option.value,
              groupValue: value,
              tint: tint,
              size: size,
              label: option.label,
              onChanged: onChanged == null || !option.enabled
                  ? null
                  : onChanged,
            ),
        ],
      ),
    );
  }
}
