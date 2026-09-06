import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'text_field.dart';

/// A search box.
///
/// The box belongs to the wrapper, not the field, because the glyph and the
/// trailing slot sit inside it — so the focus treatment comes from the row
/// rather than from the field itself.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.controller,
    this.placeholder,
    this.size = WidgetSize.medium,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final WidgetSize size;

  /// The trailing hint — a `KeyCap` naming the shortcut that focuses the field.
  final Widget? hint;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChanged);
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool focused = _focusNode.hasFocus;
    final Color accent = vars.colorPrimary[vars.focusRingShade]!;

    final double height = switch (widget.size.namedSize) {
      NamedSize.tiny => vars.controlTinySize,
      NamedSize.small => vars.controlSmallSize,
      NamedSize.large => vars.controlLargeSize,
      _ => vars.controlMediumSize,
    };

    return AnimatedContainer(
      duration: vars.motionDuration,
      curve: vars.motionEasing,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: vars.spacing3),
      decoration: BoxDecoration(
        // Focus lifts the card to the paper behind a soft accent wash — the
        // same move every text control makes.
        color: focused ? vars.colorSurface : vars.colorSurfaceMuted,
        border: Border.all(
          color: focused ? accent : vars.colorBorderStrong,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(vars.radiusMedium),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: vars.focusGlowAlpha),
                  spreadRadius: vars.focusWidth,
                ),
              ]
            : null,
      ),
      child: Row(
        spacing: vars.spacing2,
        children: [
          Icon(
            _kSearch,
            size: vars.spacing4,
            color: vars.colorContentFaint,
          ),
          Expanded(
            child: TextField.borderless(
              controller: _controller,
              focusNode: _focusNode,
              placeholder: widget.placeholder,
              size: widget.size,
              enabled: widget.enabled,
              padding: EdgeInsets.zero,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ),
          if (widget.hint != null && _controller.text.isEmpty) widget.hint!,
        ],
      ),
    );
  }
}

/// The search glyph, from the icon library the package already ships.
const IconData _kSearch = IconData(0xe8b6, fontFamily: 'MaterialIcons');
