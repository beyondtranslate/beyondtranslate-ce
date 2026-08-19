import 'dart:async';

import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/*
 * A shortcut is kept as the glyph string the settings page prints — '⌥⇧2',
 * '⌥ Space' — rather than as a key-code tuple. It is what every other place
 * in the design already carries (the `Kbd` chips, the status-bar hints, the
 * onboarding summary), so a recorder that produces the same string plugs in
 * without a formatter between it and the rest of the page. The runtime stores
 * `Alt+Shift+2` and formats on the way out; the two are one mapping apart.
 */

/// The modifier keys, by the glyph macOS prints for each.
final Map<LogicalKeyboardKey, String> _modifierGlyphs = {
  LogicalKeyboardKey.control: '⌃',
  LogicalKeyboardKey.controlLeft: '⌃',
  LogicalKeyboardKey.controlRight: '⌃',
  LogicalKeyboardKey.alt: '⌥',
  LogicalKeyboardKey.altLeft: '⌥',
  LogicalKeyboardKey.altRight: '⌥',
  LogicalKeyboardKey.shift: '⇧',
  LogicalKeyboardKey.shiftLeft: '⇧',
  LogicalKeyboardKey.shiftRight: '⇧',
  LogicalKeyboardKey.meta: '⌘',
  LogicalKeyboardKey.metaLeft: '⌘',
  LogicalKeyboardKey.metaRight: '⌘',
};

/// True when the key is a modifier rather than something a shortcut ends on.
bool isShortcutModifier(LogicalKeyboardKey key) =>
    _modifierGlyphs.containsKey(key);

/// Keys named by their position on the board, not by the character they
/// produce: with ⌥ held, the T key reports `†` on a US layout and the recorded
/// shortcut would print as gibberish.
final Map<PhysicalKeyboardKey, String> _namedKeyGlyphs = {
  PhysicalKeyboardKey.space: 'Space',
  PhysicalKeyboardKey.enter: '↩',
  PhysicalKeyboardKey.numpadEnter: '⌤',
  PhysicalKeyboardKey.tab: '⇥',
  PhysicalKeyboardKey.backspace: '⌫',
  PhysicalKeyboardKey.delete: '⌦',
  PhysicalKeyboardKey.arrowUp: '↑',
  PhysicalKeyboardKey.arrowDown: '↓',
  PhysicalKeyboardKey.arrowLeft: '←',
  PhysicalKeyboardKey.arrowRight: '→',
  PhysicalKeyboardKey.home: '↖',
  PhysicalKeyboardKey.end: '↘',
  PhysicalKeyboardKey.pageUp: '⇞',
  PhysicalKeyboardKey.pageDown: '⇟',
  PhysicalKeyboardKey.minus: '-',
  PhysicalKeyboardKey.equal: '=',
  PhysicalKeyboardKey.bracketLeft: '[',
  PhysicalKeyboardKey.bracketRight: ']',
  PhysicalKeyboardKey.backslash: r'\',
  PhysicalKeyboardKey.semicolon: ';',
  PhysicalKeyboardKey.quote: "'",
  PhysicalKeyboardKey.comma: ',',
  PhysicalKeyboardKey.period: '.',
  PhysicalKeyboardKey.slash: '/',
  PhysicalKeyboardKey.backquote: '`',
};

// The letter / digit / function ranges are read off the USB HID usage rather
// than listed key by key: the tables are contiguous, so the arithmetic is
// shorter than the 60 constants it replaces and cannot fall out of order.
const int _usageA = 0x00070004;
const int _usageZ = 0x0007001d;
const int _usage1 = 0x0007001e;
const int _usage9 = 0x00070026;
const int _usage0 = 0x00070027;
const int _usageNumpad1 = 0x00070059;
const int _usageNumpad9 = 0x00070061;
const int _usageNumpad0 = 0x00070062;
const int _usageF1 = 0x0007003a;
const int _usageF12 = 0x00070045;
const int _usageF13 = 0x00070068;
const int _usageF20 = 0x0007006f;

/// The glyph for the key at this position, or null when it is not something a
/// shortcut can be built on.
String? _keyGlyph(PhysicalKeyboardKey key) {
  final named = _namedKeyGlyphs[key];
  if (named != null) return named;
  final usage = key.usbHidUsage;
  if (usage >= _usageA && usage <= _usageZ) {
    return String.fromCharCode('A'.codeUnitAt(0) + usage - _usageA);
  }
  if (usage >= _usage1 && usage <= _usage9) {
    return String.fromCharCode('1'.codeUnitAt(0) + usage - _usage1);
  }
  if (usage == _usage0) return '0';
  if (usage >= _usageNumpad1 && usage <= _usageNumpad9) {
    return String.fromCharCode('1'.codeUnitAt(0) + usage - _usageNumpad1);
  }
  if (usage == _usageNumpad0) return '0';
  if (usage >= _usageF1 && usage <= _usageF12) {
    return 'F${usage - _usageF1 + 1}';
  }
  if (usage >= _usageF13 && usage <= _usageF20) {
    return 'F${usage - _usageF13 + 13}';
  }
  return null;
}

