library;

export 'package:flutter/material.dart' show Brightness, SelectableText, Tooltip;
// These names collide with Flutter's own; this package's are the ones a
// consumer means. `Table`/`TableRow`/`TableCell` are the layout widgets —
// the design's grid is `Table`, and its parts carry the plain names.
// `FormField` is Flutter's form-state plumbing; the design's is the
// label/control/hint wrapper.
export 'package:flutter/widgets.dart'
    hide Banner, FormField, RadioGroup, Table, TableCell, TableRow;

export 'src/foundation/color_descriptor.dart';
export 'src/foundation/extensions/color.dart';
export 'src/foundation/widget_size.dart';
export 'src/foundation/widget_tint.dart';
export 'src/foundation/widget_variant.dart';
export 'src/generated/colors.dart';
export 'src/generated/theme_variables.dart';
export 'src/theme/theme.dart';
export 'src/widgets/action_bar.dart';
export 'src/widgets/badge.dart';
export 'src/widgets/button.dart';
export 'src/widgets/callout.dart';
export 'src/widgets/card.dart';
export 'src/widgets/checkbox.dart';
export 'src/widgets/dialog.dart';
export 'src/widgets/divider.dart';
export 'src/widgets/empty_state.dart';
export 'src/widgets/focus_ring.dart';
export 'src/widgets/form_field.dart';
export 'src/widgets/icon_button.dart';
export 'src/widgets/key_cap.dart';
export 'src/widgets/menu.dart';
export 'src/widgets/nav_item.dart';
export 'src/widgets/option_card.dart';
export 'src/widgets/pill_tabs.dart';
export 'src/widgets/preference.dart';
export 'src/widgets/pressable.dart';
export 'src/widgets/progress.dart';
export 'src/widgets/radio.dart';
export 'src/widgets/rail.dart';
export 'src/widgets/search_field.dart';
export 'src/widgets/section_label.dart';
export 'src/widgets/segmented_control.dart';
export 'src/widgets/sidebar.dart';
export 'src/widgets/spinner.dart';
export 'src/widgets/step_list.dart';
export 'src/widgets/switch.dart';
export 'src/widgets/table.dart';
export 'src/widgets/text_field.dart';
export 'src/widgets/toast.dart';
