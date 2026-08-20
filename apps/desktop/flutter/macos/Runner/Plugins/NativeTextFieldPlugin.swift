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

private final class NativeTextFieldView: NSView, NSTextFieldDelegate, NSTextViewDelegate {
  private let channel: FlutterMethodChannel
  private let padding: NSEdgeInsets
  private let isMultiline: Bool
  private let obscureText: Bool
  private var submitOnEnter: Bool
  private var submitOnMetaEnter: Bool
  private var placeholder: String
  private let textStyle: NativeTextStyle
  private var placeholderStyle: NativeTextStyle
  /// The multiline editor's TextKit 1 stack, held here because a text view
  /// only keeps its container — and because the layout manager is what draws
  /// the selection. See [SelectionLayoutManager].
  private var textStorage: NSTextStorage?
  private var selectionLayoutManager: SelectionLayoutManager?
  private var cursorColor: NSColor?
  private var selectionColor: NSColor?

  private var textField: NSTextField?
  private var textView: NSTextView?
  private var scrollView: NSScrollView?
  private var placeholderLabel: NSTextField?
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
    textField?.frame = inputFrame
    scrollView?.frame = inputFrame
    placeholderLabel?.frame = inputFrame
    updateTextContainerSize(width: inputFrame.width)
    reportContentHeightIfNeeded()
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
    if textField != nil || textView != nil {
      NSCursor.iBeam.set()
    }
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

    // The multiline editor trims paste in its own subclass, so every route
    // into it — the Edit menu, the context menu, ⌘V — comes out trimmed. The
    // single-line field borrows the window's shared field editor, a stock
    // NSTextView there is no subclass to reach; ⌘V is the route that matters,
    // and it is this one.
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

  func textDidBeginEditing(_ notification: Notification) {
    updatePlaceholderVisibility()
    channel.invokeMethod("focused", arguments: nil)
  }

  func textDidEndEditing(_ notification: Notification) {
    updatePlaceholderVisibility()
    channel.invokeMethod("blurred", arguments: nil)
  }

  func textDidChange(_ notification: Notification) {
    updatePlaceholderVisibility()
    reportContentHeightIfNeeded()
    guard !isUpdatingFromFlutter else { return }
    channel.invokeMethod("changed", arguments: currentText())
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    guard commandSelector == #selector(NSResponder.insertNewline(_:)) else {
      return false
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
    if isMultiline {
      setupTextView(initialText: initialText)
    } else {
      setupTextField(initialText: initialText)
    }
  }

  private func setupTextField(initialText: String) {
    let field: NSTextField = obscureText ? NSSecureTextField() : NSTextField()
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
    let view = TrimmingTextView(frame: .zero, textContainer: container)
    textStorage = storage
    selectionLayoutManager = layout
    view.string = initialText
    view.delegate = self
    view.drawsBackground = false
    view.isRichText = false
    view.importsGraphics = false
    view.allowsUndo = true
    view.isVerticallyResizable = true
    view.isHorizontallyResizable = false
    view.minSize = .zero
    view.maxSize = NSSize(
      width: CGFloat.greatestFiniteMagnitude,
      height: CGFloat.greatestFiniteMagnitude
    )
    view.textContainerInset = .zero
    view.textContainer?.lineFragmentPadding = 0
    view.font = textStyle.font
    view.textColor = textStyle.color
    view.insertionPointColor = cursorColor ?? NSColor.controlAccentColor
    scroll.documentView = view

    let label = PassthroughTextField(labelWithString: placeholder)
    label.font = placeholderStyle.font
    label.textColor = placeholderStyle.color
    label.backgroundColor = .clear
    label.isBordered = false
    label.isEditable = false
    label.isSelectable = false

    addSubview(scroll)
    addSubview(label)
    scrollView = scroll
    textView = view
    placeholderLabel = label
    updatePlaceholderVisibility()
    applySelectionColors()
    reportContentHeightIfNeeded()
  }

