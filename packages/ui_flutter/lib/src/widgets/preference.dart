import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';
import 'section_label.dart';

/// The settings column.
///
/// The spacing is the whole design here. Rows sit close together, a heading
/// sits further from the section above it than from its own rows, and a group
/// title stands further still — so a heading always reads as belonging to
/// what follows it rather than floating between two blocks.

/// A group of sections, with a title that outranks them.
class PreferenceGroup extends StatelessWidget {
  const PreferenceGroup({
    super.key,
    required this.title,
    this.description,
    this.action,
    required this.children,
  });

  final String title;
  final String? description;
  final Widget? action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: vars.spacing3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: vars.spacing4,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: vars.spacing15,
                  children: [
                    // The group outranks its sections typographically: the
                    // display cut at the strong weight, where a section
                    // heading is a SectionLabel.
                    Text(
                      title,
                      style: vars.labelStrong.copyWith(
                        color: vars.colorContent,
                      ),
                    ),
                    if (description != null)
                      Text(
                        description!,
                        style: vars.captionSmall.copyWith(
                          height: 1.7,
                          color: vars.colorContentSubtle,
                        ),
                      ),
                  ],
                ),
              ),
              if (action != null) _HeadingAction(child: action!),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: vars.spacing4 + vars.spacing05,
          children: children,
        ),
      ],
    );
  }
}

/// A labelled run of rows.
class PreferenceSection extends StatelessWidget {
  const PreferenceSection({
    super.key,
    this.label,
    this.footer,
    this.action,
    required this.children,
  });

  final String? label;
  final String? footer;
  final Widget? action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || action != null)
          Padding(
            padding: EdgeInsets.only(bottom: vars.spacing3),
            child: Row(
              spacing: vars.spacing4,
              children: [
                Expanded(
                  child: label == null
                      ? const SizedBox.shrink()
                      : SectionLabel(label!),
                ),
                if (action != null) _HeadingAction(child: action!),
              ],
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: vars.spacing1,
          children: children,
        ),
        if (footer != null)
          Padding(
            padding: EdgeInsets.only(top: vars.spacing2),
            child: Text(
              footer!,
              style: vars.captionSmall.copyWith(
                height: 1.7,
                color: vars.colorContentSubtle,
              ),
            ),
          ),
      ],
    );
  }
}

/// A heading's control sits in a zero-height slot it overhangs on both sides.
///
/// Letting a full-height control size the line would make a heading with a
/// button taller than one without, and two sections on the same page would
/// then start at different heights. Zero rather than a negative margin, so it
/// holds for any control height and any heading size.
class _HeadingAction extends StatelessWidget {
  const _HeadingAction({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      child: OverflowBox(
        minHeight: 0,
        maxHeight: double.infinity,
        child: child,
      ),
    );
  }
}

/// One decision.
///
/// A row's height is a minimum plus a pad on its text, never a fixed height.
/// The minimum keeps the text column in one rhythm whatever control sits on
/// the right; the pad rides on the text so a row grows for content — a
/// subtitle, a wrapped title — and never for a control.
class PreferenceRow extends StatelessWidget {
  const PreferenceRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onPressed,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool interactive = onPressed != null;

    Widget content(Set<WidgetState> states) {
      final bool hovered = states.contains(WidgetState.hovered);

      final Widget row = Row(
        spacing: vars.spacing25,
        children: [
          // Uncoloured on purpose: a Badge or a Switch in these slots keeps
          // its own ink rather than inheriting a wash.
          ?icon,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vars.spacing1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: vars.spacing1,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vars.labelMedium.copyWith(
                      color: vars.colorContent,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: vars.captionSmall.copyWith(
                        color: vars.colorContentSubtle,
                      ),
                    ),
                ],
              ),
            ),
          ),
          ?trailing,
        ],
      );

      if (!interactive) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: vars.controlMediumSize),
          child: row,
        );
      }

      // The wash bleeds sideways past the text while the row still starts on
      // the same left edge as the inert rows above it — a Stack rather than a
      // negative margin, which Flutter rejects. It previews selection (the
      // accent's quiet step) because an interactive row here opens something.
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: vars.controlMediumSize),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: -vars.spacing2,
              right: -vars.spacing2,
              child: AnimatedContainer(
                duration: vars.motionDuration,
                curve: vars.motionEasing,
                decoration: BoxDecoration(
                  color: hovered
                      ? vars
                            .colorPrimary[vars
                                .controlColorPlainSurface
                                .hoveredShade!]!
                            .withValues(
                              alpha:
                                  vars.controlColorPlainSurface.hoveredOpacity,
                            )
                      : null,
                  borderRadius: BorderRadius.circular(vars.radiusSmall),
                ),
              ),
            ),
            row,
          ],
        ),
      );
    }

    if (!interactive) return content(const {});

    return Pressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(vars.radiusSmall),
      builder: (context, states) => content(states),
    );
  }
}
