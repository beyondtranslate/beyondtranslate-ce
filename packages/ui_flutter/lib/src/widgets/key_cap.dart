import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../generated/theme_variables.dart';
import '../painting/widget_property.dart';
import '../theme/theme.dart';
import 'key_cap_theme.dart';

/// Three renderings of a key, quietest first.
enum KeyCapVariant {
  /// Bare faint text in the display cut: the `⌘F` beside an empty search
  /// field. The default.
  hint,

  /// The same a step darker, for a hint that has to survive on a busy row.
  strong,

  /// The drawn cap: a recessed chip-cornered fill with no border — a key is
  /// pressed *into* the surface, not raised off it.
  key,
}

/// Displays a keyboard key or a key combination.
class KeyCap extends StatelessWidget {
  const KeyCap(
    this.label, {
    super.key,
    this.variant = KeyCapVariant.hint,
    this.size = WidgetSize.medium,
  });

  final String label;

  final KeyCapVariant variant;

  final WidgetSize size;

  @override
  Widget build(BuildContext context) {
    final KeyCapThemeData keyCapTheme = KeyCapTheme.of(context);
    final KeyCapThemeData defaults = _KeyCapDefaults(context);
    final ThemeVariables vars = Theme.of(context).vars;

    final TextStyle style = (keyCapTheme.labelStyle ?? defaults.labelStyle)!
        .sized<TextStyle>(size);

    final Widget text = Text(
      label,
      style: style.copyWith(
        color: switch (variant) {
          KeyCapVariant.hint => vars.colorContentFaint,
          KeyCapVariant.strong => vars.colorContentSubtle,
          KeyCapVariant.key => vars.colorContent,
        },
        fontWeight: variant == KeyCapVariant.key
            ? vars.labelStrong.fontWeight
            : style.fontWeight,
      ),
    );

    if (variant != KeyCapVariant.key) return text;

    // `widthFactor` keeps the cap hugging its glyph: a Container carrying an
    // alignment expands to fill whatever bounded space it is given, so a key
    // in a stretched Row would run the width of the row.
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        height: vars.spacing5 + vars.spacing05,
        padding: EdgeInsets.symmetric(horizontal: vars.spacing25),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: vars.colorSurfaceInset,
          borderRadius: BorderRadius.circular(vars.radiusTiny),
        ),
        child: text,
      ),
    );
  }
}

class _KeyCapDefaults extends KeyCapThemeData {
  _KeyCapDefaults(this.context) : super();

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ThemeVariables _vars = _theme.vars;

  /// The display cut at label weight, set solid — a key cap is one line and
  /// its box sets the height.
  @override
  SizedWidgetProperty<TextStyle>? get labelStyle {
    final TextStyle face = _vars.labelStrong.copyWith(
      fontWeight: _vars.labelMedium.fontWeight,
      height: 1,
    );
    return SizedWidgetProperty<TextStyle>(
      small: face.copyWith(fontSize: _vars.labelSmall.fontSize),
      medium: face.copyWith(fontSize: _vars.labelSmall.fontSize),
      large: face.copyWith(fontSize: _vars.labelMedium.fontSize),
    );
  }
}