String _heldGlyphs({
  required bool control,
  required bool alt,
  required bool shift,
  required bool meta,
}) {
  // ⌃ ⌥ ⇧ ⌘ — the order macOS prints them in.
  return '${control ? '⌃' : ''}${alt ? '⌥' : ''}'
      '${shift ? '⇧' : ''}${meta ? '⌘' : ''}';
}

/// The glyph string for a key press, or null when the press is not something a
/// shortcut can be made of.
///
/// The rule is the one the macOS app applies: a key on its own is typing, not
/// a shortcut, so it has to carry ⌃, ⌥ or ⌘ — ⇧ alone is still typing — unless
/// it is a function key, which is a shortcut by itself. Word keys (`Space`,
/// `F5`) get a space after the modifiers so `⌥ Space` reads as two things and
/// `⌥⇧2` as one; that matches how the rest of the design prints them.
String? formatShortcut({
  required PhysicalKeyboardKey physicalKey,
  required bool control,
  required bool alt,
  required bool shift,
  required bool meta,
}) {
  final key = _keyGlyph(physicalKey);
  if (key == null) return null;
  final isFunctionKey = RegExp(r'^F\d+$').hasMatch(key);
  if (!isFunctionKey && !control && !alt && !meta) return null;
  final mods = _heldGlyphs(
    control: control,
    alt: alt,
    shift: shift,
    meta: meta,
  );
  if (key.length > 1) return '$mods${mods.isEmpty ? '' : ' '}$key';
  return '$mods$key';
}

/// The control a settings row uses to rebind a shortcut. Click it and it
/// listens; press a combination and it keeps it. `esc` backs out, `⌫` clears,
/// clicking away cancels — the same contract as the macOS app's
/// `ShortcutRecorderView`, so the two behave alike.
///
/// It is drawn as a field, not a key cap: a `Kbd` says "this is what the key
/// is", a field says "you can change this". Held modifiers show live while it
/// listens, so pressing ⌥⇧ and then wondering which key to add is not done
/// blind, and a rejected press — a bare letter — flashes the border rather
/// than beeping.
///
/// Port of `packages/ui/src/components/shortcut-recorder.tsx`.
class ShortcutRecorder extends StatefulWidget {
  const ShortcutRecorder({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.onClear,
    this.placeholder = '录制快捷键',
    this.recordingLabel = '按下快捷键…',
    this.clearLabel = '清除',
    this.state = ShortcutRecorderState.normal,
    this.enabled = true,
    this.semanticsLabel,
  });

  /// The bound keys as printed — `⌥⇧2`, `⌥ Space`. Empty means unbound.
  final String value;
  final ValueChanged<String> onValueChanged;

  /// Called on ✕ or ⌫ while recording; defaults to `onValueChanged('')`.
  final VoidCallback? onClear;

  /// Idle, unbound.
  final String placeholder;

  /// While the control waits for a key.
  final String recordingLabel;

  /// Accessible name of the ✕ button.
  final String clearLabel;

  /// [ShortcutRecorderState.error] for a binding the page cannot accept — one
  /// already taken.
  final ShortcutRecorderState state;
  final bool enabled;
  final String? semanticsLabel;

  @override
  State<ShortcutRecorder> createState() => _ShortcutRecorderState();
}

enum ShortcutRecorderState { normal, error }

class _ShortcutRecorderState extends State<ShortcutRecorder> {
  final FocusNode _node = FocusNode(debugLabel: 'ShortcutRecorder');
  bool _recording = false;

  /// Modifiers held right now, printed while recording.
  String _held = '';

  /// Set for a beat after a press the recorder could not take.
  bool _rejected = false;
  Timer? _rejectedTimer;

  @override
  void initState() {
    super.initState();
    _node.addListener(() {
      if (!_node.hasFocus && _recording) _stop();
    });
  }

  @override
  void dispose() {
    _rejectedTimer?.cancel();
    _node.dispose();
    super.dispose();
  }

  void _stop() {
    if (!mounted) return;
    setState(() {
      _recording = false;
      _held = '';
    });
  }

