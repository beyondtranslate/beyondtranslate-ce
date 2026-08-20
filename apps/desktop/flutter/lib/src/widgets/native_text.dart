import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const String _kViewType = 'beyondtranslate/native_text';
const String _kChannelPrefix = 'beyondtranslate/native_text';

/// A run of read-only text drawn by AppKit's `NSTextView`.
///
/// The display-side counterpart to [NativeTextField]: it exists so 译文 comes
/// with everything a Mac user expects of text — Services, ⌃⌘D lookup, 朗读,
/// share, native drag, and a right-click menu that knows about all of them —
/// none of which Flutter's own `SelectableText` can offer.
///
/// macOS only; renders nothing elsewhere. Callers should reach for
/// `TranslationText`, which picks between this and Flutter's own
/// `SelectableText` by platform.
///
/// AppKit owns the mouse over a platform view, so a surrounding
/// `GestureDetector` never fires: clicks arrive through [onTap] /
/// [onDoubleTap] instead.
class NativeText extends StatefulWidget {
  const NativeText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.padding = EdgeInsets.zero,
    this.selectable = true,
    this.selectionColor,
    this.brightness,
    this.onTap,
    this.onDoubleTap,
  });

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;
  final bool selectable;

  /// The wash behind selected glyphs. Left null, AppKit falls back to the
  /// system accent — the colour in System Settings, which has nothing to do
  /// with the app's theme.
  final Color? selectionColor;

  /// The app theme's brightness, handed to AppKit as an `NSAppearance`.
  ///
  /// Without it the view inherits the *system* appearance, and every colour
  /// AppKit still resolves for itself — the unemphasized selection, the context
  /// menu, the IME candidates — comes back light while the app is drawing dark.
  final Brightness? brightness;

  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;

  @override
  State<NativeText> createState() => _NativeTextState();
}

class _NativeTextState extends State<NativeText> {
  MethodChannel? _channel;

  /// The height AppKit laid the text out at, paired with the width it measured
  /// against. Until that width matches what the parent is offering, the box is
  /// sized from Flutter's own measurement of the same string — close enough
  /// that the hand-off is invisible, where a placeholder height would show up
  /// as a jump.
  double? _nativeHeight;
  double? _nativeWidth;

  @override
  void didUpdateWidget(NativeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _channel?.invokeMethod<void>('setText', widget.text);
      _forgetNativeSize();
    }
    if (widget.style != oldWidget.style ||
        widget.textAlign != oldWidget.textAlign) {
      _updateStyle();
    }
    if (widget.selectable != oldWidget.selectable) {
      _channel?.invokeMethod<void>('setSelectable', widget.selectable);
    }
    if (widget.brightness != oldWidget.brightness) {
      _channel?.invokeMethod<void>(
        'setAppearance',
        _encodeBrightness(widget.brightness),
      );
    }
    if (widget.selectionColor != oldWidget.selectionColor) {
      _channel?.invokeMethod<void>(
        'setSelectionColor',
        widget.selectionColor?.toARGB32(),
      );
    }
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _forgetNativeSize() {
    _nativeHeight = null;
    _nativeWidth = null;
  }

  void _updateStyle() {
    if (_channel == null) return;
    final textDirection = Directionality.of(context);
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    _channel!.invokeMethod<void>('setStyle', <String, Object?>{
      'style': _encodeTextStyle(style),
      'textAlign': _encodeTextAlign(widget.textAlign, textDirection),
    });
    _forgetNativeSize();
  }

  void _handlePlatformViewCreated(int id) {
    final channel = MethodChannel('$_kChannelPrefix/$id');
    _channel = channel;
    channel.setMethodCallHandler(_handleNativeMethodCall);
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'contentSizeChanged':
        final args = (call.arguments as Map?)?.cast<Object?, Object?>();
        final height = (args?['height'] as num?)?.toDouble();
        final width = (args?['width'] as num?)?.toDouble();
        if (height == null || width == null) return;
        if (height == _nativeHeight && width == _nativeWidth) return;
        setState(() {
          _nativeHeight = height;
          _nativeWidth = width;
        });
        return;
      case 'tapped':
        widget.onTap?.call();
        return;
      case 'doubleTapped':
        widget.onDoubleTap?.call();
        return;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.macOS) {
      return const SizedBox.shrink();
    }

    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final textDirection = Directionality.of(context);
    final padding = widget.padding.resolve(textDirection);

