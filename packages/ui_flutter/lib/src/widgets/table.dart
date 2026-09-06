import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// Which edge a cell's text sits against.
enum TableCellAlign { start, end }

/// A flex grid rather than a real table: rows are often clickable and column
/// widths are set by the design, both of which a table layout fights. The
/// semantics keep it announced as a table anyway.
class Table extends StatelessWidget {
  const Table({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// The head strip.
class TableHead extends StatelessWidget {
  const TableHead({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: vars.spacing5),
      decoration: BoxDecoration(
        color: vars.colorSurfaceChrome,
        border: Border(
          bottom: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(children: children),
    );
  }
}

/// One row.
class TableRow extends StatelessWidget {
  const TableRow({
    super.key,
    required this.children,
    this.active = false,
    this.onPressed,
  });

  final List<Widget> children;
  final bool active;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Pressable(
      onPressed: onPressed,
      enabled: onPressed != null,
      selected: active,
      isButton: false,
      showFocusRing: onPressed != null,
      cursor: onPressed == null ? MouseCursor.defer : null,
      builder: (context, states) {
        final bool hovered = states.contains(WidgetState.hovered);

        Color? surface;
        if (active) {
          // The surface wash, not the `tinted` recipe's chip fill: a selected
          // row is a band the width of the table, and the chip's 12% reads as
          // a block on it.
          surface = vars.colorPrimary[600]!.withValues(alpha: vars.washSurface);
        } else if (hovered && onPressed != null) {
          // Neutral, because the tinted selection sits one step lower on the
          // ramp and a tinted hover would read as the heavier of the two.
          surface = vars.colorSurfaceSubtle;
        }

        return AnimatedContainer(
          duration: vars.motionDuration,
          curve: vars.motionEasing,
          padding: EdgeInsets.symmetric(
            vertical: vars.spacing3,
            horizontal: vars.spacing5,
          ),
          decoration: BoxDecoration(
            color: surface,
            border: Border(
              bottom: BorderSide(
                color: vars.colorBorder,
                width: context.hairlineWidth,
              ),
            ),
          ),
          child: DefaultTextStyle(
            style: vars.bodyMedium.copyWith(color: vars.colorContent),
            child: Row(children: children),
          ),
        );
      },
    );
  }
}

/// One cell.
class TableCell extends StatelessWidget {
  const TableCell({
    super.key,
    required this.child,
    this.head = false,
    this.align = TableCellAlign.start,
    this.width,
    this.flex = 1,
  });

  final Widget child;

  /// A head cell takes the label face in the faint ink and its own block pad.
  final bool head;

  final TableCellAlign align;

  /// A fixed column width. Without one the cell shares the row by [flex].
  final double? width;

  final int flex;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    Widget content = Align(
      alignment: align == TableCellAlign.end
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: child,
    );

    if (head) {
      content = Padding(
        padding: EdgeInsets.symmetric(vertical: vars.spacing2),
        child: DefaultTextStyle(
          style: vars.labelSmall.copyWith(color: vars.colorContentFaint),
          child: content,
        ),
      );
    }

    if (width != null) return SizedBox(width: width, child: content);
    return Expanded(flex: flex, child: content);
  }
}
