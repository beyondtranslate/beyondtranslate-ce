import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// The tint a [Progress] bar fills with.
enum ProgressTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// A rule cut into the surface, not a capsule.
///
/// The corner is a soft square and the fill's leading edge is a hard clip
/// against it — a pill's rounded head would read as a thumb.
class Progress extends StatefulWidget {
  const Progress({
    super.key,
    this.value,
    this.size = WidgetSize.small,
    this.tint = ProgressTint.primary,
    this.gradient = false,
    this.semanticsLabel,
  }) : assert(value == null || (value >= 0 && value <= 1));

  /// How far along, from 0 to 1. A null value is the indeterminate sweep.
  final double? value;

  final WidgetSize size;

  final ProgressTint tint;

  /// The document-progress fill: the theme's two-stop accent ramp.
  final bool gradient;

  final String? semanticsLabel;

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    if (widget.value == null) _sweep.repeat();
  }

  @override
  void didUpdateWidget(Progress oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool indeterminate = widget.value == null;
    if (indeterminate && !_sweep.isAnimating) {
      _sweep.repeat();
    } else if (!indeterminate && _sweep.isAnimating) {
      _sweep.stop();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    final double thickness = switch (widget.size.namedSize) {
      NamedSize.large => vars.spacing2,
      NamedSize.medium => vars.spacing15,
      _ => vars.spacing1,
    };
    final ColorSwatch<int> ramp = switch (widget.tint) {
      ProgressTint.primary => vars.colorPrimary,
      ProgressTint.neutral => vars.colorNeutral,
      ProgressTint.info => vars.colorInfo,
      ProgressTint.success => vars.colorSuccess,
      ProgressTint.warning => vars.colorWarning,
      ProgressTint.danger => vars.colorDanger,
    };

    final Decoration fill = widget.gradient
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [vars.progressGradientFrom, vars.progressGradientTo],
            ),
          )
        : BoxDecoration(color: ramp[600]);

    return Semantics(
      label: widget.semanticsLabel,
      value: widget.value == null ? null : '${(widget.value! * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(thickness / 2),
        child: SizedBox(
          height: thickness,
          width: double.infinity,
          child: ColoredBox(
            color: vars.colorSurfaceSunken,
            child: widget.value == null
                ? _Sweep(animation: _sweep, decoration: fill)
                : _Fill(value: widget.value!, decoration: fill, vars: vars),
          ),
        ),
      ),
    );
  }
}

/// The travel is twice the system's crossfade — a bar that jumped to its new
/// value would read as a redraw rather than as progress.
class _Fill extends StatelessWidget {
  const _Fill({
    required this.value,
    required this.decoration,
    required this.vars,
  });

  final double value;
  final Decoration decoration;
  final ThemeVariables vars;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedContainer(
        duration: vars.motionDuration * 2,
        curve: vars.motionEasing,
        alignment: AlignmentDirectional.centerStart,
        width: constraints.maxWidth * value,
        decoration: decoration,
      ),
    );
  }
}

/// An indeterminate bar has no width to animate, so it sweeps instead.
class _Sweep extends StatelessWidget {
  const _Sweep({required this.animation, required this.decoration});

  final Animation<double> animation;
  final Decoration decoration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth * 0.4;
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final double t = Curves.easeInOut.transform(animation.value);
            return Transform.translate(
              offset: Offset(
                -width + (constraints.maxWidth + width * 2) * t,
                0,
              ),
              child: child,
            );
          },
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(width: width, decoration: decoration),
          ),
        );
      },
    );
  }
}
