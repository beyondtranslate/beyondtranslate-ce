import 'package:beyondtranslate_desktop/src/services/system_translation.dart';
import 'package:flutter_test/flutter_test.dart';

/// The runtime hands errors across the FFI as strings, so the one failure
/// the user can fix themselves — the system translator's missing language
/// files — is recognised by the marker the Rust core prints.
void main() {
  test('picks the pair out of the runtime error string', () {
    final missing = SystemLanguageNotInstalled.of(
      'network error: language pair not installed: en -> ja',
    );
    expect(missing, isNotNull);
    expect(missing!.source, 'en');
    expect(missing.target, 'ja');
  });

  test('survives a wrapped message and trailing text', () {
    final missing = SystemLanguageNotInstalled.of(
      StateError(
        'RuntimeException: language pair not installed: zh-Hans -> de. '
        'Install the languages in System Settings.',
      ),
    );
    expect(missing!.source, 'zh-Hans');
    expect(missing.target, 'de');
  });

  test('other errors are not mistaken for it', () {
    expect(SystemLanguageNotInstalled.of('network error: timed out'), isNull);
    expect(
      SystemLanguageNotInstalled.of('unsupported language pair: en -> xx'),
      isNull,
    );
    expect(SystemLanguageNotInstalled.of(null), isNull);
  });
}