  void _clear() {
    _stop();
    final onClear = widget.onClear;
    if (onClear != null) {
      onClear();
    } else {
      widget.onValueChanged('');
    }
  }

  void _reject() {
    _rejectedTimer?.cancel();
    setState(() => _rejected = true);
    _rejectedTimer = Timer(const Duration(milliseconds: 360), () {
      if (mounted) setState(() => _rejected = false);
    });
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (!_recording) return KeyEventResult.ignored;
    // Nothing pressed here may reach the page: no dialog closes on this esc,
    // no ⌘F opens a search, no Space clicks the button under the pointer.
    if (event is KeyRepeatEvent) return KeyEventResult.handled;

    final keyboard = HardwareKeyboard.instance;
    final held = _heldGlyphs(
      control: keyboard.isControlPressed,
      alt: keyboard.isAltPressed,
      shift: keyboard.isShiftPressed,
      meta: keyboard.isMetaPressed,
    );

    if (event is KeyUpEvent) {
      if (isShortcutModifier(event.logicalKey)) setState(() => _held = held);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _stop();
      return KeyEventResult.handled;
    }
    if (isShortcutModifier(event.logicalKey)) {
      setState(() => _held = held);
      return KeyEventResult.handled;
    }
    if (held.isEmpty &&
        (event.logicalKey == LogicalKeyboardKey.backspace ||
            event.logicalKey == LogicalKeyboardKey.delete)) {
      _clear();
      return KeyEventResult.handled;
    }

    final next = formatShortcut(
      physicalKey: event.physicalKey,
      control: keyboard.isControlPressed,
      alt: keyboard.isAltPressed,
      shift: keyboard.isShiftPressed,
      meta: keyboard.isMetaPressed,
    );
    if (next == null) {
      _reject();
      return KeyEventResult.handled;
    }
    _stop();
    widget.onValueChanged(next);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.control);
    final bound = widget.value.isNotEmpty;
    final error = widget.state == ShortcutRecorderState.error && !_recording;
    final label = _recording
        ? (_held.isEmpty ? widget.recordingLabel : _held)
        : (bound ? widget.value : widget.placeholder);
    final showsGlyphs = _recording ? _held.isNotEmpty : bound;

    Color background = colors.card;
    Color border = colors.hairlineStrong;
    Color foreground = showsGlyphs ? colors.fg : colors.fgFaint;
    List<BoxShadow>? shadow;

    if (error) {
      background = colors.dangerSurface;
      border = colors.danger;
      foreground = colors.dangerDeep;
    }
    if (_recording) {
      background = colors.window;
      border = colors.accent;
      shadow = [BoxShadow(color: colors.accentRing, spreadRadius: 3)];
    }
    if (_rejected) {
      border = colors.danger;
      shadow = [BoxShadow(color: colors.dangerSurface, spreadRadius: 3)];
    }
    if (!widget.enabled) foreground = colors.fgFaint;

    return Focus(
      focusNode: _node,
      onKeyEvent: _handleKey,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Pressable(
            enabled: widget.enabled,
            onPressed: widget.enabled
                ? () {
                    if (_recording) return;
                    setState(() => _recording = true);
                    _node.requestFocus();
                  }
                : null,
            borderRadius: radius,
            semanticsLabel: widget.semanticsLabel,
            builder: (context, state) => AnimatedOpacity(
              duration: kTransitionDuration,
              opacity: widget.enabled ? 1 : 0.6,
              child: AnimatedContainer(
                duration: kTransitionDuration,
                // Sized like an `Input` — level with a `Select` in the same
                // column of rows — but the text is the `Kbd` face, because
                // what it shows is a key.
                height: 28,
                constraints: const BoxConstraints(minWidth: 132),
                // Room for the ✕ on the right and its mirror on the left, so
                // the keys stay centred whether or not the button is there.
                padding: EdgeInsets.symmetric(
                  horizontal: bound && !_recording ? 32 : 12,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(
                    color: border,
                    width: context.hairlineWidth,
                  ),
                  borderRadius: radius,
                  boxShadow: shadow,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: showsGlyphs
                      ? tokens.typography.displayStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          color: foreground,
                        )
                      : tokens.typography.sansStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color: foreground,
                        ),
                ),
              ),
            ),
          ),
          if (bound && !_recording && widget.enabled)
            Positioned(
              right: 8,
              child: Pressable(
                onPressed: _clear,
                semanticsLabel: widget.clearLabel,
                borderRadius: BorderRadius.circular(999),
                builder: (context, state) => Icon(
                  FluentIcons.dismiss_circle_20_filled,
                  size: 14,
                  color: state.hovered ? colors.fgSubtle : colors.fgFaint,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
