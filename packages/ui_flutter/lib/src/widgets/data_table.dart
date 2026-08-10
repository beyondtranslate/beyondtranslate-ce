import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// The glossary table is a column of flex rows rather than a real table: rows
/// are clickable and column widths are fixed by the design.
class DataTable extends StatelessWidget {
  const DataTable({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
}

class DataTableHead extends StatelessWidget {
  const DataTableHead({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.chrome,
        border: Border(
          bottom: BorderSide(
            color: colors.hairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(children: children),
    );
  }
}

class DataTableRow extends StatelessWidget {
  const DataTableRow({
    super.key,
    this.active = false,
    this.onPressed,
    required this.children,
  });

  final bool active;

  /// Rows select a term, so an interactive one is reachable and operable from
  /// the keyboard as well as the mouse.
  final VoidCallback? onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hairline = context.hairlineWidth;

    Widget buildRow(bool hovered) => AnimatedContainer(
          duration: kTransitionDuration,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? colors.accentSurface
                : (hovered ? colors.subtle : null),
            border: Border(
              bottom: BorderSide(color: colors.hairlineSoft, width: hairline),
            ),
          ),
          child: Row(children: children),
        );

    if (onPressed == null) return buildRow(false);

    return Pressable(
      onPressed: onPressed,
      selected: active,
      isButton: false,
      showFocusRing: false,
      builder: (context, state) => buildRow(state.hovered),
    );
  }
}

enum DataTableCellAlign { start, end }

class DataTableCell extends StatelessWidget {
  const DataTableCell({
    super.key,
    this.head = false,
    this.align = DataTableCellAlign.start,
    this.width,
    this.flex = 1,
    required this.child,
  });

  /// Column heading styling.
  final bool head;
  final DataTableCellAlign align;

  /// A fixed column width, as the design specifies for the trailing columns.
  final double? width;

  /// Share of the remaining space when [width] is not given.
  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    Widget content = Align(
      alignment: align == DataTableCellAlign.start
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: head
          ? DefaultTextStyle(
              style: tokens.typography.labelStyle(color: tokens.colors.fgFaint),
              child: child,
            )
          : child,
    );

    if (head) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: content,
      );
    }

    if (width != null) return SizedBox(width: width, child: content);
    return Expanded(flex: flex, child: content);
  }
}
