import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/window_frame.dart';
import 'package:flutter/widgets.dart';

/// A browser window, used to show the extension acting on a real page.
class BrowserFrame extends StatelessWidget {
  const BrowserFrame({
    super.key,
    required this.url,
    this.status,
    this.width = 700,
    this.child,
  });

  final String url;

  /// Right-hand chip in the toolbar — "B 已翻译".
  final Widget? status;
  final double width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final hairline = context.hairlineWidth;

    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.window,
        border: Border.all(color: colors.hairlineStrong, width: hairline),
        borderRadius: BorderRadius.circular(14),
        boxShadow: tokens.shadows.popover,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.inset,
              border: Border(
                bottom: BorderSide(color: colors.hairline, width: hairline),
              ),
            ),
            child: Row(
              children: [
                const TrafficLights(size: TrafficLightsSize.sm),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors.window,
                      border: Border.all(
                        color: colors.hairlineStrong,
                        width: hairline,
                      ),
                      borderRadius: BorderRadius.circular(tokens.radii.chip),
                    ),
                    child: Text(
                      url,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.monoStyle(
                        fontSize: 11,
                        color: colors.fgTertiary,
                      ),
                    ),
                  ),
                ),
                if (status != null) ...[const SizedBox(width: 12), status!],
              ],
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// The collapsed control bar that sits over a translated page.
class FloatingToolbar extends StatelessWidget {
  const FloatingToolbar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.window,
        border: Border.all(
          color: colors.hairlineStrong,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.pill),
        boxShadow: tokens.shadows.lift,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 7),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Thin vertical rule between floating-toolbar items.
class ToolbarSeparator extends StatelessWidget {
  const ToolbarSeparator({super.key});

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Container(
          width: context.hairlineWidth,
          height: 14,
          color: context.colors.hairlineStrong,
        ),
      );
}
