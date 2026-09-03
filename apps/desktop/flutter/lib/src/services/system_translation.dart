import 'dart:io' show Platform, Process;

/// The system translator's "language files not installed" failure, picked
/// out of the error string the runtime hands back.
///
/// The Rust core's `TranslationError::LanguageNotInstalled` prints as
/// `language pair not installed: <source> -> <target>`, and that text is the
/// contract: errors cross the FFI as strings, so the marker is what tells
/// this failure apart from a network error — it is the one the user can fix
/// themselves, by downloading the languages in System Settings.
class SystemLanguageNotInstalled {
  const SystemLanguageNotInstalled({
    required this.source,
    required this.target,
  });

  static const String marker = 'language pair not installed:';

  final String source;
  final String target;

  /// The failure behind [error], or null when it is some other error.
  static SystemLanguageNotInstalled? of(Object? error) {
    final message = error?.toString() ?? '';
    final start = message.indexOf(marker);
    if (start < 0) {
      return null;
    }
    final rest = message.substring(start + marker.length).trim();
    final arrow = rest.indexOf('->');
    if (arrow < 0) {
      return const SystemLanguageNotInstalled(source: '', target: '');
    }
    final source = rest.substring(0, arrow).trim();
    final target =
        rest.substring(arrow + 2).trim().split(RegExp(r'[\s,.;)]')).first;
    return SystemLanguageNotInstalled(source: source, target: target);
  }
}

/// Opens 系统设置 › 通用 › 语言与地区, where 翻译语言… downloads the files.
/// The Translation framework offers no way to start that download from an
/// AppKit app — only the SwiftUI `translationTask` sheet does — so pointing
/// at the pane is as far as the app can take the user.
Future<void> openTranslationLanguagesSettings() async {
  if (!Platform.isMacOS) {
    return;
  }
  await Process.start('open', [
    'x-apple.systempreferences:com.apple.Localization-Settings.extension',
  ]);
}
