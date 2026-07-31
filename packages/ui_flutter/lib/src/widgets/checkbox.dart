import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// The export dialog's content checklist.
class Checkbox extends StatelessWidget {
  const Checkbox({
    super.key,
    required this.checked,
    this.onChanged,
    required this.child,
    this.note,
    this.enabled = true,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final Widget child;

  /// Trailing de-emphasised note — 12 条 / +2.1 MB.
  final Widget? note;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final disabled = !enabled || onChanged == null;

    return Pressable(
      enabled: !disabled,
      onPressed: disabled ? null : () => onChanged!(!checked),
      borderRadius: BorderRadius.circular(5),
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
                color: checked ? colors.accent : null,
                borderRadius: BorderRadius.circular(5),
                border: checked
                    ? null
                    : Border.all(color: colors.controlOutline, width: 1.5),
              ),
              child: checked
                  ? Text(
                      '✓',
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        height: 1,
                        color: colors.onAccent,
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
                child: note == null
                    ? child
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: child),
                          const SizedBox(width: 4),
                          DefaultTextStyle(
                            style: tokens.typography.sansStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1,
                              color: colors.fgFaint,
                            ),
                            child: note!,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
