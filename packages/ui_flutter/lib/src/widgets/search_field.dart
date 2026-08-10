import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/kbd.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Inline search used by 收藏与历史 and 术语库; opened with ⌘F.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.value,
    required this.onChanged,
    this.placeholder = '搜索',
    this.shortcut = '⌘F',
    this.autofocus = false,
    this.onDismiss,
    this.clearLabel = '清除',
    this.semanticsLabel,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String placeholder;

  /// Shortcut glyph shown while the field is empty.
  final String shortcut;

  /// Focus on mount — the field is normally opened by ⌘F.
  final bool autofocus;

  /// Called on Escape; the caller usually closes the field.
  final VoidCallback? onDismiss;

  /// Accessible name of the ✕ button. Relabel it to localise.
  final String clearLabel;
  final String? semanticsLabel;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _node = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(() {
      if (_node.hasFocus != _focused) setState(() => _focused = _node.hasFocus);
    });
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (widget.value.isNotEmpty) {
      widget.onChanged('');
    } else {
      widget.onDismiss?.call();
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.control);

    final style = tokens.typography.sansStyle(
      fontSize: 12,
      height: 1,
      color: colors.fg,
    );

    return AnimatedContainer(
      duration: kTransitionDuration,
      // `h-7 px-3`: the same 28px box as an Input, so a search field can take
      // an input's place in a toolbar without moving anything.
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _focused ? colors.window : colors.card,
        // `focus-within:border-accent` recolours the hairline without
        // rewidening it — the ring below carries the focus, not the border.
        border: Border.all(
          color: _focused ? colors.accent : colors.hairlineStrong,
          width: context.hairlineWidth,
        ),
        borderRadius: radius,
        boxShadow: _focused
            ? [BoxShadow(color: colors.accentRing, spreadRadius: 3)]
            : null,
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Text(
              '⌕',
              style: tokens.typography.sansStyle(
                fontSize: 12,
                height: 1,
                color: colors.fgFaint,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Focus(
              onKeyEvent: _handleKey,
              child: Semantics(
                textField: true,
                label: widget.semanticsLabel ?? widget.placeholder,
                child: CupertinoTextField.borderless(
                  controller: _controller,
                  focusNode: _node,
                  autofocus: widget.autofocus,
                  padding: EdgeInsets.zero,
                  placeholder: widget.placeholder,
                  placeholderStyle: style.copyWith(color: colors.fgFaint),
                  style: style,
                  cursorColor: colors.accent,
                  cursorWidth: 1,
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (widget.value.isNotEmpty)
            Pressable(
              onPressed: () => widget.onChanged(''),
              semanticsLabel: widget.clearLabel,
              borderRadius: BorderRadius.circular(999),
              builder: (context, state) => Text(
                '✕',
                style: tokens.typography.sansStyle(
                  fontSize: 12,
                  height: 1,
                  color: state.hovered ? colors.fg : colors.fgFaint,
                ),
              ),
            )
          else
            Kbd(widget.shortcut),
        ],
      ),
    );
  }
}
