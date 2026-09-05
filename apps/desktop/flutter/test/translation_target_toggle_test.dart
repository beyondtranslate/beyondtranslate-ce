import 'package:beyondtranslate_desktop/src/routes/settings/service_prefs.dart';
import 'package:beyondtranslate_desktop/src/utils/language_util.dart'
    show kAutoSource;
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter_test/flutter_test.dart';

/// 翻译目标 can be switched off one at a time — the rule stays on the list,
/// it just stops applying. The one thing the switch must not allow is turning
/// the last one off: with no target in force 自动匹配 has nowhere to route,
/// and a query would come back with nothing at all.
void main() {
  TranslationTarget target({
    String source = kAutoSource,
    required String to,
    bool enabled = true,
  }) {
    return TranslationTarget(source: source, target: to, enabled: enabled);
  }

  test('a target among several can be switched off', () {
    final targets = [
      target(to: 'zh-Hans'),
      target(to: 'en'),
    ];
    expect(canToggleTranslationTarget(targets, 0), isTrue);
    expect(canToggleTranslationTarget(targets, 1), isTrue);
  });

  test('the last one in force cannot be switched off', () {
    final targets = [
      target(to: 'zh-Hans'),
      target(to: 'en', enabled: false),
    ];
    expect(canToggleTranslationTarget(targets, 0), isFalse);
  });

  test('a target already off can always be switched back on', () {
    final targets = [
      target(to: 'zh-Hans'),
      target(to: 'en', enabled: false),
      target(to: 'ja', enabled: false),
    ];
    expect(canToggleTranslationTarget(targets, 1), isTrue);
    expect(canToggleTranslationTarget(targets, 2), isTrue);
  });

  test('every target off — each can be switched back on, none is locked', () {
    final targets = [
      target(to: 'zh-Hans', enabled: false),
      target(to: 'en', enabled: false),
    ];
    expect(canToggleTranslationTarget(targets, 0), isTrue);
    expect(canToggleTranslationTarget(targets, 1), isTrue);
  });

  test('a lone target is locked on', () {
    expect(canToggleTranslationTarget([target(to: 'zh-Hans')], 0), isFalse);
  });

  test('an index off the end is not a switch', () {
    final targets = [target(to: 'zh-Hans')];
    expect(canToggleTranslationTarget(targets, 1), isFalse);
    expect(canToggleTranslationTarget(targets, -1), isFalse);
    expect(canToggleTranslationTarget(const [], 0), isFalse);
  });
}
