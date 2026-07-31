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
/// Several of the exported names (`Divider`, `ListTile`, `Radio`, `Switch`,
/// `Dialog`, `Badge`, `Checkbox`) collide with Material's. When a file shows
/// one of those and also imports Material, hide Material's — for example
/// `import 'package:flutter/material.dart' hide Divider;`.
///
/// Reaching for `context.colors` / `context.tokens` / `context.typography`
/// means showing the extension that carries them, `DesignThemeContext`; the
/// type recipes (`sansStyle`, `labelStyle`, …) come from
/// `DesignTypographyStyles`.
library;

export 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
