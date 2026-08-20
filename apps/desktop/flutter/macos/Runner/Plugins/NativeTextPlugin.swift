import AppKit
import FlutterMacOS

/// A read-only, selectable run of text drawn by AppKit.
///
/// 译文 is the one place in the app where the text *is* the product: it gets
/// selected, copied, looked up, spoken, and dragged out. Flutter's
/// `SelectableText` offers none of what a Mac user reaches for there — no
/// Services menu, no ⌃⌘D lookup, no share sheet, no native drag — so the
/// translation is handed to `NSTextView` and Flutter only reserves the box.
///
/// The companion to `NativeTextFieldPlugin`: same channel shape, same style
/// encoding, but never editable.
final class NativeTextPlugin: NSObject {
  static let viewType = "beyondtranslate/native_text"

  static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(
      NativeTextFactory(messenger: registrar.messenger),
      withId: viewType
    )
  }
}

private final class NativeTextFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    NativeTextView(
      viewId: viewId,
      messenger: messenger,
      arguments: args as? [String: Any]
    )
  }

  func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

private final class NativeTextView: NSView {
  private let channel: FlutterMethodChannel
  private let padding: NSEdgeInsets
  private var text: String
  private var textStyle: NativeTextStyle
  private var alignment: NSTextAlignment
  private var isSelectable: Bool
  private var selectionColor: NSColor?

  /// TextKit 1, assembled by hand. A programmatically created `NSTextView`
  /// comes up on TextKit 2 and only falls back the moment `layoutManager` is
  /// touched; owning the stack keeps `usedRect(for:)` — the whole basis for the
  /// height reported to Flutter — off that implicit downgrade.
  private let textStorage = NSTextStorage()
  private let layoutManager = SelectionLayoutManager()
  private let textContainer = NSTextContainer(size: .zero)
  private let textView: SelectableTextView

  private var lastReportedContentSize: NSSize = NSSize(width: -1, height: -1)
  private var trackingArea: NSTrackingArea?

  init(
    viewId: Int64,
    messenger: FlutterBinaryMessenger,
    arguments: [String: Any]?
  ) {
    let args = arguments ?? [:]
    channel = FlutterMethodChannel(
      name: "beyondtranslate/native_text/\(viewId)",
      binaryMessenger: messenger
    )
    padding = NativeTextView.decodePadding(args["padding"])
    text = args["text"] as? String ?? ""
    textStyle = NativeTextStyle(arguments: args["style"] as? [String: Any])
    alignment = NativeTextView.decodeAlignment(args["textAlign"])
    isSelectable = args["selectable"] as? Bool ?? true
    selectionColor = NativeTextStyle.decodeColor(args["selectionColor"])

    textStorage.addLayoutManager(layoutManager)
    layoutManager.addTextContainer(textContainer)
    textContainer.lineFragmentPadding = 0
    textContainer.widthTracksTextView = false
    textView = SelectableTextView(frame: .zero, textContainer: textContainer)

    super.init(frame: .zero)

    appearance = NativeTextView.decodeAppearance(args["appearance"])
    wantsLayer = true
    layer?.backgroundColor = NSColor.clear.cgColor
    setupTextView()
    applyAttributedText()
    setupChannel()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupTextView() {
    textView.drawsBackground = false
    textView.isEditable = false
    textView.isSelectable = isSelectable
    textView.isRichText = false
    textView.importsGraphics = false
    textView.allowsUndo = false
    textView.usesFontPanel = false
    textView.focusRingType = .none
    textView.isVerticallyResizable = true
    textView.isHorizontallyResizable = false
    textView.textContainerInset = .zero
    textView.minSize = .zero
    textView.maxSize = NSSize(
      width: CGFloat.greatestFiniteMagnitude,
      height: CGFloat.greatestFiniteMagnitude
    )
    applySelectionColor()
    textView.onClick = { [weak self] clickCount in
      guard let self else { return }
      self.channel.invokeMethod("tapped", arguments: nil)
      if clickCount == 2 {
        self.channel.invokeMethod("doubleTapped", arguments: nil)
      }
    }
    addSubview(textView)
  }

  /// Top-left origin, so the padding arithmetic reads the way Flutter wrote it.
  override var isFlipped: Bool { true }

  override func layout() {
    super.layout()
    let width = max(0, bounds.width - padding.left - padding.right)
    textContainer.size = NSSize(
      width: width,
      height: CGFloat.greatestFiniteMagnitude
    )
    textView.frame = NSRect(
      x: bounds.minX + padding.left,
      y: bounds.minY + padding.top,
      width: width,
      height: max(0, bounds.height - padding.top - padding.bottom)
    )
    reportContentSizeIfNeeded()
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
    if isSelectable {
      NSCursor.iBeam.set()
    }
  }

  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
    NSCursor.arrow.set()
  }

