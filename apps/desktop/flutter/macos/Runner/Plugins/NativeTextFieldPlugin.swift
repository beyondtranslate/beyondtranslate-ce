import AppKit
import FlutterMacOS

final class NativeTextFieldPlugin: NSObject {
  static let viewType = "beyondtranslate/native_text_field"

  static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(
      NativeTextFieldFactory(messenger: registrar.messenger),
      withId: viewType
    )
  }
}

private final class NativeTextFieldFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    NativeTextFieldView(
      viewId: viewId,
      messenger: messenger,
      arguments: args as? [String: Any]
    )
  }

  func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

/// An editable field drawn by AppKit, single-line or multiline.
///
/// Both shapes are the same `NSTextView`, laid out on the same TextKit stack,
/// and the placeholder is drawn by that view on the very layout the text will
/// take — so the two share a left edge, a baseline and a line box without any
/// inset arithmetic between them. `NSTextField` is kept only for 密码: AppKit's
/// bullets live in `NSSecureTextField` and nowhere else.
private final class NativeTextFieldView: NSView, NSTextFieldDelegate, NSTextViewDelegate {
  private let channel: FlutterMethodChannel
  private let padding: NSEdgeInsets
  private let isMultiline: Bool
  private let obscureText: Bool
  private var submitOnEnter: Bool
  private var submitOnMetaEnter: Bool
  private var placeholder: String
  private var textStyle: NativeTextStyle
  private var placeholderStyle: NativeTextStyle
  /// The editor's TextKit 1 stack, held here because a text view only keeps
  /// its container — and because the layout manager is what draws the
  /// selection. See [SelectionLayoutManager].
  private var textStorage: NSTextStorage?
  private var selectionLayoutManager: SelectionLayoutManager?
  private var cursorColor: NSColor?
  private var selectionColor: NSColor?

  /// The obscured field; nil for every other input.
  private var textField: NSTextField?
  /// The editor; nil when the input is obscured.
  private var textView: FieldTextView?
  private var scrollView: NSScrollView?
  private var isUpdatingFromFlutter = false
  private var lastReportedContentHeight: CGFloat = 0
  private var trackingArea: NSTrackingArea?

  init(
    viewId: Int64,
    messenger: FlutterBinaryMessenger,
    arguments: [String: Any]?
  ) {
    let args = arguments ?? [:]
    channel = FlutterMethodChannel(
      name: "beyondtranslate/native_text_field/\(viewId)",
      binaryMessenger: messenger
    )
    padding = NativeTextFieldView.decodePadding(args["padding"])
    obscureText = args["obscureText"] as? Bool ?? false
    submitOnEnter = args["submitOnEnter"] as? Bool ?? false
    submitOnMetaEnter = args["submitOnMetaEnter"] as? Bool ?? false
    let maxLines = NativeTextFieldView.decodeInt(args["maxLines"]) ?? 1
    isMultiline = !obscureText && maxLines != 1
    placeholder = args["placeholder"] as? String ?? ""
    textStyle = NativeTextStyle(arguments: args["style"] as? [String: Any])
    placeholderStyle = NativeTextStyle(
      arguments: args["placeholderStyle"] as? [String: Any]
    )
    cursorColor = NativeTextStyle.decodeColor(args["cursorColor"])
    selectionColor = NativeTextStyle.decodeColor(args["selectionColor"])

    super.init(frame: .zero)

    appearance = NativeTextFieldView.decodeAppearance(args["appearance"])
    wantsLayer = true
    layer?.backgroundColor = NSColor.clear.cgColor
    setupInput(initialText: args["text"] as? String ?? "")
    applyEditableState(
      enabled: args["enabled"] as? Bool ?? true,
      readOnly: args["readOnly"] as? Bool ?? false
    )
    setupChannel()

    if args["autofocus"] as? Bool == true {
      DispatchQueue.main.async { [weak self] in
        self?.focus()
      }
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layout() {
    super.layout()
    let inputFrame = NSRect(
      x: bounds.minX + padding.left,
      y: bounds.minY + padding.bottom,
      width: max(0, bounds.width - padding.left - padding.right),
      height: max(0, bounds.height - padding.top - padding.bottom)
    )
    if let textField {
      // The cell centres its one line in whatever frame it gets, so hand it
      // exactly one line and centre that.
      let lineHeight = ceil(textStyle.font.ascender - textStyle.font.descender)
      textField.frame = Self.centeredLine(height: lineHeight, in: inputFrame)
    }
    if let scrollView {
      // Flutter reserves `fontSize × height` per line. Multiline fills the box
      // line by line from the top; single-line is one such line box, centred.
      scrollView.frame =
        isMultiline
        ? inputFrame
        : Self.centeredLine(height: textStyle.lineHeight, in: inputFrame)
      updateTextContainerSize(scrollView.frame.size)
    }
    reportContentHeightIfNeeded()
  }

  private static func centeredLine(height: CGFloat, in frame: NSRect) -> NSRect {
    let lineHeight = min(frame.height, height)
    return NSRect(
      x: frame.minX,
      y: frame.midY - lineHeight / 2,
      width: frame.width,
      height: lineHeight
    )
  }

  override func updateTrackingAreas() {
    if let trackingArea {
      removeTrackingArea(trackingArea)
    }
    let newArea = NSTrackingArea(
      rect: bounds,
      options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect],
      owner: self,
      userInfo: nil
    )
    addTrackingArea(newArea)
    trackingArea = newArea
    super.updateTrackingAreas()
  }

  override func mouseEntered(with event: NSEvent) {
    super.mouseEntered(with: event)
    NSCursor.iBeam.set()
  }

  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
    NSCursor.arrow.set()
  }

