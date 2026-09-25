import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart' show DesignThemeFamily;
import 'native_select.dart' show NativeSelect, NativeSelectItem;

/// The palettes, as a menu of their names.
///
/// There used to be six, drawn as a row of swatches that were their own
/// preview. The kit now ships dozens — the desktops and Omarchy's themes
/// beside its own — which no row holds, so the choice is a menu like the
/// display language's: the platform's own, which scrolls when it has to, with
/// a separator between the kit's families, the desktops and Omarchy's.
/// Picking one still repaints everything at once, so the window is the
/// preview.
class ThemeFamilyPicker extends StatelessWidget {
  const ThemeFamilyPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DesignThemeFamily value;
  final ValueChanged<DesignThemeFamily> onChanged;

  /// The menu's rows, in the families' own order, a separator opening each
  /// group after the first.
  static List<NativeSelectItem<DesignThemeFamily>> get items => [
        for (final (int i, DesignThemeFamily family)
            in DesignThemeFamily.values.indexed)
          NativeSelectItem(
            value: family,
            label: family.label,
            separatorBefore:
                i > 0 && DesignThemeFamily.values[i - 1].group != family.group,
          ),
      ];

  @override
  Widget build(BuildContext context) {
    // The select fills its box, so the box is what takes the value's width.
    return IntrinsicWidth(
      child: NativeSelect<DesignThemeFamily>(
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