  /// The caret and the wash behind selected glyphs, in the app's accent rather
  /// than the system one from System Settings.
  ///
  /// The multiline editor is ours and keeps these for its lifetime. The
  /// single-line field borrows the window's shared field editor, which is
  /// handed around between every field in the window — so it has to be dressed
  /// again each time editing begins here.
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
    textView?.string = text
    updatePlaceholderVisibility()
    reportContentHeightIfNeeded()
    isUpdatingFromFlutter = false
  }

  private func setPlaceholder(_ args: [String: Any]) {
    let newPlaceholder = args["placeholder"] as? String ?? ""
    placeholder = newPlaceholder
    if let argsStyle = args["style"] as? [String: Any] {
      placeholderStyle = NativeTextStyle(arguments: argsStyle)
    }

    if let field = textField {
      field.placeholderString = newPlaceholder
      field.placeholderAttributedString = NSAttributedString(
        string: newPlaceholder,
        attributes: [
          .font: placeholderStyle.font,
          .foregroundColor: placeholderStyle.color,
        ]
      )
    } else if let label = placeholderLabel {
      label.stringValue = newPlaceholder
      label.font = placeholderStyle.font
      label.textColor = placeholderStyle.color
    }
    updatePlaceholderVisibility()
  }

  private func focus() {
    if let textField {
      window?.makeFirstResponder(textField)
    } else if let textView {
      window?.makeFirstResponder(textView)
      updatePlaceholderVisibility()
    }
  }

  private func currentText() -> String {
    if let textField {
      return textField.stringValue
    }
    return textView?.string ?? ""
  }

  private func updatePlaceholderVisibility() {
    let hasMarkedText = textView?.hasMarkedText() ?? false
    placeholderLabel?.isHidden = !currentText().isEmpty || hasMarkedText
  }

  private func updateTextContainerSize(width: CGFloat) {
    guard let textView else { return }
    textView.textContainer?.containerSize = NSSize(
      width: max(0, width),
      height: CGFloat.greatestFiniteMagnitude
    )
    textView.textContainer?.widthTracksTextView = false
  }

  private func reportContentHeightIfNeeded() {
    guard isMultiline, let textView, let layoutManager = textView.layoutManager else {
      return
    }
    guard let textContainer = textView.textContainer else { return }

    layoutManager.ensureLayout(for: textContainer)
    let usedRect = layoutManager.usedRect(for: textContainer)
    let contentHeight = ceil(
      max(textStyle.font.ascender - textStyle.font.descender, usedRect.height))
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

private final class PassthroughTextField: NSTextField {
  override func hitTest(_ point: NSPoint) -> NSView? {
    nil
  }
}

private struct NativeTextStyle {
  let font: NSFont
  let color: NSColor

  init(arguments: [String: Any]?) {
    let args = arguments ?? [:]
    let fontSize = CGFloat(NativeTextStyle.decodeDouble(args["fontSize"]) ?? 14)
    if let family = args["fontFamily"] as? String,
      let customFont = NSFont(name: family, size: fontSize)
    {
      font = customFont
    } else {
      font = NSFont.systemFont(ofSize: fontSize)
    }
    color = NativeTextStyle.decodeColor(args["color"]) ?? NSColor.labelColor
  }

  fileprivate static func decodeColor(_ value: Any?) -> NSColor? {
    guard let number = value as? NSNumber else { return nil }
    let argb = number.uint32Value
    let alpha = CGFloat((argb >> 24) & 0xff) / 255
    let red = CGFloat((argb >> 16) & 0xff) / 255
    let green = CGFloat((argb >> 8) & 0xff) / 255
    let blue = CGFloat(argb & 0xff) / 255
    return NSColor(
      calibratedRed: red,
      green: green,
      blue: blue,
      alpha: alpha
    )
  }

  private static func decodeDouble(_ value: Any?) -> Double? {
    if let double = value as? Double { return double }
    return (value as? NSNumber)?.doubleValue
  }
}

/// The multiline editor, with paste trimmed.
///
/// Text copied out of a web page or a PDF arrives with the edges of the
/// selection attached — a trailing newline, an indent off the left margin —
/// and in a translation input those edges are never wanted.
private final class TrimmingTextView: NSTextView {
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
