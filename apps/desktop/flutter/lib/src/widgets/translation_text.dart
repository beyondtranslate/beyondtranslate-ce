import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';

import 'native_text.dart';
import 'ui.dart' show DesignThemeContext;

/// The selection sits behind the glyphs, so it reads as the accent without
/// taking the text with it.
const double _kSelectionOpacity = 0.2;

/// 译文 — the translated text itself, wherever the app shows it.
///
/// On macOS the string is drawn by AppKit through [NativeText], which brings
/// the whole menu a Mac user expects on a translation: 拷贝, 查询「…」, 朗读,
/// 共享, Services, and a native drag out of the window. Every other platform
/// falls back to Flutter's `SelectableText`.
///
/// The display-side sibling of [TranslationTextArea], which is where 译文 goes
/// when it is editable.
///
/// Plain strings only — rich text has no native counterpart, so anything with
/// spans (词典释义, 时态) stays on `SelectableText.rich`.
class TranslationText extends StatelessWidget {
  const TranslationText(
    this.data, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.onDoubleTap,
  });

  final String data;
  final TextStyle? style;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;

  /// AppKit owns the mouse over the platform view, so a `GestureDetector`
  /// wrapped around this widget never fires on macOS. Callers that care about
  /// clicks — 双击复制 — hand them here instead.
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    // Neither AppKit nor Flutter reaches for the app's theme on its own: one
    // falls back to the system accent, the other to Material's.
    final tokens = context.tokens;
    final selectionColor = tokens.colors.accent.withValues(
      alpha: _kSelectionOpacity,
    );

    // The same predicate [NativeText] guards its own `AppKitView` with — asking
    // the host OS instead would hand the text to a platform view that then
    // refuses to draw.
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return NativeText(
        text: data,
        style: style,
        textAlign: textAlign,
        padding: padding,
        selectionColor: selectionColor,
        brightness: tokens.brightness,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
      );
    }

    final Widget text = Padding(
      padding: padding,
      child: DefaultSelectionStyle(
        selectionColor: selectionColor,
        child: SelectableText(data, style: style, textAlign: textAlign),
      ),
    );
    if (onTap == null && onDoubleTap == null) return text;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: text,
    );
  }
}