    return CustomSingleChildLayout(
      delegate: _NativeTextLayout(
        text: widget.text,
        style: style,
        textAlign: widget.textAlign,
        textDirection: textDirection,
        padding: padding,
        nativeWidth: _nativeWidth,
        nativeHeight: _nativeHeight,
      ),
      child: AppKitView(
        viewType: _kViewType,
        creationParams: <String, Object?>{
          'text': widget.text,
          'style': _encodeTextStyle(style),
          'textAlign': _encodeTextAlign(widget.textAlign, textDirection),
          'padding': _encodePadding(padding),
          'selectable': widget.selectable,
          'selectionColor': widget.selectionColor?.toARGB32(),
          'appearance': _encodeBrightness(widget.brightness),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _handlePlatformViewCreated,
      ),
    );
  }

  String? _encodeBrightness(Brightness? brightness) => switch (brightness) {
        Brightness.dark => 'dark',
        Brightness.light => 'light',
        null => null,
      };

  Map<String, double> _encodePadding(EdgeInsets padding) {
    return <String, double>{
      'left': padding.left,
      'top': padding.top,
      'right': padding.right,
      'bottom': padding.bottom,
    };
  }

  String _encodeTextAlign(TextAlign align, TextDirection direction) {
    switch (align) {
      case TextAlign.center:
        return 'center';
      case TextAlign.right:
        return 'right';
      case TextAlign.justify:
        return 'justify';
      case TextAlign.end:
        return direction == TextDirection.rtl ? 'left' : 'right';
      case TextAlign.left:
      case TextAlign.start:
        return 'start';
    }
  }

  Map<String, Object?> _encodeTextStyle(TextStyle style) {
    return <String, Object?>{
      'fontSize': style.fontSize,
      'fontFamily': style.fontFamily,
      'fontFamilyFallback': style.fontFamilyFallback,
      'fontWeight': style.fontWeight?.value,
      'height': style.height,
      'letterSpacing': style.letterSpacing,
      'color': style.color?.toARGB32(),
    };
  }
}

/// Sizes the platform view to the text inside it.
///
/// A `LayoutBuilder` would be the obvious way to learn the available width, but
/// it cannot answer intrinsic queries, and 译文 sits under the workbench's
/// `IntrinsicHeight`. A layout delegate can: `RenderCustomSingleChildLayoutBox`
/// routes every intrinsic and dry-layout question straight to [getSize].
class _NativeTextLayout extends SingleChildLayoutDelegate {
  _NativeTextLayout({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.textDirection,
    required this.padding,
    required this.nativeWidth,
    required this.nativeHeight,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final EdgeInsets padding;

  /// The last size AppKit reported, and the width it was measured at.
  final double? nativeWidth;
  final double? nativeHeight;

  Size? _measured;
  double? _measuredAt;

  /// Flutter's own read on the same string. Used until AppKit has answered for
  /// the width in play, and for every intrinsic query — those ask about widths
  /// the native view was never laid out at.
  Size _measure(double maxWidth) {
    if (_measuredAt == maxWidth) return _measured!;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      textAlign: textAlign,
    )..layout(maxWidth: maxWidth);
    final size = Size(painter.width, painter.height);
    painter.dispose();
    _measuredAt = maxWidth;
    _measured = size;
    return size;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    final bounded = constraints.maxWidth.isFinite;
    final contentWidth = bounded
        ? math.max(0.0, constraints.maxWidth - padding.horizontal)
        : double.infinity;
    final measured = _measure(contentWidth);
    final fromNative = nativeWidth == contentWidth ? nativeHeight : null;
    return constraints.constrain(
      Size(
        bounded ? constraints.maxWidth : measured.width + padding.horizontal,
        padding.vertical + (fromNative ?? measured.height),
      ),
    );
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tight(getSize(constraints));
  }

  @override
  bool shouldRelayout(_NativeTextLayout oldDelegate) {
    return text != oldDelegate.text ||
        style != oldDelegate.style ||
        textAlign != oldDelegate.textAlign ||
        textDirection != oldDelegate.textDirection ||
        padding != oldDelegate.padding ||
        nativeWidth != oldDelegate.nativeWidth ||
        nativeHeight != oldDelegate.nativeHeight;
  }
}