  /// The mini translator runs as `.accessory` and has no menu bar, so AppKit
  /// never gets a chance to match ⌘C / ⌘A against the Edit menu. Send the
  /// standard actions down the responder chain ourselves — the same fix
  /// `NativeTextFieldPlugin` makes for the editable case.
  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    guard modifiers == .command,
      window?.firstResponder === textView,
      let action = Self.selectionAction(
        for: event.charactersIgnoringModifiers?.lowercased()
      )
    else {
      return super.performKeyEquivalent(with: event)
    }
    return NSApp.sendAction(action, to: nil, from: self)
  }

  /// Only the two that make sense on text nobody can edit.
  private static func selectionAction(for key: String?) -> Selector? {
    switch key {
    case "c": return #selector(NSText.copy(_:))
    case "a": return #selector(NSStandardKeyBindingResponding.selectAll(_:))
    default: return nil
    }
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
      case "setStyle":
        self.setStyle(call.arguments as? [String: Any] ?? [:])
        result(nil)
      case "setAppearance":
        self.appearance = NativeTextView.decodeAppearance(call.arguments)
        result(nil)
      case "setSelectionColor":
        self.selectionColor = NativeTextStyle.decodeColor(call.arguments)
        self.applySelectionColor()
        result(nil)
      case "setSelectable":
        self.isSelectable = call.arguments as? Bool ?? true
        self.textView.isSelectable = self.isSelectable
        result(nil)
      case "copy":
        self.copyAll()
        result(nil)
      case "selectAll":
        self.textView.selectAll(nil)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// Left unset, AppKit paints the selection in the system accent — the colour
  /// from System Settings, which has nothing to do with the app's theme. Only
  /// the background is named, so the glyphs keep the colour the style gave them.
  private func applySelectionColor() {
    guard let selectionColor else { return }
    textView.selectedTextAttributes = [.backgroundColor: selectionColor]
    layoutManager.selectionColor = selectionColor
  }

  private func setText(_ newText: String) {
    guard newText != text else { return }
    text = newText
    applyAttributedText()
  }

  private func setStyle(_ args: [String: Any]) {
    textStyle = NativeTextStyle(arguments: args["style"] as? [String: Any])
    if args["textAlign"] != nil {
      alignment = NativeTextView.decodeAlignment(args["textAlign"])
    }
    applyAttributedText()
  }

  private func copyAll() {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
  }

  private func applyAttributedText() {
    textStorage.setAttributedString(
      textStyle.attributedString(text, alignment: alignment)
    )
    // A selection anchored in the old string would survive into the new one and
    // highlight an unrelated span.
    textView.setSelectedRange(NSRange(location: 0, length: 0))
    needsLayout = true
    // Dart drops its cached measurement whenever the text or style changes, so
    // the next report has to go out even if the size lands on the old numbers.
    lastReportedContentSize = NSSize(width: -1, height: -1)
    reportContentSizeIfNeeded()
  }

  /// Flutter sizes the box, so it needs the height this text wants at the width
  /// it was given. The width goes back with it: until Dart sees a measurement
  /// taken at the width it is currently offering, it keeps sizing the box from
  /// its own `TextPainter` rather than from a stale answer.
  ///
  /// Reported without the padding — the Dart side knows its own insets and adds
  /// them back.
  private func reportContentSizeIfNeeded() {
    let width = textContainer.size.width
    guard width > 0 else { return }
    layoutManager.ensureLayout(for: textContainer)
    let usedHeight = layoutManager.usedRect(for: textContainer).height
    // An empty translation still occupies its line, the way the Flutter text it
    // replaces did.
    let height = ceil(max(textStyle.lineHeight, usedHeight))
    let size = NSSize(width: width, height: height)
    guard
      abs(size.height - lastReportedContentSize.height) >= 0.5
        || abs(size.width - lastReportedContentSize.width) >= 0.5
    else { return }

    lastReportedContentSize = size
    channel.invokeMethod(
      "contentSizeChanged",
      arguments: ["width": Double(size.width), "height": Double(size.height)]
    )
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

  private static func decodeAlignment(_ value: Any?) -> NSTextAlignment {
    switch value as? String {
    case "center": return .center
    case "right", "end": return .right
    case "justify": return .justified
    default: return .natural
    }
  }

  private static func decodeDouble(_ value: Any?) -> Double? {
    if let double = value as? Double { return double }
    return (value as? NSNumber)?.doubleValue
  }
}

/// `NSTextView` swallows the mouse, so a Flutter `GestureDetector` wrapped
/// around the platform view never sees a click. 双击复制 lives on the Dart side,
/// so the clicks are forwarded there instead.
private final class SelectableTextView: NSTextView {
  var onClick: ((Int) -> Void)?

  override func mouseDown(with event: NSEvent) {
    onClick?(event.clickCount)
    super.mouseDown(with: event)
  }
}

/// The Flutter `TextStyle` fields the Dart side encodes, resolved into AppKit.
private struct NativeTextStyle {
  let font: NSFont
  let color: NSColor
  let letterSpacing: CGFloat?
  /// `TextStyle.height` is a multiple of the font size, not of the font's own
  /// line height — the CSS meaning, which is what the design tokens carry.
  let lineHeight: CGFloat

  init(arguments: [String: Any]?) {
    let args = arguments ?? [:]
    let fontSize = CGFloat(NativeTextStyle.decodeDouble(args["fontSize"]) ?? 13)
    let weight = NativeTextStyle.decodeWeight(args["fontWeight"])
    font = NativeTextStyle.resolveFont(
      family: args["fontFamily"] as? String,
      fallback: args["fontFamilyFallback"] as? [String] ?? [],
      size: fontSize,
      weight: weight
    )
    color = NativeTextStyle.decodeColor(args["color"]) ?? NSColor.labelColor
    letterSpacing = NativeTextStyle.decodeDouble(args["letterSpacing"]).map { CGFloat($0) }
    if let multiple = NativeTextStyle.decodeDouble(args["height"]) {
      lineHeight = fontSize * CGFloat(multiple)
    } else {
      lineHeight = ceil(font.ascender - font.descender + font.leading)
    }
  }

  func attributedString(_ string: String, alignment: NSTextAlignment) -> NSAttributedString {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byWordWrapping
    // Pinning both ends is how AppKit is told a line box measures exactly this,
    // which is what CSS `line-height` (and so `TextStyle.height`) means.
    paragraph.minimumLineHeight = lineHeight
    paragraph.maximumLineHeight = lineHeight

    var attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: color,
      .paragraphStyle: paragraph,
    ]
    if let letterSpacing {
      attributes[.kern] = letterSpacing
    }
    // AppKit hangs the extra leading below the baseline; Flutter's design
    // tokens ask for `TextLeadingDistribution.even`, so give half of it back
    // above by dropping the glyphs into the middle of the line box.
    let naturalHeight = font.ascender - font.descender
    let extraLeading = lineHeight - naturalHeight
    if extraLeading > 0 {
      attributes[.baselineOffset] = -extraLeading / 2
    }
    return NSAttributedString(string: string, attributes: attributes)
  }

  /// The design tokens name a family (`PingFang SC`) with fallbacks, the way
  /// CSS does. `NSFont(name:)` answers whether the family is actually
  /// installed; the descriptor then carries the weight onto it.
  private static func resolveFont(
    family: String?,
    fallback: [String],
    size: CGFloat,
    weight: NSFont.Weight
  ) -> NSFont {
    for name in ([family].compactMap { $0 } + fallback) {
      guard NSFont(name: name, size: size) != nil else { continue }
      let descriptor = NSFontDescriptor(fontAttributes: [
        .family: name,
        .traits: [NSFontDescriptor.TraitKey.weight: weight.rawValue],
      ])
      if let font = NSFont(descriptor: descriptor, size: size) {
        return font
      }
    }
    return NSFont.systemFont(ofSize: size, weight: weight)
  }

  /// Flutter spells weight as 100…900; AppKit as a float around zero.
  private static func decodeWeight(_ value: Any?) -> NSFont.Weight {
    switch decodeDouble(value).map(Int.init) ?? 400 {
    case ..<150: return .ultraLight
    case ..<250: return .thin
    case ..<350: return .light
    case ..<450: return .regular
    case ..<550: return .medium
    case ..<650: return .semibold
    case ..<750: return .bold
    case ..<850: return .heavy
    default: return .black
    }
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
