import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'section_label.dart';

/// The left workspace column.
///
/// Its width is a token rather than a layout choice because the columns of a
/// desktop shell have to agree with each other: the header strip is exactly
/// the titlebar's height, or the separator under the two steps where they
/// meet.
///
/// The rows inside are [NavItem]s — a sidebar owns the column, not the rows.
class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    this.header,
    this.width,
    required this.children,
  });

  /// Content for the strip above the row list, held at exactly the titlebar's
  /// height so it lines up with the toolbar in the pane beside it.
  final Widget? header;

  /// An explicit width. Leave it out and the column takes the token's.
  final double? width;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      width: width ?? vars.frameSidebarWidth,
      decoration: BoxDecoration(
        color: vars.colorSurfaceMuted,
        border: BorderDirectional(
          end: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Container(
              height: vars.frameTitlebarSize,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.symmetric(horizontal: vars.spacing4),
              child: header!,
            ),
          // Only the row list scrolls, so a pinned card stays put.
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: vars.spacing35,
                horizontal: vars.spacing25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: vars.frameNavGap,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A labelled run of rows.
///
/// A sidebar breaks its rows into groups rather than stacking them; the gap
/// between groups does most of the work and the label only names it.
class SidebarGroup extends StatelessWidget {
  const SidebarGroup({super.key, this.label, required this.children});

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: vars.frameNavGap,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: vars.spacing25,
              vertical: vars.spacing1,
            ),
            child: SectionLabel(label!, tone: SectionLabelTone.faint),
          ),
        ...children,
      ],
    );
  }
}

/// The card pinned to the foot of a sidebar — a count, a version, a queue.
class SidebarCard extends StatelessWidget {
  const SidebarCard({super.key, this.label, required this.children});

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      padding: EdgeInsets.all(vars.spacing3),
      decoration: BoxDecoration(
        color: vars.colorSurface,
        border: Border.all(
          color: vars.colorBorder,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(vars.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: vars.spacing2,
        children: [
          if (label != null) SectionLabel(label!),
          ...children,
        ],
      ),
    );
  }
}
