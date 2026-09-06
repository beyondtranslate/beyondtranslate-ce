// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Examples can assume:
// bool _giveVerse = false;

// ignore_for_file: require_trailing_commas

/// @docImport 'package:flutter/material.dart';
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDynamicColor, CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../theme/theme.dart';
import 'switch_thumb_painter.dart';

/// An iOS-style switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of
/// the switch changes, the widget calls the [onChanged] callback. Most widgets
/// that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// {@tool dartpad}
/// This example shows a toggleable [Switch]. When the thumb slides to
/// the other side of the track, the switch is toggled between on/off.
///
/// ** See code in examples/api/lib/cupertino/switch/cupertino_switch.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [Switch], the Material Design equivalent.
///  * <https://developer.apple.com/design/human-interface-guidelines/toggles/>
class Switch extends StatefulWidget {
  /// Creates an iOS-style switch.
  ///
  /// The [dragStartBehavior] parameter defaults to [DragStartBehavior.start].
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = WidgetSize.medium,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled, which has a reduced opacity.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Switch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// The color to use for the track when the switch is on.
  ///
  /// If null and [applyTheme] is false, defaults to [CupertinoColors.systemGreen]
  /// in accordance to native iOS behavior. Otherwise, defaults to
  /// [CupertinoThemeData.primaryColor].
  /// The size of the switch.
  ///
  /// Defaults to [WidgetSize.medium].
  final WidgetSize size;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template flutter.cupertino.Switch.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move the
  /// switch from on to off will begin at the position where the drag gesture won
  /// the arena. If set to [DragStartBehavior.down] it will begin at the position
  /// where a down event was first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  ///
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  @override
  State<Switch> createState() => _SwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'value',
        value: value,
        ifTrue: 'on',
        ifFalse: 'off',
        showName: true,
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged',
        onChanged,
        ifNull: 'disabled',
      ),
    );
  }
}

class _SwitchState extends State<Switch> with TickerProviderStateMixin {
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;

  late AnimationController _positionController;
  late final CurvedAnimation position;

  late AnimationController _reactionController;
  late CurvedAnimation _reaction;

  late bool isFocused;

