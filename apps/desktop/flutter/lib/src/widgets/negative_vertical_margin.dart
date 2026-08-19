import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Tailwind's `-my-*`: the child is laid out and painted at its own full size,
/// but the space it claims is [shrink] shorter top and bottom.
///
/// Lets a control carry padding for the sake of its hit target and its hover
/// background without that padding growing the row it sits in.
///
/// `OverflowBox` looks like the widget for this and is not: it sizes itself to
/// `constraints.biggest`, which is infinitely wide in a `Row`. Deriving the
/// height from the child also keeps the row honest — nothing here restates the
/// line height as a constant that could drift from the type.
class NegativeVerticalMargin extends SingleChildRenderObjectWidget {
  const NegativeVerticalMargin(
      {super.key, required this.shrink, required super.child});

  final double shrink;

  @override
  RenderNegativeVerticalMargin createRenderObject(BuildContext context) {
    return RenderNegativeVerticalMargin(shrink: shrink);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderNegativeVerticalMargin renderObject,
  ) {
    renderObject.shrink = shrink;
  }
}

class RenderNegativeVerticalMargin extends RenderShiftedBox {
  RenderNegativeVerticalMargin({required double shrink})
      : _shrink = shrink,
        super(null);

  double get shrink => _shrink;
  double _shrink;
  set shrink(double value) {
    if (_shrink == value) return;
    _shrink = value;
    markNeedsLayout();
  }

  double get _taken => _shrink * 2;

  /// The child may be [_taken] taller than whatever the parent offered — that
  /// overhang is the whole point.
  BoxConstraints _childConstraints(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
      minHeight: constraints.minHeight + _taken,
      maxHeight: constraints.maxHeight + _taken,
    );
  }

  Size _sizeForChild(BoxConstraints constraints, Size childSize) {
    return constraints.constrain(
      Size(childSize.width, math.max(0.0, childSize.height - _taken)),
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      child?.getMinIntrinsicWidth(height + _taken) ?? 0.0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      child?.getMaxIntrinsicWidth(height + _taken) ?? 0.0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(0.0, (child?.getMinIntrinsicHeight(width) ?? 0.0) - _taken);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(0.0, (child?.getMaxIntrinsicHeight(width) ?? 0.0) - _taken);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.smallest;
    return _sizeForChild(
      constraints,
      child.getDryLayout(_childConstraints(constraints)),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = _sizeForChild(constraints, child.size);
    (child.parentData! as BoxParentData).offset = Offset(
      0.0,
      (size.height - child.size.height) / 2,
    );
  }
}
