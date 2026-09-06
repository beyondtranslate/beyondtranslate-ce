import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'spinner.dart';

/// Where a [Step] has got to.
enum StepStatus { done, active, idle }

/// An ordered list, because the steps are one: the markers carry the status.
///
/// The hierarchy runs label-over-meta: a step name with a trailing detail a
/// size under it, and only the active row takes the label weight — done and
/// idle rows rest at the quiet weight so the column reads as one live step
/// among finished and pending ones.
class StepList extends StatelessWidget {
  const StepList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: Theme.of(context).vars.spacing2,
      children: children,
    );
  }
}

/// One step.
class Step extends StatelessWidget {
  const Step({
    super.key,
    required this.status,
    required this.label,
    this.meta,
  });

  final StepStatus status;
  final String label;

  /// The trailing detail. It runs a step under the label and two ink steps
  /// back; only the active row's meta takes the accent — in its text grade,
  /// not the fill.
  final String? meta;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    final Color labelColor = switch (status) {
      StepStatus.done => vars.colorContentMuted,
      StepStatus.active => vars.colorContent,
      StepStatus.idle => vars.colorContentSubtle,
    };
    final Color metaColor = status == StepStatus.active
        ? vars.colorPrimary[vars.controlColorPlainContent.normalShade!]!
        : vars.colorContentFaint;

    return Opacity(
      // Not started yet: the whole row recedes, marker and meta included —
      // the plan is visible, the past and present are what read.
      opacity: status == StepStatus.idle ? 0.8 : 1,
      child: Row(
        spacing: vars.spacing25,
        children: [
          _Marker(status: status),
          Flexible(
            child: Text(
              label,
              style: vars.labelQuiet.copyWith(
                fontWeight: status == StepStatus.active
                    ? vars.labelMedium.fontWeight
                    : vars.labelQuiet.fontWeight,
                color: labelColor,
              ),
            ),
          ),
          if (meta != null) ...[
            const Spacer(),
            Text(
              meta!,
              style: vars.captionSmall.copyWith(
                fontSize: vars.labelSmall.fontSize,
                height: 1,
                color: metaColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({required this.status});

  final StepStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final double box = vars.spacing4;

    if (status == StepStatus.active) {
      return SizedBox(
        width: box,
        height: box,
        child: const Spinner(),
      );
    }

    if (status == StepStatus.done) {
      // Done is success wherever the list is tinted: a finished step is not a
      // variation on the accent, it is the one fixed meaning in the column.
      // The fill is a wash of the hue rather than an opaque chip, so it sits
      // as correctly on a card or a dark canvas as on the paper.
      final Color success = vars.colorSuccess[600]!;
      return Container(
        width: box,
        height: box,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: success.withValues(alpha: 0.14),
        ),
        child: CustomPaint(
          size: Size.square(vars.labelSmall.fontSize!),
          painter: _CheckPainter(color: success),
        ),
      );
    }

    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: vars.colorBorderMuted,
          width: vars.strokeControl,
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, w * 0.52)
        ..lineTo(w * 0.42, w * 0.72)
        ..lineTo(w * 0.78, w * 0.28),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.18
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => oldDelegate.color != color;
}
