/// The BeyondTranslate design system for Flutter.
///
/// A port of the React `@beyondtranslate/ui` atoms: same tokens, same four
/// themes, same widgets — under plain, generic names.
///
/// The boundary is the React package's: nothing here knows a BeyondTranslate
/// concept. The product's own widgets that compose these — the language pair,
/// the glossary mark, the provider row, the floating ball — live in the app, at
/// `apps/desktop/flutter/lib/src/widgets/`, the way React's live in
/// `apps/storybook/src/components`.
///
/// Several of the exported names (`Badge`, `Button`, `Checkbox`, `Dialog`,
/// `Divider`, `IconButton`, `Radio`, `Step`, `Switch`) are also Material's. This
/// package never imports Material, so nothing clashes internally, but an app
/// that uses both should import one of them with a prefix:
///
/// ```dart
/// import 'package:beyondtranslate_ui/beyondtranslate_ui.dart' as ui;
/// ```
///
/// Wrap the tree in a [DesignThemeProvider] to establish the palette:
///
/// ```dart
/// DesignThemeProvider(
///   theme: DesignThemeName.studioLight,
///   child: ui.Button(variant: ui.ButtonVariant.primary, child: Text('翻译')),
/// )
/// ```
library;

export 'src/theme/text_styles.dart';
export 'src/theme/theme.dart';
export 'src/theme/themes.dart';
export 'src/theme/tokens.dart';
export 'src/widgets/badge.dart';
export 'src/widgets/brand_logo.dart';
export 'src/widgets/browser_frame.dart';
export 'src/widgets/button.dart';
export 'src/widgets/callout.dart';
export 'src/widgets/checkbox.dart';
export 'src/widgets/data_table.dart';
export 'src/widgets/dialog.dart';
export 'src/widgets/empty_state.dart';
export 'src/widgets/field.dart';
export 'src/widgets/focus_ring.dart';
export 'src/widgets/icon_button.dart';
export 'src/widgets/kbd.dart';
export 'src/widgets/label.dart';
export 'src/widgets/menu.dart';
export 'src/widgets/option_card.dart';
export 'src/widgets/popover.dart';
export 'src/widgets/preference.dart';
export 'src/widgets/pressable.dart';
export 'src/widgets/progress.dart';
export 'src/widgets/radio.dart';
export 'src/widgets/search_field.dart';
export 'src/widgets/segmented_control.dart';
export 'src/widgets/shortcut_recorder.dart';
export 'src/widgets/sidebar.dart';
export 'src/widgets/stage.dart';
export 'src/widgets/step_list.dart';
export 'src/widgets/surface.dart';
export 'src/widgets/switch.dart';
export 'src/widgets/tabs.dart';
export 'src/widgets/toast.dart';
export 'src/widgets/window_controls.dart';
export 'src/widgets/window_frame.dart';
