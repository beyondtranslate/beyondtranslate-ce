import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../foundation/widget_variant.dart';
import '../generated/theme_variables.dart';
import '../painting/widget_property.dart';
import '../theme/theme.dart';
import '../widgets/button_theme.dart';
import 'pressable.dart';

/// The tint of a button.
enum ButtonTint with WidgetTint {
  /// A button indicating a primary action.
  primary,

  /// A button indicating a neutral action.
  neutral,

  /// A button indicating an info.
  info,

  /// A button indicating a success.
  success,

  /// A button indicating a warning.
  warning,

  /// A button indicating a danger.
  danger,
}

/// The variant of a button.
enum ButtonVariant with WidgetVariant {
  /// The neutral control: paper fill, hairline edge.
  normal,

  /// The workhorse neutral — the grey chip a toolbar button or default
  /// action is, one step deeper than the paper it sits on. The default.
  recessed,

  /// A filled button.
  filled,

  /// A tinted button.
  tinted,

  /// An outlined button.
  outlined,

  /// A plain button.
  plain,
}

/// A button widget.
///
/// Takes in a text or an icon that fades out and in on touch. May optionally have a
/// background.
class Button extends StatefulWidget {
  /// Creates an iOS-style button.
  const Button({
    super.key,
    required this.child,
    this.tint,
    this.variant,
    this.size = WidgetSize.small,
    this.shortcut,
    this.expand = false,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHover,
    required this.onPressed,
  });

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The tint of the button.
  ///
  /// Defaults to null.
  final ButtonTint? tint;

  /// The variant of the button.
  ///
  /// Defaults to null.
  final ButtonVariant? variant;

  /// The size of the button.
  ///
  /// Defaults to [WidgetSize.medium].
  final Size size;

  /// A trailing shortcut glyph, e.g. `⌘S`. It is a hint rather than part of
  /// the label, so it takes the display cut and steps back.
  final Widget? shortcut;

