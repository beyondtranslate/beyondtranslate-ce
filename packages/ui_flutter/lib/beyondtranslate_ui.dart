library;

// These names collide with Flutter's own; this package's are the ones a
// consumer means. `Table`/`TableRow`/`TableCell` are the layout widgets —
// the design's grid is `Table`, and its parts carry the plain names.
// `FormField` is Flutter's form-state plumbing and `Form` its validation
// machinery; the design's are the label/control/hint wrapper and the run of
// fields that distributes a server's errors across them.
export 'package:flutter/widgets.dart'
    hide Banner, Form, FormField, RadioGroup, Table, TableCell, TableRow;

export 'src/foundation/color_descriptor.dart';
export 'src/foundation/extensions/color.dart';
export 'src/foundation/font_face.dart';
export 'src/foundation/theme_extension.dart';
export 'src/foundation/widget_size.dart';
export 'src/foundation/widget_tint.dart';
export 'src/foundation/widget_variant.dart';
export 'src/generated/colors.dart';
export 'src/generated/theme_variables.dart';
export 'src/theme/theme.dart';
export 'src/widgets/accordion.dart';
export 'src/widgets/action_bar.dart';
export 'src/widgets/avatar.dart';
export 'src/widgets/badge.dart';
export 'src/widgets/button.dart';
export 'src/widgets/callout.dart';
export 'src/widgets/card.dart';
export 'src/widgets/checkbox.dart';
export 'src/widgets/checkbox_group.dart';
export 'src/widgets/code.dart';
export 'src/widgets/collapsible.dart';
export 'src/widgets/combobox.dart';
export 'src/widgets/context_menu.dart';
export 'src/widgets/dialog.dart';
export 'src/widgets/divider.dart';
export 'src/widgets/drawer.dart';
export 'src/widgets/empty_state.dart';
export 'src/widgets/field_box.dart';
export 'src/widgets/focus_ring.dart';
export 'src/widgets/form.dart';
export 'src/widgets/form_field.dart';
export 'src/widgets/icon_button.dart';
export 'src/widgets/key_cap.dart';
export 'src/widgets/link.dart';
export 'src/widgets/menu.dart';
export 'src/widgets/menubar.dart';
export 'src/widgets/meter.dart';
export 'src/widgets/nav_item.dart';
export 'src/widgets/number_field.dart';
export 'src/widgets/option_card.dart';
export 'src/widgets/otp_field.dart';
export 'src/widgets/pill_tabs.dart';
export 'src/widgets/popover.dart';
export 'src/widgets/preferences.dart';
export 'src/widgets/pressable.dart';
export 'src/widgets/preview_card.dart';
export 'src/widgets/progress.dart';
export 'src/widgets/radio.dart';
export 'src/widgets/rail.dart';
export 'src/widgets/search_field.dart';
export 'src/widgets/section_label.dart';
export 'src/widgets/segmented_control.dart';
export 'src/widgets/select.dart';
export 'src/widgets/sidebar.dart';
export 'src/widgets/skeleton.dart';
export 'src/widgets/slider.dart';
export 'src/widgets/spinner.dart';
export 'src/widgets/splitter.dart';
export 'src/widgets/step_list.dart';
export 'src/widgets/switch.dart';
export 'src/widgets/table.dart';
export 'src/widgets/tag.dart';
export 'src/widgets/text_field.dart';
export 'src/widgets/toast.dart';
export 'src/widgets/toggle.dart';
export 'src/widgets/tree.dart';
