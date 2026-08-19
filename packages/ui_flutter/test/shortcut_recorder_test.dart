import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

String? format(
  PhysicalKeyboardKey key, {
  bool control = false,
  bool alt = false,
  bool shift = false,
  bool meta = false,
}) =>
    formatShortcut(
      physicalKey: key,
      control: control,
      alt: alt,
      shift: shift,
      meta: meta,
    );

void main() {
  test('a key on its own is typing, not a shortcut', () {
    expect(format(PhysicalKeyboardKey.keyT), isNull);
    // ⇧ alone is still typing.
    expect(format(PhysicalKeyboardKey.keyT, shift: true), isNull);
    expect(format(PhysicalKeyboardKey.keyT, alt: true), '⌥T');
  });

  test('a function key is a shortcut by itself', () {
    expect(format(PhysicalKeyboardKey.f5), 'F5');
    // A word key — anything longer than one glyph — keeps its space.
    expect(format(PhysicalKeyboardKey.f13, control: true), '⌃ F13');
  });

  test('modifiers print in the order macOS prints them', () {
    expect(
      format(
        PhysicalKeyboardKey.digit2,
        control: true,
        alt: true,
        shift: true,
        meta: true,
      ),
      '⌃⌥⇧⌘2',
    );
  });

  test('a word key gets a space after the modifiers, a glyph does not', () {
    expect(format(PhysicalKeyboardKey.space, alt: true), '⌥ Space');
    expect(format(PhysicalKeyboardKey.digit2, alt: true, shift: true), '⌥⇧2');
  });

  test('the key is read off its position, not the character it types', () {
    // ⌥T reports `†` as the character on a US layout; the position is what
    // gets recorded.
    expect(format(PhysicalKeyboardKey.keyT, alt: true, shift: true), '⌥⇧T');
    expect(format(PhysicalKeyboardKey.numpad7, meta: true), '⌘7');
  });

  test('keys a shortcut cannot be built on are refused', () {
    expect(format(PhysicalKeyboardKey.capsLock, alt: true), isNull);
    expect(format(PhysicalKeyboardKey.fn, meta: true), isNull);
  });

  test('modifier keys are recognised whichever side they are on', () {
    expect(isShortcutModifier(LogicalKeyboardKey.altRight), isTrue);
    expect(isShortcutModifier(LogicalKeyboardKey.metaLeft), isTrue);
    expect(isShortcutModifier(LogicalKeyboardKey.keyA), isFalse);
  });
}
