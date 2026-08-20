import 'dart:ui';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'native_text_field.dart';
import 'ui.dart' show DesignThemeContext;

const EdgeInsets _kDefaultPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 8,
);
const Color _kDefaultBackgroundCursorColor = Color(0x33000000);

/// The selection sits behind the glyphs, so it reads as the accent without
/// taking the text with it.
const double _kSelectionOpacity = 0.2;

/// A lightweight app text field with Cupertino-style defaults.
///
/// The widget intentionally exposes the common input parameters used across the
/// app while keeping the visual defaults opinionated: no Material/Cupertino
/// text field dependency, compact padding, and a lightweight placeholder layer.
class TextField extends StatefulWidget {
  const TextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.placeholderStyle,
    this.style,
    this.padding = _kDefaultPadding,
    this.maxLines = 1,
    this.minLines,
    this.enabled,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.expands = false,
    this.submitOnEnter = false,
    this.submitOnMetaEnter = false,
    this.textCapitalization = TextCapitalization.none,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool expands;
  final bool submitOnEnter;
  final bool submitOnMetaEnter;
  final TextCapitalization textCapitalization;
  final BoxHeightStyle selectionHeightStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (oldWidget.controller == null) {
        _controller?.removeListener(_handleControllerChanged);
        _controller?.dispose();
        _controller = null;
      }
      if (widget.controller == null) {
        _controller = TextEditingController.fromValue(
          oldWidget.controller?.value,
        );
      }
      _effectiveController.addListener(_handleControllerChanged);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode?.dispose();
        _focusNode = null;
      }
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
      }
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  void _handleTap() {
    _effectiveFocusNode.requestFocus();
    widget.onTap?.call();
  }

  /// Whether the caller has named the key that submits — 提交方式 in settings.
  /// Only then does the field take Enter into its own hands; every other field
  /// keeps whatever [TextField.textInputAction] already gave it.
  bool get _hasSubmitMode => widget.submitOnEnter || widget.submitOnMetaEnter;

  /// ⇧⏎ always writes a newline, the chosen key submits, and anything else
  /// falls through to the editor. Mirrors `doCommandBy` in
  /// `NativeTextFieldPlugin`, which does this same job on macOS — there the
  /// field is an AppKit view and these events never reach Flutter.
  KeyEventResult _handleSubmitKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.enter &&
        event.logicalKey != LogicalKeyboardKey.numpadEnter) {
      return KeyEventResult.ignored;
    }
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isShiftPressed) return KeyEventResult.ignored;
    // ⌘ names the key on a Mac keyboard; on the platforms this branch actually
    // runs on it is Ctrl that sits there.
    final commandHeld = keyboard.isMetaPressed || keyboard.isControlPressed;
    final submits =
        widget.submitOnEnter || (widget.submitOnMetaEnter && commandHeld);
    if (!submits) return KeyEventResult.ignored;
    widget.onSubmitted?.call(_effectiveController.text);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    // Neither AppKit nor Flutter reaches for the app's theme on its own: one
    // falls back to the system accent, the other to Material's.
    final tokens = context.tokens;
    final cursorColor = tokens.colors.accent;
    final selectionColor = cursorColor.withValues(alpha: _kSelectionOpacity);

    // The same predicate [NativeTextField] guards its own `AppKitView` with —
    // asking the host OS instead would hand the field to a platform view that
    // then refuses to draw.
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return NativeTextField(
        controller: _effectiveController,
        focusNode: _effectiveFocusNode,
        placeholder: widget.placeholder,
        placeholderStyle: widget.placeholderStyle,
        style: widget.style,
        padding: widget.padding,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        expands: widget.expands,
        submitOnEnter: widget.submitOnEnter,
        submitOnMetaEnter: widget.submitOnMetaEnter,
        textCapitalization: widget.textCapitalization,
        selectionHeightStyle: widget.selectionHeightStyle,
        cursorColor: cursorColor,
        selectionColor: selectionColor,
        brightness: tokens.brightness,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
      );
    }

    final TextStyle textStyle =
        widget.style ?? DefaultTextStyle.of(context).style;
    final Color textColor = textStyle.color ?? const Color(0xFF000000);
    final bool enabled = widget.enabled ?? true;
    final bool showPlaceholder = widget.placeholder != null &&
        !widget.obscureText &&
        _effectiveController.text.isEmpty;

    final editableText = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enabled ? _handleTap : null,
      child: Padding(
        padding: widget.padding,
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            if (showPlaceholder)
              IgnorePointer(
                child: Text(
                  widget.placeholder!,
                  style: widget.placeholderStyle ??
                      textStyle.copyWith(
                        color: textColor.withValues(alpha: 0.5),
                      ),
                ),
              ),
            _TrimmingEditableText(
              controller: _effectiveController,
              focusNode: _effectiveFocusNode,
              readOnly: widget.readOnly || !enabled,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: _hasSubmitMode && widget.maxLines != 1
                  ? TextInputAction.newline
                  : widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              selectionHeightStyle: widget.selectionHeightStyle,
              style: textStyle,
              cursorColor: cursorColor,
              backgroundCursorColor: _kDefaultBackgroundCursorColor,
              selectionColor: selectionColor,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: widget.minLines,
              autofocus: widget.autofocus,
              enableInteractiveSelection: enabled,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ],
        ),
      ),
    );
    final Widget field =
        widget.expands ? SizedBox.expand(child: editableText) : editableText;
    if (!_hasSubmitMode) return field;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _handleSubmitKey,
      child: field,
    );
  }
}

/// [EditableText] with one behaviour changed: paste trims what it inserts.
///
/// Text copied out of a web page or a PDF arrives with the edges of the
/// selection attached — a trailing newline, an indent off the left margin —
/// and in a translation input those edges are never wanted. Trimming here
/// rather than at submit keeps what the field shows and what gets translated
/// the same thing.
///
/// The macOS field is an AppKit view that never reaches this code;
/// `NativeTextFieldPlugin.swift` does the same job there.
class _TrimmingEditableText extends EditableText {
  _TrimmingEditableText({
    required super.controller,
    required super.focusNode,
    required super.style,
    required super.cursorColor,
    required super.backgroundCursorColor,
    super.readOnly,
    super.obscureText,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.selectionHeightStyle,
    super.selectionColor,
    super.maxLines,
    super.minLines,
    super.autofocus,
    super.enableInteractiveSelection,
    super.onChanged,
    super.onSubmitted,
  });

  @override
  EditableTextState createState() => _TrimmingEditableTextState();
}

class _TrimmingEditableTextState extends EditableTextState {
  /// Every route into a paste lands here — the shortcut, and a selection
  /// toolbar if one is ever given to this field.
  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    if (widget.readOnly) return;
    final selection = textEditingValue.selection;
    if (!selection.isValid) return;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null) return;
    // Trimmed to nothing still counts as a paste: it replaces the selection,
    // the same as pasting an empty clipboard would.
    userUpdateTextEditingValue(
      textEditingValue.replaced(selection, text.trim()),
      cause,
    );
    bringIntoView(textEditingValue.selection.extent);
    if (cause == SelectionChangedCause.toolbar) hideToolbar();
  }
}
