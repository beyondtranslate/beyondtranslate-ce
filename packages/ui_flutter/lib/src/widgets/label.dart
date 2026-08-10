import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/theme/tokens.dart';
import 'package:flutter/widgets.dart';

enum LabelTone { subtle, faint, accent, warn, danger }

/// The micro-heading that organises every pane: 11pt semibold, sentence case.
/// AppKit uses a single size for these, so tone is the only variant.
class Label extends StatelessWidget {
  const Label({super.key, this.tone = LabelTone.subtle, required this.child});

  final LabelTone tone;
  final Widget child;

  static Color resolveColor(DesignColors colors, LabelTone tone) =>
      switch (tone) {
        LabelTone.subtle => colors.fgSubtle,
        LabelTone.faint => colors.fgFaint,
        LabelTone.accent => colors.accentText,
        LabelTone.warn => colors.warnStrong,
        LabelTone.danger => colors.dangerFg,
      };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DefaultTextStyle(
      style: tokens.typography.labelStyle(
        color: resolveColor(tokens.colors, tone),
      ),
      child: child,
    );
  }
}
