import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

enum SwitchSize {
  /// 36×21, used in the browser popup.
  sm,

  /// 38×22, used in app windows.
  md,
}

/// The switch used for engine enablement and per-site options.
class Switch extends StatelessWidget {
  const Switch({
    super.key,
    required this.checked,
    this.onChanged,
    this.enabled = true,
    this.size = SwitchSize.md,
    this.semanticsLabel,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final SwitchSize size;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final disabled = !enabled || onChanged == null;

    final (double width, double height, double knob) = switch (size) {
      SwitchSize.md => (38, 22, 16),
      SwitchSize.sm => (36, 21, 15),
    };
    final radius = BorderRadius.circular(tokens.radii.pill);

    return Pressable(
      enabled: !disabled,
      onPressed: disabled ? null : () => onChanged!(!checked),
      borderRadius: radius,
      checked: checked,
      isButton: false,
      semanticsLabel: semanticsLabel,
      builder: (context, state) => Opacity(
        opacity: disabled ? 0.6 : 1,
        child: AnimatedContainer(
          duration: kTransitionDuration,
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: checked ? colors.accent : colors.track,
            borderRadius: radius,
          ),
          child: AnimatedContainer(
            duration: kTransitionDuration,
            width: knob,
            height: knob,
            decoration: BoxDecoration(
              color: checked ? colors.onAccent : colors.fgFaint,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
