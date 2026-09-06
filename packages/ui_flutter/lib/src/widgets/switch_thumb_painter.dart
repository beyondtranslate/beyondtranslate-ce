// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/painting.dart';

/// The knob is flat.
///
/// An iOS switch lifts its thumb on a two-layer drop shadow and rings it in
/// black at 4%. This design's toggle is an AppKit control a third that size —
/// a 14px knob in an 18px groove — and the same shadow on it reads as grime
/// rather than as lift. The stylesheet draws no shadow here at all, so nor
/// does this.
const Color _kThumbBorderColor = Color(0x00000000);

const List<BoxShadow> _kSwitchBoxShadows = <BoxShadow>[];

/// Paints an iOS-style slider thumb or switch thumb.
class SwitchThumbPainter {
  /// Creates an object that paints an iOS-style slider thumb.
  const SwitchThumbPainter({
    this.color = CupertinoColors.white,
    this.shadows = _kSwitchBoxShadows,
    required this.radius,
  });

  /// The color of the interior of the thumb.
  final Color color;

  /// The list of [BoxShadow] to paint below the thumb.
  final List<BoxShadow> shadows;

  /// Half the default diameter of the thumb.
  final double radius;

  /// The default amount the thumb should be extended horizontally when pressed.
  static const double extension = 7.0;

  /// Paints the thumb onto the given canvas in the given rectangle.
  ///
  /// Consider using [radius] and [extension] when deciding how large a
  /// rectangle to use for the thumb.
  void paint(Canvas canvas, Rect rect) {
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.shortestSide / 2.0),
    );

    for (final BoxShadow shadow in shadows) {
      canvas.drawRRect(rrect.shift(shadow.offset), shadow.toPaint());
    }

    canvas.drawRRect(
      rrect.inflate(0.5),
      Paint()..color = _kThumbBorderColor,
    );
    canvas.drawRRect(rrect, Paint()..color = color);
  }
}