  /// Whether the button should expand to fill its container.
  ///
  /// Defaults to false.
  final bool expand;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// Handler called when the hover state changes.
  ///
  /// Called with true if this widget's node gains hover, and false if it loses
  /// hover.
  final ValueChanged<bool>? onHover;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  State<Button> createState() => _ButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty('enabled', value: enabled, ifFalse: 'disabled'),
    );
  }
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    final ButtonThemeData buttonTheme = ButtonTheme.of(
      context,
    ).merge(_ButtonDefaults(context));
    final ThemeVariables vars = Theme.of(context).vars;
    final ButtonVariant variant = widget.variant ?? ButtonVariant.recessed;
    final BorderRadius borderRadius = _resolve<BorderRadius>(
      buttonTheme,
      const <WidgetState>{},
      variant,
      (t) => t.borderRadius!,
    );

    return Pressable(
      onPressed: widget.onPressed,
      enabled: widget.enabled,
      borderRadius: borderRadius,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.onFocusChange,
      onHover: widget.onHover,
      builder: (context, states) {
        T resolve<T>(WidgetProperty<T> Function(ButtonThemeData t) get) =>
            _resolve<T>(buttonTheme, states, variant, get);

        final Size box = resolve<Size>((t) => t.minSize!);
        EdgeInsets padding = resolve<EdgeInsets>((t) => t.padding!);

        final Color surface = resolve<Color>((t) => t.surfaceColor!);
        final Color content = resolve<Color>((t) => t.contentColor!);
        final Color border = resolve<Color>((t) => t.borderColor!);
        TextStyle labelStyle = resolve<TextStyle>((t) => t.labelStyle!);

        // The one action a view points at carries the extra weight and the
        // hairline lift — both go when it is disabled and flattens.
        final bool lifted = variant == ButtonVariant.filled && widget.enabled;
        if (lifted) {
          labelStyle = labelStyle.copyWith(
            fontWeight: vars.labelStrong.fontWeight,
          );
        }

        // Geometry is instant and only the colours crossfade, the way the
        // stylesheet transitions background-color, border-color and color and
        // nothing else. Animating the box as well would make a size change
        // slide rather than land.
        return SizedBox(
          width: widget.expand ? double.infinity : null,
          // The height is fixed rather than a minimum, so a taller glyph or a
          // CJK label can never push one button out of line with its
          // neighbours.
          height: box.height,
          child: AnimatedContainer(
            duration: vars.motionDuration,
            curve: vars.motionEasing,
            padding: padding,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: borderRadius,
              boxShadow: lifted ? vars.shadow2xs : const <BoxShadow>[],
            ),
            // The hairline rides in the *foreground* decoration rather than the
            // background one: a `BoxDecoration.border` insets the content box by
            // its own width, which would make an outlined button a hairline
            // narrower inside than the filled one beside it.
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: border, width: context.hairlineWidth),
              borderRadius: borderRadius,
            ),
            child: AnimatedDefaultTextStyle(
              duration: vars.motionDuration,
              curve: vars.motionEasing,
              style: labelStyle.copyWith(color: content),
              softWrap: false,
              child: IconTheme(
                data: IconTheme.of(context).copyWith(
                  size: vars.spacing4,
                  color: content,
                ),
                child: Row(
                  mainAxisSize: widget.expand
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: _gap(vars, widget.size),
                  children: [
                    widget.child,
                    // A trailing shortcut is a hint, not part of the label — it
                    // takes the display cut and steps back.
                    if (widget.shortcut != null)
                      Opacity(
                        opacity: 0.7,
                        child: DefaultTextStyle.merge(
                          style: vars.labelStrong.copyWith(
                            fontSize: labelStyle.fontSize,
                            fontWeight: labelStyle.fontWeight,
                            height: 1,
                            color: content,
                          ),
                          child: widget.shortcut!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _gap(ThemeVariables vars, Size size) {
    if (size is! WidgetSize) return vars.controlSmallGap;
    return switch (size.namedSize) {
      NamedSize.tiny => vars.controlTinyGap,
      NamedSize.small => vars.controlSmallGap,
      NamedSize.medium => vars.controlMediumGap,
      NamedSize.large => vars.controlLargeGap,
    };
  }

  T _resolve<T>(
    ButtonThemeData theme,
    Set<WidgetState> states,
    ButtonVariant variant,
    WidgetProperty<T> Function(ButtonThemeData t) get,
  ) {
    final Color? seedColor = theme.color?.tinted(
      widget.tint ?? ButtonTint.primary,
    );
    return get(theme).resolveWith(
      states,
      tint: widget.tint,
      size: widget.size is WidgetSize ? widget.size as WidgetSize : null,
      variant: variant,
      extra: {
        'seedColor': seedColor,
      }..removeWhere((key, value) => value == null),
    );
  }
}

class _ButtonDefaults extends ButtonThemeData {
  _ButtonDefaults(this.context) : super();

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ThemeVariables _vars = _theme.vars;

  @override
  WidgetProperty<ColorSwatch<int>>? get color {
    return _vars.controlColor;
  }

  @override
  WidgetProperty<Size>? get minSize {
    return SizedWidgetProperty<Size>(
      tiny: Size.square(_vars.controlTinySize),
      small: Size.square(_vars.controlSmallSize),
      medium: Size.square(_vars.controlMediumSize),
      large: Size.square(_vars.controlLargeSize),
    );
  }

  @override
  WidgetProperty<EdgeInsets>? get margin {
    return WidgetPropertyAll<EdgeInsets>(EdgeInsets.zero);
  }

  @override
  WidgetProperty<EdgeInsets>? get padding {
    return SizedWidgetProperty<EdgeInsets>(
      tiny: EdgeInsets.symmetric(
        horizontal: _vars.controlTinyPaddingInline,
        vertical: _vars.controlTinyPaddingBlock,
      ),
      small: EdgeInsets.symmetric(
        horizontal: _vars.controlSmallPaddingInline,
        vertical: _vars.controlSmallPaddingBlock,
      ),
      medium: EdgeInsets.symmetric(
        horizontal: _vars.controlMediumPaddingInline,
        vertical: _vars.controlMediumPaddingBlock,
      ),
      large: EdgeInsets.symmetric(
        horizontal: _vars.controlLargePaddingInline,
        vertical: _vars.controlLargePaddingBlock,
      ),
    );
  }

  @override
  WidgetProperty<Color>? get surfaceColor {
    return _vars.controlColorSurface;
  }

  @override
  WidgetProperty<Color>? get contentColor {
    return _vars.controlColorContent;
  }

  @override
  WidgetProperty<Color>? get borderColor {
    return _vars.controlColorBorder;
  }

  @override
  WidgetProperty<BorderRadius>? get borderRadius {
    return SizedWidgetProperty<BorderRadius>(
      tiny: BorderRadius.circular(_vars.controlTinyRadius),
      small: BorderRadius.circular(_vars.controlSmallRadius),
      medium: BorderRadius.circular(_vars.controlMediumRadius),
      large: BorderRadius.circular(_vars.controlLargeRadius),
    );
  }

  /// The size profile carries the design's own control type — 11px on the
  /// smallest step and 12px from there up — so a button that re-pointed its
  /// type would run a step ahead of every other control on the same row.
  @override
  WidgetProperty<TextStyle>? get labelStyle {
    return SizedWidgetProperty<TextStyle>(
      tiny: _vars.labelSmall,
      small: _vars.labelMedium,
      medium: _vars.labelMedium,
      large: _vars.labelMedium,
    );
  }
}
