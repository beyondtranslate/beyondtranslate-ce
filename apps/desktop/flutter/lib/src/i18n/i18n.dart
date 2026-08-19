import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'strings.g.dart';
export 'strings.g.dart';

String formatTranslation(String value, {List<String> args = const []}) {
  var result = value;
  for (final arg in args) {
    result = result.replaceFirst('{}', arg);
  }
  return result;
}

/// Re-runs every `build` below it when the app locale changes.
///
/// The app reads its strings through slang's global [t], which is a plain
/// getter: switching the locale swaps the strings but marks no widget dirty.
/// An ancestor rebuild does not reach the screens either — everything under
/// `MaterialApp.router` sits in `Overlay` entries, and an overlay entry is its
/// own build scope that only rebuilds when something asks it to. Left alone,
/// a language switch reached only the widgets that listen to the settings store
/// themselves, so the sidebar, the pages and the mini translator kept the old
/// language until something else happened to rebuild them.
///
/// Depending on [TranslationProvider] here catches the switch, and walking the
/// subtree marks every element dirty so each `build` re-reads [t]. Marking
/// rather than re-keying is what keeps state: no `State` is unmounted, so
/// scroll offsets, text fields and in-flight translations survive the switch.
/// A locale change is a once-in-a-session event, so the cost of the full
/// rebuild does not matter.
///
/// This is what lets the rest of the app keep using the terse global [t]
/// instead of threading `context.t` through every widget.
class LocaleRebuildScope extends StatefulWidget {
  const LocaleRebuildScope({super.key, required this.child});

  final Widget child;

  @override
  State<LocaleRebuildScope> createState() => _LocaleRebuildScopeState();
}

class _LocaleRebuildScopeState extends State<LocaleRebuildScope> {
  AppLocale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = TranslationProvider.of(context).locale;
    final previous = _locale;
    _locale = locale;
    // On the first pass there is nothing stale to refresh yet.
    if (previous == null || previous == locale) return;
    // Every element below is a descendant of the one being built, so marking
    // them here lands them in this same frame.
    (context as Element).visitChildren(_markSubtreeDirty);
  }

  static void _markSubtreeDirty(Element element) {
    element.markNeedsBuild();
    element.visitChildren(_markSubtreeDirty);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

extension SlangBuildContextExtension on BuildContext {
  Iterable<LocalizationsDelegate<dynamic>> get localizationDelegates {
    return GlobalMaterialLocalizations.delegates;
  }

  List<Locale> get supportedLocales {
    return AppLocaleUtils.supportedLocales;
  }

  Locale get locale {
    return LocaleSettings.currentLocale.flutterLocale;
  }

  Future<void> setLocale(Locale locale) async {
    await LocaleSettings.setLocaleRaw(locale.toLanguageTag());
  }
}
