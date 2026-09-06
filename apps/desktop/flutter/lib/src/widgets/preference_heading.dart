/// A preference section whose heading carries a control.
///
/// The kit's [PreferenceSection] takes an `action` for exactly this, but the
/// slot it puts the control in cannot lay out: `_HeadingAction` is an
/// `OverflowBox` at its default `OverflowBoxFit.max`, so it sizes itself to
/// the constraints it is handed rather than to its child — and a `Row` hands a
/// non-flexible child an unbounded main axis. The slot takes an infinite width
/// and the section throws before it paints, whatever is passed as the action.
///
/// The vendored package is upstream's, so the fix is not made there. The app
/// draws the heading line itself instead and hands the kit the rows, which is
/// the whole of what it needs from the widget. `Align` does the same job the
/// kit's slot was reaching for and shrink-wraps its child, so an unbounded
/// width is no longer a problem: `heightFactor: 0` reports no height at all,
/// letting the control overhang the line above and below, so a heading with a
/// button stays exactly as tall as one without and two sections on a page
/// start at the same height.
///
/// `PreferenceGroup` builds its heading from the same slot, so its `action:`
/// is unusable for the same reason. Nothing here passes one; a group that
/// needs a control on its heading wants the same treatment.
///
/// Delete this once `PreferenceSection`'s own action slot lays out, and pass
/// `action:` again.
library;

import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        PreferenceSection,
        SectionLabel,
        ThemeDataBuildContextProps,
        ThemeVariables;

class PreferenceSectionWithAction extends StatelessWidget {
  const PreferenceSectionWithAction({
    super.key,
    required this.label,
    required this.action,
    this.footer,
    required this.children,
  });

  final String label;

  /// Sits on the heading's line, at its right.
  final Widget action;

  final String? footer;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = context.vars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: vars.spacing3),
          child: Row(
            spacing: vars.spacing4,
            children: [
              Expanded(child: SectionLabel(label)),
              Align(widthFactor: 1, heightFactor: 0, child: action),
            ],
          ),
        ),
        PreferenceSection(footer: footer, children: children),
      ],
    );
  }
}
