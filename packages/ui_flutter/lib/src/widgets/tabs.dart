import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

@immutable
class TabItem<T> {
  const TabItem({required this.value, required this.label, this.count});

  final T value;
  final Widget label;

  /// Trailing count, rendered inline — 收藏 64.
  final int? count;
}

/// Free-standing filter pills — 收藏 64 / 全部历史 / 我改过的 18.
class Tabs<T> extends StatelessWidget {
  const Tabs({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
    this.semanticsLabel,
  });

  final List<TabItem<T>> items;
  final T value;
  final ValueChanged<T>? onChanged;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.pill);

    return Semantics(
      label: semanticsLabel,
      container: semanticsLabel != null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Builder(
              builder: (context) {
                final item = items[i];
                final active = item.value == value;
                return Pressable(
                  onPressed:
                      onChanged == null ? null : () => onChanged!(item.value),
                  borderRadius: radius,
                  selected: active,
                  isButton: false,
                  builder: (context, state) => AnimatedContainer(
                    duration: kTransitionDuration,
                    // `h-6 px-3` — a fixed 24px pill.
                    height: 24,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: active
                          ? colors.accent
                          : (state.hovered ? colors.control : colors.inset),
                      borderRadius: radius,
                    ),
                    child: DefaultTextStyle(
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                        height: 1,
                        color: active ? colors.onAccent : colors.fgNav,
                      ),
                      child: item.count == null
                          ? item.label
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [item.label, Text(' ${item.count}')],
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
