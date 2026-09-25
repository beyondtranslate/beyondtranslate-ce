// ignore_for_file: invalid_use_of_internal_member, implementation_imports

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    as beyondtranslate_runtime;
import 'package:flutter/src/foundation/_features.dart' show isWindowingEnabled;
import 'package:flutter/widgets.dart';

import 'src/extensions/window_controller.dart';
import 'src/i18n/i18n.dart';
import 'src/routes/app_router.dart';
import 'src/services/glossary_store.dart';
import 'src/services/history_store.dart';
import 'src/services/runtime.dart' show initRuntime;
import 'src/services/settings_store.dart';
import 'src/utils/env.dart';
import 'src/utils/language_util.dart';

Future<void> _ensureInitialized() async {
  // Every window this app shows is made with Flutter's experimental windowing
  // API. The stable channel has no `flutter config --enable-windowing` to turn
  // it on at build time, so the app asks for it itself — before the binding
  // starts, because that is when the windowing owner is chosen. Without this
  // the first `RegularWindowController` throws `UnsupportedError`.
  isWindowingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  _smokeTestBeyondtranslateRuntime();
  await initRuntime();

  initEnv();
  await settingsStore.init();
  await glossaryStore.init();
  await historyStore.init();
}

void _smokeTestBeyondtranslateRuntime() {
  beyondtranslate_runtime.ensureInitialized();
  debugPrint(
    '[beyondtranslate_runtime] Dart version() = '
    '${beyondtranslate_runtime.version()}',
  );
  debugPrint(
    '[beyondtranslate_runtime] Dart add(a: 2, b: 3) = '
    '${beyondtranslate_runtime.add(a: 2, b: 3)}',
  );
  debugPrint(
    '[beyondtranslate_runtime] Dart greet(name: "main.dart") = '
    '${beyondtranslate_runtime.greet(name: 'main.dart')}',
  );
}

void main() async {
  await _ensureInitialized();

  setupGlobalWillShowHook();
  setupGlobalWillHideHook();

  await LocaleSettings.setLocaleRaw(
    languageToLocale(settingsStore.appLanguage).toLanguageTag(),
  );

  runWidget(const RootView());
}