  override func mouseDown(with event: NSEvent) {
    channel.invokeMethod("tapped", arguments: nil)
    focus()
    super.mouseDown(with: event)
  }

  /// AppKit normally routes ⌘C/⌘V/… through the Edit menu's key equivalents,
  /// which do not exist while the app runs as `.accessory` — the mini
  /// translator has no menu bar. Dispatch the standard editing commands down
  /// the responder chain ourselves so the field behaves the same either way.
  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

    // 提交方式 = ⌘+Enter lives or dies here: AppKit settles a Return that
    // carries a modifier as a key equivalent and never offers it to the
    // editor's own key bindings, so `doCommandBy` below would never see it.
    if submitOnMetaEnter, modifiers == .command, Self.isReturn(event), isEditing {
      submit()
      return true
    }

    // The editor trims paste in its own subclass, so every route into it — the
    // Edit menu, the context menu, ⌘V — comes out trimmed. The obscured field
    // borrows the window's shared field editor, a stock NSTextView there is no
    // subclass to reach; ⌘V is the route that matters, and it is this one.
    if modifiers.subtracting(.shift) == .command,
      event.charactersIgnoringModifiers?.lowercased() == "v",
      isEditing,
      let editor = textField?.currentEditor() as? NSTextView,
      editor.insertTrimmedPasteboardString()
    {
      return true
    }

    guard modifiers.subtracting(.shift) == .command,
      let action = Self.editingAction(
        for: event.charactersIgnoringModifiers?.lowercased(),
        shift: modifiers.contains(.shift)
      ),
      isEditing
    else {
      return super.performKeyEquivalent(with: event)
    }

