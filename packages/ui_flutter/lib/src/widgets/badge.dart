import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../foundation/widget_variant.dart';
import '../generated/theme_variables.dart';
import '../painting/widget_property.dart';
import '../theme/theme.dart';
import 'badge_theme.dart';

/// An enum to define the tint of a badge.
enum BadgeTint with WidgetTint {
  /// A badge indicating a primary action.
  primary,

  /// A badge indicating a neutral action.
  neutral,

  /// A badge indicating an info.
  info,

  /// A badge indicating a success.
  success,

  /// A badge indicating a warning.
  warning,

  /// A badge indicating a danger.
  danger,
}

enum BadgeVariant with WidgetVariant {
  filled,
  tinted,
  outlined,
  plain,

  /// The badge that sits on a grey card: paper fill, quiet ink.
  raised,
}

/// A badge widget.
///
/// Takes in a text or an icon that fades out and in on touch. May optionally have a
/// background.
///
/// The [padding] defaults to 16.0 pixels. When using a [Badge] within
/// a fixed height parent, like a [CupertinoNavigationBar], a smaller, or even
/// [EdgeInsets.zero], should be used to prevent clipping larger [child]
/// widgets.
///
/// Preserves any parent [IconThemeData] but overwrites its [IconThemeData.color]
/// with the [CupertinoThemeData.primaryColor] (or
/// [CupertinoThemeData.primaryContrastingColor] if the badge is disabled).
///
/// {@tool dartpad}
/// This sample shows produces an enabled and disabled [Badge] and
/// [Badge.filled].
///
/// ** See code in examples/api/lib/cupertino/badge/cupertino_badge.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * <https://developer.apple.com/design/human-interface-guidelines/badges/>
class Badge extends StatefulWidget {
  /// Creates an iOS-style badge.
  const Badge({
    super.key,
    required this.child,
    this.variant,
    this.tint,
    this.size = WidgetSize.medium,
  });

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The tint of the badge.
  ///
  /// Defaults to null.
  final BadgeTint? tint;

  /// The variant of the badge.
  ///
  /// Defaults to null.
  final BadgeVariant? variant;

  /// The size of the badge.
  ///
  /// Defaults to [WidgetSize.medium].
  final Size size;

  @override
  State<Badge> createState() => _BadgeState();
}

class _BadgeState extends State<Badge> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeDefaults = _BadgeDefaults(context);
    final badgeTheme = BadgeTheme.of(context).merge(themeDefaults);
    final ThemeVariables vars = Theme.of(context).vars;
    final BadgeVariant variant = widget.variant ?? BadgeVariant.tinted;

    // Resolve the property for the given theme.
    T resolve<T>(
      WidgetProperty<T> Function(BadgeThemeData theme) getProperty,
    ) {
      Color? seedColor = badgeTheme.color?.tinted(
        widget.tint ?? BadgeTint.primary,
      );
      return getProperty(badgeTheme).resolveWith(
        {},
        tint: widget.tint,
        size: widget.size is WidgetSize ? widget.size as WidgetSize : null,
        variant: variant == BadgeVariant.raised ? BadgeVariant.plain : variant,
        extra: {
          'seedColor': seedColor,
        }..removeWhere((key, value) => value == null),
      );
    }

    EdgeInsets padding = resolve<EdgeInsets>((t) => t.padding!);
    Color backgroundColor = resolve<Color>((t) => t.surfaceColor!);
    Color foregroundColor = resolve<Color>((t) => t.contentColor!);
    Color borderColor = resolve<Color>((t) => t.borderColor!);
    BorderRadius borderRadius = resolve<BorderRadius>((t) => t.borderRadius!);
    TextStyle labelStyle = resolve<TextStyle>((t) => t.labelStyle!);

    if (variant == BadgeVariant.raised) {
      backgroundColor = vars.colorSurface;
      foregroundColor = vars.colorContentMuted;
      borderColor = const Color(0x00000000);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      // The edge rides in the *foreground* decoration so that it paints over
      // the fill rather than insetting the content box, and the padding
      // carries its width instead. That is what the stylesheet does: a badge
      // has a transparent border on every variant — so `outlined` does not
      // gain a pixel per side and fall off the heights the others share —
      // and with no height declared on the box, that border adds to the
      // outer height the way any border does.
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: borderColor, width: vars.spacingPx),
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: padding + EdgeInsets.all(vars.spacingPx),
        child: Align(
          alignment: Alignment.center,
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: DefaultTextStyle(
            style: labelStyle.copyWith(
              color: foregroundColor,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: foregroundColor,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeDefaults extends BadgeThemeData {
  _BadgeDefaults(this.context) : super();

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ThemeVariables _vars = _theme.vars;

  @override
  WidgetProperty<ColorSwatch<int>>? get color {
    return _vars.controlColor;
  }

  @override
  WidgetProperty<Size>? get minSize {
    return WidgetPropertyAll<Size>(Size.zero);
  }

  @override
  WidgetProperty<EdgeInsets>? get margin {
    return WidgetPropertyAll<EdgeInsets>(EdgeInsets.zero);
  }

  /// Two capsule densities on the chip corner; the type moves one step at
  /// the top. A badge is an annotation — it never reaches control height, so
  /// these are its own pads rather than the control profile's.
  @override
  WidgetProperty<EdgeInsets>? get padding {
    return SizedWidgetProperty<EdgeInsets>(
      small: EdgeInsets.symmetric(
        horizontal: _vars.spacing15,
        vertical: _vars.spacing05,
      ),
      medium: EdgeInsets.symmetric(
        horizontal: _vars.spacing2,
        vertical: _vars.spacing05,
      ),
      large: EdgeInsets.symmetric(
        horizontal: _vars.spacing2,
        vertical: _vars.spacing1,
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
    return WidgetPropertyAll<BorderRadius>(
      BorderRadius.circular(_vars.radiusTiny),
    );
  }

  /// The display cut at label weight: a badge's label has to read as an
  /// annotation, not as body copy, so the face and weight never soften
  /// whatever the size — only the step moves at the top.
  @override
  WidgetProperty<TextStyle>? get labelStyle {
    final TextStyle face = _vars.labelStrong.copyWith(
      fontWeight: _vars.labelMedium.fontWeight,
      height: 1.4,
    );
    return SizedWidgetProperty<TextStyle>(
      small: face.copyWith(fontSize: _vars.labelSmall.fontSize),
      medium: face.copyWith(fontSize: _vars.labelSmall.fontSize),
      large: face.copyWith(fontSize: _vars.labelMedium.fontSize),
    );
  }
}
