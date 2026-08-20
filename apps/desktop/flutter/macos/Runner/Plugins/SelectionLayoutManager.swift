import AppKit

/// Draws the selection wash in one colour, whether or not the view has focus.
///
/// `NSTextView` honours `selectedTextAttributes` only while it holds the
/// keyboard in a key window. The moment it does not — which for a Flutter
/// platform view is most of the time — AppKit substitutes the system's
/// unemphasized grey, and the theme's selection washes out to near-white
/// against a light background.
///
/// Neither the emphasized nor the unemphasized system colour belongs to the
/// app's theme, so the fill is taken over here instead. Both text views this
/// serves hold plain strings and set no `.backgroundColor` run of their own,
/// so every fill that arrives is a selection.
final class SelectionLayoutManager: NSLayoutManager {
  /// Left nil, AppKit's own choice stands.
  var selectionColor: NSColor?

  override func fillBackgroundRectArray(
    _ rectArray: UnsafePointer<NSRect>,
    count rectCount: Int,
    forCharacterRange charRange: NSRange,
    color: NSColor
  ) {
    super.fillBackgroundRectArray(
      rectArray,
      count: rectCount,
      forCharacterRange: charRange,
      color: selectionColor ?? color
    )
  }
}
