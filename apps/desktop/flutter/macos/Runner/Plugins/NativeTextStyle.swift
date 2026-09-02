import AppKit

/// The Flutter `TextStyle` fields the Dart side encodes, resolved into AppKit.
///
/// Shared by `NativeTextPlugin` (译文, read-only) and `NativeTextFieldPlugin`
/// (原文, editable) so the two lay text out on identical line metrics: the box
/// Dart reserves is `fontSize × height` per line, and both views have to fill
/// exactly that.
struct NativeTextStyle {
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

  /// The attributes that set text in this style.
  ///
  /// `lineHeight` is the line box to lay it out in — this style's own unless
  /// the caller names another. A placeholder passes the line height of the
  /// text it stands in for, so it lands on the same baseline that text will.
  func attributes(
    alignment: NSTextAlignment = .natural,
    lineHeight lineBox: CGFloat? = nil
  ) -> [NSAttributedString.Key: Any] {
    let lineBox = lineBox ?? lineHeight
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byWordWrapping
    // Pinning both ends is how AppKit is told a line box measures exactly this,
    // which is what CSS `line-height` (and so `TextStyle.height`) means.
    paragraph.minimumLineHeight = lineBox
    paragraph.maximumLineHeight = lineBox

    var attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: color,
      .paragraphStyle: paragraph,
    ]
    if let letterSpacing {
      attributes[.kern] = letterSpacing
    }
    // TextKit seats the glyphs at the bottom of a taller line box — every bit
    // of extra leading lands above them — and a negative baseline offset that
    // would push them lower is silently dropped. Raising them by half the
    // extra is what puts them in the middle, the way CSS splits its leading
    // and the way Flutter draws the same style.
    let naturalHeight = font.ascender - font.descender
    let extraLeading = lineBox - naturalHeight
    if extraLeading > 0 {
      attributes[.baselineOffset] = extraLeading / 2
    }
    return attributes
  }

  func attributedString(
    _ string: String,
    alignment: NSTextAlignment = .natural,
    lineHeight lineBox: CGFloat? = nil
  ) -> NSAttributedString {
    NSAttributedString(
      string: string,
      attributes: attributes(alignment: alignment, lineHeight: lineBox)
    )
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

  static func decodeColor(_ value: Any?) -> NSColor? {
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