    // `to: nil` makes AppKit walk the responder chain exactly the way the Edit
    // menu would. Sending straight to the editor would break undo/redo, which
    // are served by a supplemental target rather than the editor itself.
    return NSApp.sendAction(action, to: nil, from: self)
  }

  /// Whether this field's own editor holds the keyboard. The key equivalents
  /// above belong to it, not to whatever else the window happens to be showing.
  private var isEditing: Bool {
    guard let responder = window?.firstResponder else { return false }
    return responder === textField?.currentEditor() || responder === textView
  }

  /// Return, or the keypad's Enter — by position, because
  /// `charactersIgnoringModifiers` spells the keypad key as an unprintable.
  private static func isReturn(_ event: NSEvent) -> Bool {
    event.keyCode == 36 || event.keyCode == 76
  }

  /// The same actions the Edit menu would send. `undo:` / `redo:` are spelled
  /// out because they are only declared on `NSResponder` as informal
  /// first-responder actions, with nothing for `#selector` to point at.
  private static func editingAction(for key: String?, shift: Bool) -> Selector? {
    switch key {
    case "x": return #selector(NSText.cut(_:))
    case "c": return #selector(NSText.copy(_:))
    case "v":
      return shift
        ? #selector(NSTextView.pasteAsPlainText(_:))
        : #selector(NSText.paste(_:))
    case "a": return #selector(NSStandardKeyBindingResponding.selectAll(_:))
    case "z": return shift ? Selector(("redo:")) : Selector(("undo:"))
    default: return nil
    }
  }

  // MARK: - NSTextFieldDelegate (the obscured field)

  func controlTextDidBeginEditing(_ obj: Notification) {
    applySelectionColors()
    channel.invokeMethod("focused", arguments: nil)
  }

  func controlTextDidEndEditing(_ obj: Notification) {
    channel.invokeMethod("blurred", arguments: nil)
  }

  func controlTextDidChange(_ obj: Notification) {
    guard !isUpdatingFromFlutter else { return }
    channel.invokeMethod("changed", arguments: currentText())
  }

  // MARK: - NSTextViewDelegate (the editor)

  func textDidBeginEditing(_ notification: Notification) {
    channel.invokeMethod("focused", arguments: nil)
  }

  func textDidEndEditing(_ notification: Notification) {
    channel.invokeMethod("blurred", arguments: nil)
  }

  func textDidChange(_ notification: Notification) {
    // Plain-text mode carries the typing attributes along from the text
    // around the caret; once there is none, make sure they are still ours.
    if let textView, textView.string.isEmpty {
      textView.typingAttributes = textStyle.attributes()
    }
    reportContentHeightIfNeeded()
    guard !isUpdatingFromFlutter else { return }
    channel.invokeMethod("changed", arguments: currentText())
  }

  /// A single-line field has no second line to put a newline on. Pasted line
  /// breaks — a PDF's hard wraps, most often — become spaces rather than
  /// vanishing, so the words on either side stay apart.
  func textView(
    _ textView: NSTextView,
    shouldChangeTextIn affectedCharRange: NSRange,
    replacementString: String?
  ) -> Bool {
    guard !isMultiline,
      let replacementString,
      replacementString.rangeOfCharacter(from: .newlines) != nil
    else {
      return true
    }
    let flattened =
      replacementString
      .components(separatedBy: .newlines)
      .joined(separator: " ")
    textView.insertText(flattened, replacementRange: affectedCharRange)
    return false
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.insertNewline(_:)):
      return handleNewline()
    case #selector(NSResponder.insertTab(_:)) where !isMultiline:
      // Tab leaves a one-line field, the way it leaves an `NSTextField`.
      window?.selectKeyView(following: textView)
      return true
    case #selector(NSResponder.insertBacktab(_:)) where !isMultiline:
      window?.selectKeyView(preceding: textView)
      return true
    default:
      return false
    }
  }

  private func handleNewline() -> Bool {
    // Single-line: Return submits, the way an `NSTextField`'s action fires.
    guard isMultiline else {
      submit()
      return true
    }
    let modifiers =
      NSApp.currentEvent?.modifierFlags.intersection(.deviceIndependentFlagsMask) ?? []
    // ⇧⏎ is the way out of whichever key submits — it always writes a newline,
    // which is what the field's own hint promises.
    guard !modifiers.contains(.shift) else { return false }
    let shouldSubmit =
      submitOnEnter || (submitOnMetaEnter && modifiers.contains(.command))
    guard shouldSubmit else { return false }
    submit()
    return true
  }

  private func submit() {
    channel.invokeMethod("submitted", arguments: currentText())
  }

  private func setupInput(initialText: String) {
    if obscureText {
      setupSecureField(initialText: initialText)
    } else {
      setupTextView(initialText: initialText)
    }
  }

  private func setupSecureField(initialText: String) {
    let field = NSSecureTextField()
    field.stringValue = initialText
    field.placeholderString = placeholder
    field.isBordered = false
    field.isBezeled = false
    field.drawsBackground = false
    field.focusRingType = .none
    field.delegate = self
    field.target = self
    field.action = #selector(submitTextField)
    field.font = textStyle.font
    field.textColor = textStyle.color
    field.placeholderAttributedString = NSAttributedString(
      string: placeholder,
      attributes: [
        .font: placeholderStyle.font,
        .foregroundColor: placeholderStyle.color,
      ]
    )
    addSubview(field)
    textField = field
  }

  private func setupTextView(initialText: String) {
    let scroll = NSScrollView()
    scroll.drawsBackground = false
    scroll.borderType = .noBorder
    scroll.hasVerticalScroller = false
    scroll.hasHorizontalScroller = false
    scroll.autohidesScrollers = true

    let storage = NSTextStorage()
    let layout = SelectionLayoutManager()
    let container = NSTextContainer(size: .zero)
    storage.addLayoutManager(layout)
    layout.addTextContainer(container)
    container.lineFragmentPadding = 0
    container.widthTracksTextView = false
    let view = FieldTextView(frame: .zero, textContainer: container)
    textStorage = storage
    selectionLayoutManager = layout
    view.delegate = self
    view.drawsBackground = false
    view.isRichText = false
    view.importsGraphics = false
    view.usesFontPanel = false
    view.allowsUndo = true
    view.textContainerInset = .zero
    // Multiline grows downward at a fixed width; single-line grows sideways
    // at a fixed height and scrolls the caret into view, the way a field does.
    view.isVerticallyResizable = isMultiline
    view.isHorizontallyResizable = !isMultiline
    view.minSize = .zero
    view.maxSize = NSSize(
      width: CGFloat.greatestFiniteMagnitude,
      height: CGFloat.greatestFiniteMagnitude
    )
    view.insertionPointColor = cursorColor ?? NSColor.controlAccentColor
    scroll.documentView = view

    addSubview(scroll)
    scrollView = scroll
    textView = view
    view.string = initialText
    applyTextStyle()
    applyPlaceholder()
    applySelectionColors()
    reportContentHeightIfNeeded()
  }

  /// The caret and the wash behind selected glyphs, in the app's accent rather
  /// than the system one from System Settings.
  ///
  /// The editor is ours and keeps these for its lifetime. The obscured field
  /// borrows the window's shared field editor, which is handed around between
  /// every field in the window — so it has to be dressed again each time
  /// editing begins here.
  private func applySelectionColors() {
    let editors = [textView, textField?.currentEditor() as? NSTextView]
    for editor in editors.compactMap({ $0 }) {
      if let cursorColor {
        editor.insertionPointColor = cursorColor
      }
      if let selectionColor {
        editor.selectedTextAttributes = [.backgroundColor: selectionColor]
      }
    }
    selectionLayoutManager?.selectionColor = selectionColor
  }

  private func setupChannel() {
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(nil)
        return
      }

      switch call.method {
      case "setText":
        self.setText(call.arguments as? String ?? "")
        result(nil)
      case "focus":
        self.focus()
        result(nil)
      case "blur":
        self.window?.makeFirstResponder(nil)
        result(nil)
      case "setAppearance":
        self.appearance = NativeTextFieldView.decodeAppearance(call.arguments)
        result(nil)
      case "setSelectionColors":
        let args = call.arguments as? [String: Any] ?? [:]
        self.cursorColor = NativeTextStyle.decodeColor(args["cursorColor"])
        self.selectionColor = NativeTextStyle.decodeColor(args["selectionColor"])
        self.applySelectionColors()
        result(nil)
      case "setPlaceholder":
        self.setPlaceholder(call.arguments as? [String: Any] ?? [:])
        result(nil)
      case "setStyle":
        self.setStyle(call.arguments as? [String: Any] ?? [:])
        result(nil)
      case "setEditableState":
        let args = call.arguments as? [String: Any] ?? [:]
        self.applyEditableState(
          enabled: args["enabled"] as? Bool ?? true,
          readOnly: args["readOnly"] as? Bool ?? false
        )
        result(nil)
      case "setSubmitMode":
        let args = call.arguments as? [String: Any] ?? [:]
        self.submitOnEnter = args["submitOnEnter"] as? Bool ?? false
        self.submitOnMetaEnter = args["submitOnMetaEnter"] as? Bool ?? false
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func applyEditableState(enabled: Bool, readOnly: Bool) {
    let editable = enabled && !readOnly
    textField?.isEnabled = enabled
    textField?.isEditable = editable
    textView?.isEditable = editable
    textView?.isSelectable = enabled
  }

  private func setText(_ text: String) {
    guard currentText() != text else {
      reportContentHeightIfNeeded()
      return
    }
    isUpdatingFromFlutter = true
    textField?.stringValue = text
    if let textView {
      textView.string = text
      applyTextStyle()
    }
    reportContentHeightIfNeeded()
    isUpdatingFromFlutter = false
  }

  private func setPlaceholder(_ args: [String: Any]) {
    placeholder = args["placeholder"] as? String ?? ""
    if let argsStyle = args["style"] as? [String: Any] {
      placeholderStyle = NativeTextStyle(arguments: argsStyle)
    }

    if let field = textField {
      field.placeholderString = placeholder
      field.placeholderAttributedString = NSAttributedString(
        string: placeholder,
        attributes: [
          .font: placeholderStyle.font,
          .foregroundColor: placeholderStyle.color,
        ]
      )
    }
    applyPlaceholder()
  }

  private func setStyle(_ args: [String: Any]) {
    textStyle = NativeTextStyle(arguments: args)
    textField?.font = textStyle.font
    textField?.textColor = textStyle.color
    applyTextStyle()
    // The placeholder sits in the text's line box, so it moves with the text.
    applyPlaceholder()
    needsLayout = true
    reportContentHeightIfNeeded()
  }

  /// Dresses whatever the editor holds, and whatever gets typed next, in the
  /// text style — font, colour, and the line box Flutter sized the field for.
  private func applyTextStyle() {
    guard let textView, let textStorage else { return }
    let attributes = textStyle.attributes()
    textStorage.setAttributes(
      attributes,
      range: NSRange(location: 0, length: textStorage.length)
    )
    textView.typingAttributes = attributes
    textView.needsDisplay = true
  }

  /// The placeholder in its own face, laid out in the *text's* line box so it
  /// takes the baseline the first line of text will.
  private func applyPlaceholder() {
    textView?.setPlaceholder(
      placeholderStyle.attributedString(
        placeholder,
        lineHeight: textStyle.lineHeight
      )
    )
  }

  private func focus() {
    if let textField {
      window?.makeFirstResponder(textField)
    } else if let textView {
      window?.makeFirstResponder(textView)
    }
  }

  private func currentText() -> String {
    if let textField {
      return textField.stringValue
    }
    return textView?.string ?? ""
  }

  private func updateTextContainerSize(_ size: NSSize) {
    guard let textView, let container = textView.textContainer else { return }
    if isMultiline {
      container.containerSize = NSSize(
        width: max(0, size.width),
        height: CGFloat.greatestFiniteMagnitude
      )
    } else {
      // Never narrower than the field, so a click past the end of a short
      // string still lands on the editor; never taller than its one line.
      container.containerSize = NSSize(
        width: CGFloat.greatestFiniteMagnitude,
        height: size.height
      )
      textView.minSize = size
      textView.maxSize = NSSize(
        width: CGFloat.greatestFiniteMagnitude,
        height: size.height
      )
    }
    textView.syncPlaceholderContainer()
  }

  private func reportContentHeightIfNeeded() {
    guard isMultiline, let textView, let layoutManager = textView.layoutManager else {
      return
    }
    guard let textContainer = textView.textContainer else { return }

    layoutManager.ensureLayout(for: textContainer)
    let usedRect = layoutManager.usedRect(for: textContainer)
    // An empty field still occupies its line, the way Flutter's would.
    let contentHeight = ceil(max(textStyle.lineHeight, usedRect.height))
    guard abs(contentHeight - lastReportedContentHeight) >= 0.5 else { return }

    lastReportedContentHeight = contentHeight
    channel.invokeMethod("contentHeightChanged", arguments: Double(contentHeight))
  }

  @objc private func submitTextField() {
    submit()
  }

  /// The app's theme decides the appearance, not the system.
  ///
  /// AppKit still resolves a handful of colours for itself here — the
  /// unemphasized selection behind a blurred field above all, which is an
  /// opaque near-white in the light appearance. Inheriting the system's choice
  /// paints that over a dark theme; naming the theme's own brightness is what
  /// keeps it in step.
  private static func decodeAppearance(_ value: Any?) -> NSAppearance? {
    switch value as? String {
    case "dark": return NSAppearance(named: .darkAqua)
    case "light": return NSAppearance(named: .aqua)
    default: return nil
    }
  }

  private static func decodePadding(_ value: Any?) -> NSEdgeInsets {
    guard let args = value as? [String: Any] else {
      return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    return NSEdgeInsets(
      top: CGFloat(decodeDouble(args["top"]) ?? 0),
      left: CGFloat(decodeDouble(args["left"]) ?? 0),
      bottom: CGFloat(decodeDouble(args["bottom"]) ?? 0),
      right: CGFloat(decodeDouble(args["right"]) ?? 0)
    )
  }

  private static func decodeInt(_ value: Any?) -> Int? {
    if let int = value as? Int { return int }
    return (value as? NSNumber)?.intValue
  }

  private static func decodeDouble(_ value: Any?) -> Double? {
    if let double = value as? Double { return double }
    return (value as? NSNumber)?.doubleValue
  }
}

/// The editor behind every field: paste trimmed, placeholder drawn in place.
///
/// The placeholder has a TextKit stack of its own, configured exactly like the
/// editor's — same container width, no fragment padding, and attributes that
/// name the same line box — so the first line it lays out *is* the line the
/// text will take. Drawing it from `draw(_:)` at the editor's own container
/// origin is what makes the two coincide; there is no second view to keep in
/// step and no cell inset to guess at.
private final class FieldTextView: NSTextView {
  private let placeholderStorage = NSTextStorage()
  private let placeholderLayoutManager = NSLayoutManager()
  private let placeholderContainer = NSTextContainer(size: .zero)

  override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
    super.init(frame: frameRect, textContainer: container)
    placeholderStorage.addLayoutManager(placeholderLayoutManager)
    placeholderLayoutManager.addTextContainer(placeholderContainer)
    placeholderContainer.lineFragmentPadding = 0
    placeholderContainer.widthTracksTextView = false
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setPlaceholder(_ placeholder: NSAttributedString) {
    placeholderStorage.setAttributedString(placeholder)
    needsDisplay = true
  }

  /// The placeholder wraps where the text would: call whenever the editor's
  /// container is resized.
  func syncPlaceholderContainer() {
    guard let textContainer else { return }
    placeholderContainer.containerSize = textContainer.containerSize
    needsDisplay = true
  }

  /// Shown on an empty field — and not while an input method is composing,
  /// when the marked text is standing where the placeholder would.
  private var showsPlaceholder: Bool {
    string.isEmpty && !hasMarkedText() && placeholderStorage.length > 0
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    guard showsPlaceholder else { return }
    placeholderLayoutManager.ensureLayout(for: placeholderContainer)
    let glyphs = placeholderLayoutManager.glyphRange(for: placeholderContainer)
    placeholderLayoutManager.drawGlyphs(forGlyphRange: glyphs, at: textContainerOrigin)
  }

  /// An edit invalidates only the glyphs it touched; the placeholder comes and
  /// goes with the whole first line, so redraw all of it.
  override func didChangeText() {
    super.didChangeText()
    needsDisplay = true
  }

  override func setMarkedText(
    _ string: Any,
    selectedRange: NSRange,
    replacementRange: NSRange
  ) {
    super.setMarkedText(
      string,
      selectedRange: selectedRange,
      replacementRange: replacementRange
    )
    needsDisplay = true
  }

  override func unmarkText() {
    super.unmarkText()
    needsDisplay = true
  }

  /// Text copied out of a web page or a PDF arrives with the edges of the
  /// selection attached — a trailing newline, an indent off the left margin —
  /// and in a translation input those edges are never wanted.
  override func paste(_ sender: Any?) {
    if !insertTrimmedPasteboardString() {
      super.paste(sender)
    }
  }

  override func pasteAsPlainText(_ sender: Any?) {
    if !insertTrimmedPasteboardString() {
      super.pasteAsPlainText(sender)
    }
  }
}

extension NSTextView {
  /// Replaces the selection with the pasteboard's text, edges trimmed.
  ///
  /// Returns `false` when the pasteboard holds nothing that reads as a string,
  /// leaving the caller to fall back to AppKit's own paste.
  fileprivate func insertTrimmedPasteboardString() -> Bool {
    guard let raw = NSPasteboard.general.string(forType: .string) else {
      return false
    }
    // `insertText` is the same door typing comes through, so undo, the change
    // notifications Flutter listens on, and the typing attributes all keep
    // working — none of which a direct `textStorage` edit would.
    insertText(
      raw.trimmingCharacters(in: .whitespacesAndNewlines),
      replacementRange: selectedRange()
    )
    return true
  }
}
