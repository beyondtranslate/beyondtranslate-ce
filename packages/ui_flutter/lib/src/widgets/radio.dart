import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// A single radio row — 气泡跟随光标 / 固定在右上角 / 显示在原文下方.
class Radio extends StatelessWidget {
  const Radio({
    super.key,
    required this.checked,
    this.onSelect,
    required this.child,
    this.enabled = true,
  });

  final bool checked;
  final VoidCallback? onSelect;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final disabled = !enabled || onSelect == null;

    return Pressable(
      enabled: !disabled,
      onPressed: disabled ? null : onSelect,
      borderRadius: BorderRadius.circular(999),
      checked: checked,
      isButton: false,
      builder: (context, state) => Opacity(
        opacity: disabled ? 0.6 : 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: checked ? colors.accent : colors.controlOutline,
                  width: 1.5,
                ),
              ),
              child: checked
                  ? Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: DefaultTextStyle(
                style: tokens.typography.sansStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: checked ? colors.fg : colors.fgTertiary,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class RadioList<T> extends StatelessWidget {
  const RadioList({
    super.key,
    required this.options,
    required this.value,
    this.onChanged,
    this.semanticsLabel,
  });

  final List<RadioItem<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticsLabel,
        container: semanticsLabel != null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              Radio(
                checked: options[i].value == value,
                enabled: options[i].enabled,
                onSelect: onChanged == null
                    ? null
                    : () => onChanged!(options[i].value),
                child: options[i].label,
              ),
            ],
          ],
        ),
      );
}
