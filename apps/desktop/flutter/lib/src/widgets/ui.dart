/// The app's single door to the design system.
///
/// Pages and widgets import this file, never `package:beyondtranslate_ui/…`
/// directly, so the package stays swappable from one place. Import only the
/// names a file actually uses:
///
/// ```dart
/// import '../../widgets/ui.dart' show Button, ButtonVariant;
/// ```
///
/// The package is vendored from <https://github.com/fastforgedev/ui> by
/// `scripts/sync_ui.py` and is not edited here. It holds primitives only: no
/// translation, provider, glossary or language-pair concept reaches it, and it
/// draws no window. The product's own widgets sit beside this file — the
/// window chrome (`window_chrome.dart`), the resizable navigation columns
/// (`nav_columns.dart`), the shortcut recorder, the toast viewport — and are
/// imported directly, not through here.
///
/// Several exported names (`Card`, `Checkbox`, `Dialog`, `Divider`, `Radio`,
/// `Switch`, `Table`, `TextField`, `Theme`) collide with Flutter's own. A file
/// that shows one of those and also imports Material or Widgets must hide
/// Flutter's — for example
/// `import 'package:flutter/material.dart' hide Divider;`.
///
/// Reaching for `context.vars` means showing the extension that carries it,
/// `ThemeDataBuildContextProps`. The product's own colours and type recipes
/// layer on top of `ThemeVariables` and come from `../theme/product_tokens.dart`
/// (`ProductPalette`, `ProductTypography`).
library;

export 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