  bool get isInteractive => widget.onChanged != null;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };

  // A non-null boolean value that changes to true at the end of a drag if the
  // switch must be animated to the position indicated by the widget's value.
  bool needsPositionAnimation = false;

  double trackInnerLength = 0;

  @override
  void initState() {
    super.initState();

    isFocused = false;

    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTap = _handleTap
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = widget.dragStartBehavior;

    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: widget.value ? 1.0 : 0.0,
      vsync: this,
    );
    position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    );
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: this,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    );
  }

  @override
  void didUpdateWidget(Switch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _drag.dragStartBehavior = widget.dragStartBehavior;

    if (needsPositionAnimation || oldWidget.value != widget.value) {
      _resumePositionAnimation(isLinear: needsPositionAnimation);
    }
  }

  // `isLinear` must be true if the position animation is trying to move the
  // thumb to the closest end after the most recent drag animation, so the curve
  // does not change when the controller's value is not 0 or 1.
  //
  // It can be set to false when it's an implicit animation triggered by
  // widget.value changes.
  void _resumePositionAnimation({bool isLinear = true}) {
    needsPositionAnimation = false;
    position
      ..curve = isLinear ? Curves.linear : Curves.ease
      ..reverseCurve = isLinear ? Curves.linear : Curves.ease.flipped;
    if (widget.value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
    }
    _reactionController.forward();
  }

  void _handleTap([Intent? _]) {
    if (isInteractive) {
      widget.onChanged!(!widget.value);
      _emitVibration();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.reverse();
    }
  }

  void _handleTapCancel() {
    if (isInteractive) {
      _reactionController.reverse();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.forward();
      _emitVibration();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = Curves.linear;
      final double delta = details.primaryDelta! / trackInnerLength;
      _positionController.value += switch (Directionality.of(context)) {
        TextDirection.rtl => -delta,
        TextDirection.ltr => delta,
      };
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // Deferring the animation to the next build phase.
    setState(() {
      needsPositionAnimation = true;
    });
    // Call onChanged when the user's intent to change value is clear.
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged!(!widget.value);
    }
    _reactionController.reverse();
  }

  void _emitVibration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        HapticFeedback.lightImpact();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  void _onShowFocusHighlight(bool showHighlight) {
    setState(() {
      isFocused = showHighlight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color activeColor = theme
        .vars
        .colorPrimary[theme.vars.controlColorFilledSurface.normalShade!]!;
    final (Color onLabelColor, Color offLabelColor)? onOffLabelColors =
        MediaQuery.onOffSwitchLabelsOf(context)
        ? (
            CupertinoDynamicColor.resolve(
              CupertinoColors.white,
              context,
            ),
            CupertinoDynamicColor.resolve(
              _kOffLabelColor,
              context,
            ),
          )
        : null;
    if (needsPositionAnimation) {
      _resumePositionAnimation();
    }
    // The track and its thumb are the sizes `switch.<size>.*` holds. The
    // switch box is the track itself: the thumb rides on the padding the
    // track/thumb difference leaves, the way the stylesheet lays it out with
    // `justify-content` rather than a translate.
    final (
      double trackWidth,
      double trackHeight,
      double thumbSize,
    ) = switch (widget.size.namedSize) {
      NamedSize.large => (
        theme.vars.switchLargeWidth,
        theme.vars.switchLargeHeight,
        theme.vars.switchLargeThumb,
      ),
      NamedSize.medium => (
        theme.vars.switchMediumWidth,
        theme.vars.switchMediumHeight,
        theme.vars.switchMediumThumb,
      ),
      _ => (
        theme.vars.switchSmallWidth,
        theme.vars.switchSmallHeight,
        theme.vars.switchSmallThumb,
      ),
    };
    final double switchWidth = trackWidth;
    final double switchHeight = trackHeight;
    final double trackInnerStart = trackHeight / 2.0;
    final double trackInnerEnd = trackWidth - trackInnerStart;
    final double trackInnerLength = trackInnerEnd - trackInnerStart;
    if (trackInnerLength != this.trackInnerLength) {
      this.trackInnerLength = trackInnerLength;
    }

    return MouseRegion(
      cursor: isInteractive && kIsWeb
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: Opacity(
        opacity: widget.onChanged == null ? _kSwitchDisabledOpacity : 1.0,
        child: FocusableActionDetector(
          onShowFocusHighlight: _onShowFocusHighlight,
          actions: _actionMap,
          enabled: isInteractive,
          focusNode: widget.focusNode,
          onFocusChange: widget.onFocusChange,
          autofocus: widget.autofocus,
          child: _SwitchRenderObjectWidget(
            value: widget.value,
            switchWidth: switchWidth,
            switchHeight: switchHeight,
            trackWidth: trackWidth,
            trackHeight: trackHeight,
            activeColor: activeColor,
            trackColor: theme.vars.colorSurfaceSunken,
            // The thumb changes colour with the state: faint ink while off —
            // a grey thumb in a grey groove, deliberately low-contrast — and
            // only brightens once the track fills. The on thumb is the filled
            // track's *content*, the way a filled button's label is: white on
            // Studio's accent, acid green on Bright's ink navy. A surface role
            // here would be a white thumb on every theme, and on a dark
            // canvas a surface is darker than the track it rides in.
            thumbColor: (widget.value
                ? theme.vars.controlColorFilledContent.normalColor!
                : theme.vars.colorContentFaint),
            thumbSize: thumbSize,
            // Opacity, lightness, and saturation values were approximated with
            // color pickers on the switches in the macOS settings.
            focusColor: CupertinoDynamicColor.resolve(
              HSLColor.fromColor(
                activeColor.withValues(alpha: 0.80),
              ).withLightness(0.69).withSaturation(0.835).toColor(),
              context,
            ),
            onChanged: widget.onChanged,
            textDirection: Directionality.of(context),
            isFocused: isFocused,
            state: this,
            onOffLabelColors: onOffLabelColors,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tap.dispose();
    _drag.dispose();

    _positionController.dispose();
    _reactionController.dispose();
    position.dispose();
    _reaction.dispose();
    super.dispose();
  }
}

class _SwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _SwitchRenderObjectWidget({
    required this.value,
    required this.switchWidth,
    required this.switchHeight,
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbSize,
    required this.activeColor,
    required this.trackColor,
    required this.thumbColor,
    required this.focusColor,
    required this.onChanged,
    required this.textDirection,
    required this.isFocused,
    required this.state,
    required this.onOffLabelColors,
  });

  final bool value;
  final double switchWidth;
  final double switchHeight;
  final double trackWidth;
  final double trackHeight;
  final double thumbSize;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final Color focusColor;
  final ValueChanged<bool>? onChanged;
  final _SwitchState state;
  final TextDirection textDirection;
  final bool isFocused;
  final (Color onLabelColor, Color offLabelColor)? onOffLabelColors;

  @override
  _RenderSwitch createRenderObject(BuildContext context) {
    return _RenderSwitch(
      value: value,
      switchWidth: switchWidth,
      switchHeight: switchHeight,
      trackWidth: trackWidth,
      trackHeight: trackHeight,
      thumbSize: thumbSize,
      activeColor: activeColor,
      trackColor: trackColor,
      thumbColor: thumbColor,
      focusColor: focusColor,
      onChanged: onChanged,
      textDirection: textDirection,
      isFocused: isFocused,
      state: state,
      onOffLabelColors: onOffLabelColors,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSwitch renderObject) {
    assert(renderObject._state == state);
    renderObject
      ..value = value
      // The box constraints come off these two, so a size change has to
      // reach them or the switch keeps whatever box it was first built with.
      ..switchWidth = switchWidth
      ..switchHeight = switchHeight
      ..trackWidth = trackWidth
      ..trackHeight = trackHeight
      ..thumbSize = thumbSize
      ..activeColor = activeColor
      ..trackColor = trackColor
      ..thumbColor = thumbColor
      ..focusColor = focusColor
      ..onChanged = onChanged
      ..textDirection = textDirection
      ..isFocused = isFocused;
  }
}

// const double _kTrackWidth = 36.0;
// const double _kTrackHeight = 22.0;
// const double _kTrackRadius = _kTrackHeight / 2.0;
// const double _kTrackInnerStart = _kTrackHeight / 2.0;
// const double _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
// const double _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
// const double _kSwitchWidth = 42.0;
// const double _kSwitchHeight = 28.0;
// Label sizes and padding taken from xcode inspector.
// See https://github.com/flutter/flutter/issues/4830#issuecomment-528495360
const double _kOnLabelWidth = 1.0;
const double _kOnLabelHeight = 10.0;
const double _kOnLabelPaddingHorizontal = 11.0;
const double _kOffLabelWidth = 1.0;
const double _kOffLabelPaddingHorizontal = 12.0;
const double _kOffLabelRadius = 5.0;
const CupertinoDynamicColor
_kOffLabelColor = CupertinoDynamicColor.withBrightnessAndContrast(
  debugLabel: 'offSwitchLabel',
  // Source: https://github.com/flutter/flutter/pull/39993#discussion_r321946033
  color: Color.fromARGB(255, 179, 179, 179),
  // Source: https://github.com/flutter/flutter/pull/39993#issuecomment-535196665
  darkColor: Color.fromARGB(255, 179, 179, 179),
  // Source: https://github.com/flutter/flutter/pull/127776#discussion_r1244208264
  highContrastColor: Color.fromARGB(255, 255, 255, 255),
  darkHighContrastColor: Color.fromARGB(255, 255, 255, 255),
);
// Opacity of a disabled switch, as eye-balled from iOS Simulator on Mac.
const double _kSwitchDisabledOpacity = 0.5;

const Duration _kReactionDuration = Duration(milliseconds: 300);
const Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderSwitch extends RenderConstrainedBox {
  _RenderSwitch({
    required bool value,
    required double switchWidth,
    required double switchHeight,
    required double trackWidth,
    required double trackHeight,
    required double thumbSize,
    required Color activeColor,
    required Color trackColor,
    required Color thumbColor,
    required Color focusColor,
    ValueChanged<bool>? onChanged,
    required TextDirection textDirection,
    required bool isFocused,
    required _SwitchState state,
    required (Color onLabelColor, Color offLabelColor)? onOffLabelColors,
  }) : _value = value,
       _switchWidth = switchWidth,
       _switchHeight = switchHeight,
       _trackWidth = trackWidth,
       _trackHeight = trackHeight,
       _thumbSize = thumbSize,
       _activeColor = activeColor,
       _trackColor = trackColor,
       _focusColor = focusColor,
       _thumbPainter = SwitchThumbPainter(
         color: thumbColor,
         radius: thumbSize / 2,
       ),
       _onChanged = onChanged,
       _textDirection = textDirection,
       _isFocused = isFocused,
       _state = state,
       _onOffLabelColors = onOffLabelColors,
       super(
         additionalConstraints: BoxConstraints.tightFor(
           width: switchWidth,
           height: switchHeight,
         ),
       ) {
    state.position.addListener(markNeedsPaint);
    state._reaction.addListener(markNeedsPaint);
  }

  final _SwitchState _state;

  bool get value => _value;
  bool _value;
  set value(bool value) {
    if (value == _value) {
      return;
    }
    _value = value;
    markNeedsSemanticsUpdate();
  }

  double get trackWidth => _trackWidth;
  double _trackWidth;
  set trackWidth(double value) {
    if (value == _trackWidth) {
      return;
    }
    _trackWidth = value;
    markNeedsPaint();
  }

  /// The box the switch occupies. Writing either re-tightens the additional
  /// constraints the render object was constructed with.
  double get switchWidth => _switchWidth;
  double _switchWidth;
  set switchWidth(double value) {
    if (value == _switchWidth) return;
    _switchWidth = value;
    _applyBox();
  }

  double get switchHeight => _switchHeight;
  double _switchHeight;
  set switchHeight(double value) {
    if (value == _switchHeight) return;
    _switchHeight = value;
    _applyBox();
  }

  void _applyBox() {
    additionalConstraints = BoxConstraints.tightFor(
      width: _switchWidth,
      height: _switchHeight,
    );
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;
  set thumbSize(double value) {
    if (value == _thumbSize) return;
    _thumbSize = value;
    _thumbPainter = SwitchThumbPainter(
      color: _thumbPainter.color,
      radius: value / 2,
    );
    markNeedsPaint();
  }

  double get trackHeight => _trackHeight;
  double _trackHeight;
  set trackHeight(double value) {
    if (value == _trackHeight) {
      return;
    }
    _trackHeight = value;
    _thumbPainter = SwitchThumbPainter(
      color: _thumbPainter.color,
      radius: _thumbSize / 2,
    );
    markNeedsPaint();
  }

  double get _trackRadius => _trackHeight / 2.0;
  double get _trackInnerStart => _trackHeight / 2.0;
  double get _trackInnerEnd => _trackWidth - _trackInnerStart;

  Color get activeColor => _activeColor;
  Color _activeColor;
  set activeColor(Color value) {
    if (value == _activeColor) {
      return;
    }
    _activeColor = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;
  set trackColor(Color value) {
    if (value == _trackColor) {
      return;
    }
    _trackColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbPainter.color;
  SwitchThumbPainter _thumbPainter;
  set thumbColor(Color value) {
    if (value == thumbColor) {
      return;
    }
    _thumbPainter = SwitchThumbPainter(
      color: value,
      // The knob is `switch.<size>.thumb`, not a fraction of the track — a
      // colour change must not resize it.
      radius: _thumbSize / 2,
    );
    markNeedsPaint();
  }

  Color get focusColor => _focusColor;
  Color _focusColor;
  set focusColor(Color value) {
    if (value == _focusColor) {
      return;
    }
    _focusColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool>? get onChanged => _onChanged;
  ValueChanged<bool>? _onChanged;
  set onChanged(ValueChanged<bool>? value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsPaint();
  }

  bool get isFocused => _isFocused;
  bool _isFocused;
  set isFocused(bool value) {
    if (value == _isFocused) {
      return;
    }
    _isFocused = value;
    markNeedsPaint();
  }

  (Color onLabelColor, Color offLabelColor)? get onOffLabelColors =>
      _onOffLabelColors;
  (Color onLabelColor, Color offLabelColor)? _onOffLabelColors;
  set onOffLabelColors((Color onLabelColor, Color offLabelColor)? value) {
    if (value == _onOffLabelColors) {
      return;
    }
    _onOffLabelColors = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _state._drag.addPointer(event);
      _state._tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) {
      config.onTap = _state._handleTap;
    }

    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _state.position.value;
    final double currentReactionValue = _state._reaction.value;

    final double visualPosition = switch (textDirection) {
      TextDirection.rtl => 1.0 - currentValue,
      TextDirection.ltr => currentValue,
    };

    final Paint paint = Paint()
      ..color = Color.lerp(trackColor, activeColor, currentValue)!;

    final Rect trackRect = Rect.fromLTWH(
      offset.dx + (size.width - _trackWidth) / 2.0,
      offset.dy + (size.height - _trackHeight) / 2.0,
      _trackWidth,
      _trackHeight,
    );
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(_trackRadius),
    );
    canvas.drawRRect(trackRRect, paint);

    if (_isFocused) {
      // Paints a border around the switch in the focus color.
      final RRect borderTrackRRect = trackRRect.inflate(1.75);

      final Paint borderPaint = Paint()
        ..color = focusColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5;

      canvas.drawRRect(borderTrackRRect, borderPaint);
    }

    if (_onOffLabelColors != null) {
      final (Color onLabelColor, Color offLabelColor) = onOffLabelColors!;

      final double leftLabelOpacity =
          visualPosition * (1.0 - currentReactionValue);
      final double rightLabelOpacity =
          (1.0 - visualPosition) * (1.0 - currentReactionValue);
      final (
        double onLabelOpacity,
        double offLabelOpacity,
      ) = switch (textDirection) {
        TextDirection.ltr => (leftLabelOpacity, rightLabelOpacity),
        TextDirection.rtl => (rightLabelOpacity, leftLabelOpacity),
      };

      final (
        Offset onLabelOffset,
        Offset offLabelOffset,
      ) = switch (textDirection) {
        TextDirection.ltr => (
          trackRect.centerLeft.translate(_kOnLabelPaddingHorizontal, 0),
          trackRect.centerRight.translate(-_kOffLabelPaddingHorizontal, 0),
        ),
        TextDirection.rtl => (
          trackRect.centerRight.translate(-_kOnLabelPaddingHorizontal, 0),
          trackRect.centerLeft.translate(_kOffLabelPaddingHorizontal, 0),
        ),
      };

      // Draws '|' label
      final Rect onLabelRect = Rect.fromCenter(
        center: onLabelOffset,
        width: _kOnLabelWidth,
        height: _kOnLabelHeight,
      );
      final Paint onLabelPaint = Paint()
        ..color = onLabelColor.withValues(alpha: onLabelOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawRect(onLabelRect, onLabelPaint);

      // Draws 'O' label
      final Paint offLabelPaint = Paint()
        ..color = offLabelColor.withValues(alpha: offLabelOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _kOffLabelWidth;
      canvas.drawCircle(
        offLabelOffset,
        _kOffLabelRadius,
        offLabelPaint,
      );
    }

    final double currentThumbExtension =
        SwitchThumbPainter.extension * currentReactionValue;
    final double thumbLeft = lerpDouble(
      trackRect.left + _trackInnerStart - _thumbPainter.radius,
      trackRect.left +
          _trackInnerEnd -
          _thumbPainter.radius -
          currentThumbExtension,
      visualPosition,
    )!;
    final double thumbRight = lerpDouble(
      trackRect.left +
          _trackInnerStart +
          _thumbPainter.radius +
          currentThumbExtension,
      trackRect.left + _trackInnerEnd + _thumbPainter.radius,
      visualPosition,
    )!;
    final double thumbCenterY = offset.dy + size.height / 2.0;
    final Rect thumbBounds = Rect.fromLTRB(
      thumbLeft,
      thumbCenterY - _thumbPainter.radius,
      thumbRight,
      thumbCenterY + _thumbPainter.radius,
    );

    _clipRRectLayer.layer = context.pushClipRRect(
      needsCompositing,
      Offset.zero,
      thumbBounds,
      trackRRect,
      (PaintingContext innerContext, Offset offset) {
        _thumbPainter.paint(innerContext.canvas, thumbBounds);
      },
      oldLayer: _clipRRectLayer.layer,
    );
  }

  final LayerHandle<ClipRRectLayer> _clipRRectLayer =
      LayerHandle<ClipRRectLayer>();

  @override
  void dispose() {
    _clipRRectLayer.layer = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      FlagProperty(
        'value',
        value: value,
        ifTrue: 'checked',
        ifFalse: 'unchecked',
        showName: true,
      ),
    );
    description.add(
      FlagProperty(
        'isInteractive',
        value: isInteractive,
        ifTrue: 'enabled',
        ifFalse: 'disabled',
        showName: true,
        defaultValue: true,
      ),
    );
  }
}
