import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/font_face.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'icon_button.dart';

/// How long the tick stands after a copy.
const Duration _kCopied = Duration(milliseconds: 1600);

/// A run of code inside a sentence — a flag, a path, an identifier.
///
/// A wash and a face, not a box: the chip corner and the half-step inset keep
/// it separable from the prose around it without breaking the line's rhythm,
/// which is what a border at this size always does.
///
/// Inside a paragraph it goes in a [WidgetSpan]; on its own it is a widget
/// like any other.
class Code extends StatelessWidget {
  const Code(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: vars.spacing1,
        vertical: vars.spacing05,
      ),
      decoration: BoxDecoration(
        color: vars.colorSurfaceSunken,
        borderRadius: BorderRadius.circular(vars.radiusTiny),
      ),
      child: Text(
        code,
        // A step under the prose it sits in: a monospace face at the same
        // nominal size always reads larger, and the run would ride above the
        // line.
        style: vars.captionSmall
            .inFace(vars.fontCode)
            .copyWith(color: vars.colorContent),
      ),
    );
  }
}

/// A block of code, read rather than edited.
///
/// The gutter is a column of its own rather than text in the same run, so a
/// selection that crosses ten lines takes ten lines of code and not ten line
/// numbers — the single thing a reader does with one of these, and the thing a
/// numbered run gets wrong. It is also outside the scroller, so it stays put
/// while the code slides under it.
///
/// A head is drawn only where there is something to put in it. A block with no
/// title, no language and nothing to press is the code alone, because a bar
/// holding one label says less than the space it takes.
///
/// The block scrolls sideways and sizes to its lines vertically: how tall a
/// listing is allowed to be is the page's decision, not the listing's.
class CodeBlock extends StatefulWidget {
  const CodeBlock({
    super.key,
    required this.code,
    this.title,
    this.language,
    this.lineNumbers = false,
    this.wrap = false,
    this.copyable = false,
    this.actions,
  });

  /// The source, verbatim. Trailing newlines are trimmed.
  final String code;

  /// What the block is — a path, a filename, a shell's name.
  final String? title;

  /// Named at the trailing edge of the head, and nothing more: this package
  /// ships no highlighter, because a grammar per language is a dependency a
  /// design system has no opinion about.
  final String? language;

  final bool lineNumbers;

  /// Wraps long lines instead of scrolling them. A wrapped line of code has
  /// lost what its indentation was carrying, so scrolling is the default.
  final bool wrap;

  final bool copyable;

  /// Extra affordances in the head, before the copy button.
  final List<Widget>? actions;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  String get _body => widget.code.replaceAll(RegExp(r'\n+$'), '');

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _body));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(_kCopied);
    // The tick outlives the copy by a second and a half, so the block may be
    // gone by the time it should be cleared.
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final List<String> lines = _body.split('\n');
    final bool head =
        widget.title != null ||
        widget.language != null ||
        widget.copyable ||
        (widget.actions?.isNotEmpty ?? false);

    // Both columns are set in one face at one size with one leading, and that
    // is what aligns them: a number and its line are two boxes agreeing on a
    // line box, not one box holding both.
    final TextStyle face = vars.captionSmall
        .inFace(vars.fontCode)
        .copyWith(height: vars.bodySmall.height);

    Widget code = Text(
      _body,
      softWrap: widget.wrap,
      style: face.copyWith(color: vars.colorContent),
    );
    code = Padding(
      padding: EdgeInsetsDirectional.only(
        // The gutter already pays the leading inset.
        start: widget.lineNumbers ? 0 : vars.spacing3,
        end: vars.spacing3,
      ),
      child: code,
    );
    if (!widget.wrap) {
      code = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: code,
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // The card's materials, not the popup's: this sits *in* the page
        // rather than over it, so it takes the muted surface and the ordinary
        // border rather than the overlay's edge and shadow.
        color: vars.colorSurfaceMuted,
        border: Border.all(
          color: vars.colorBorder,
          width: vars.strokeHairline,
        ),
        // A panel that grows with its listing, so it takes the shared corner
        // for a box that grows rather than Bright's control pill.
        borderRadius: BorderRadius.circular(vars.controlContainerRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (head) _head(context, vars),
          Padding(
            padding: EdgeInsets.symmetric(vertical: vars.spacing25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.lineNumbers) _gutter(vars, lines.length, face),
                if (widget.wrap)
                  Expanded(child: code)
                else
                  Flexible(child: code),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _head(BuildContext context, ThemeVariables vars) {
    return Container(
      constraints: BoxConstraints(minHeight: vars.spacing8),
      padding: EdgeInsets.symmetric(
        horizontal: vars.spacing3,
        vertical: vars.spacing1,
      ),
      decoration: BoxDecoration(
        // Chrome, and it reads as chrome: the titlebar's step and a rule
        // under it.
        color: vars.colorSurfaceChrome,
        border: Border(
          bottom: BorderSide(
            color: vars.colorBorder,
            width: vars.strokeHairline,
          ),
        ),
      ),
      child: Row(
        spacing: vars.spacing2,
        children: <Widget>[
          if (widget.title != null)
            Flexible(
              child: Text(
                widget.title!,
                overflow: TextOverflow.ellipsis,
                // Set in the code face too: the title is nearly always a path
                // or a filename, and a proportional face beside a monospace
                // body reads as a different document rather than as its label.
                style: vars.captionSmall
                    .inFace(vars.fontCode)
                    .copyWith(color: vars.colorContentSecondary),
              ),
            ),
          if (widget.language != null)
            Text(
              widget.language!.toUpperCase(),
              style: vars.labelSmall.copyWith(
                fontWeight: vars.labelMedium.fontWeight,
                color: vars.colorContentFaint,
              ),
            ),
          // Pushed to the trailing edge whichever of the two labels before it
          // are drawn, which is why this is a spacer rather than a
          // `spaceBetween` on the row.
          const Spacer(),
          ...?widget.actions,
          if (widget.copyable)
            IconButton(
              semanticsLabel: _copied ? 'Copied' : 'Copy',
              icon: Icon(
                _copied
                    ? FluentIcons.checkmark_16_regular
                    : FluentIcons.copy_16_regular,
              ),
              onPressed: _copy,
            ),
        ],
      ),
    );
  }

  Widget _gutter(ThemeVariables vars, int count, TextStyle face) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: vars.spacing3),
      child: SizedBox(
        // Right-aligned so the ones column stays a column past line 9, and
        // wide enough for four digits before it starts pushing the code
        // across.
        width: vars.spacing10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int line = 1; line <= count; line++)
              Text(
                '$line',
                style: face.copyWith(color: vars.colorContentFaint),
              ),
          ],
        ),
      ),
    );
  }
}
