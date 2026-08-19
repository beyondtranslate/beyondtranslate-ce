import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show InputSubmitMode;

import 'platform_util.dart';

/// A thin space, between a modifier and the key it modifies. Set solid, `⌘⏎`
/// reads as one dense mark and outweighs the label it sits beside; a hair of
/// air makes it two keys again, at the weight a `⏎` alone carries.
const _kThin = '\u2009';

/// The key that sends an input box, spelled the way the button chips and the
/// hints beside them print it. 提交方式 in settings picks which one it is, and
/// every surface that shows a key has to show the same one — so the mapping
/// lives here rather than once per surface.
///
/// ⌘ is a Mac keyboard's; elsewhere the key in that position is Ctrl, and
/// `TextField` accepts it there for the same mode.
String inputSubmitShortcutGlyphs(InputSubmitMode mode) => switch (mode) {
      InputSubmitMode.enter => '⏎',
      InputSubmitMode.commandEnter => kIsMacOS ? '⌘$_kThin⏎' : '⌃$_kThin⏎',
    };

/// The key that writes a newline instead — the other half of 提交方式, and the
/// one the hint under the box names. Whichever key does not submit does this.
String inputNewlineShortcutGlyphs(InputSubmitMode mode) => switch (mode) {
      InputSubmitMode.enter => '⇧$_kThin⏎',
      InputSubmitMode.commandEnter => '⏎',
    };
