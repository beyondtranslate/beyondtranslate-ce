import Foundation
import NaturalLanguage
import Translation

private func systemTranslationServiceBridgeRequestObserver(
  _ center: CFNotificationCenter?,
  _ observer: UnsafeMutableRawPointer?,
  _ name: CFNotificationName?,
  _ object: UnsafeRawPointer?,
  _ userInfo: CFDictionary?
) {
  SystemTranslationServiceBridge.handleRequest(userInfo: userInfo)
}

// MARK: - System Translation Service Bridge

/// A lightweight bridge that listens for system translation service requests from Rust
/// via CFNotificationCenter, translates using the system `Translation`
/// framework, and broadcasts the result back.
///
/// - Communication: CFNotificationCenter (local, in-process)
///   * Request notification: `com.beyondtranslate.systemTranslation.request`
///     Payload (CFDictionary):
///       - Translate: `requestId`, `operation=translate`, `text`,
///         `sourceLanguage`, `targetLanguage`
///       - Detect language: `requestId`, `operation=detectLanguage`, `texts`
///         where `texts` is a JSON string array
///   * Response notification: `com.beyondtranslate.systemTranslation.response`
///     Payload (CFDictionary): `requestId`, `operation`, `success`,
///       `translatedText`, `detectedSourceLanguage`, `detections`, `error`
final class SystemTranslationServiceBridge {

  private static let requestName = "com.beyondtranslate.systemTranslation.request" as CFString
  private static let responseName = "com.beyondtranslate.systemTranslation.response" as CFString

  private init() {}

  // MARK: - Public API

  /// Start listening for translation requests. Safe to call multiple times;
  /// the underlying CFNotificationCenter observer is registered only once.
  static func start() {
    DispatchQueue.once {
      let center = CFNotificationCenterGetLocalCenter()

      CFNotificationCenterAddObserver(
        center,
        nil,
        systemTranslationServiceBridgeRequestObserver,
        requestName,
        nil,
        .deliverImmediately
      )

      NSLog("[SystemTranslationServiceBridge] System translation service bridge started")
    }
  }

  // MARK: - Request handling

  fileprivate static func handleRequest(userInfo: CFDictionary?) {
    guard #available(macOS 13, *) else {
      NSLog("[SystemTranslationServiceBridge] Ignored request on macOS < 13")
      return
    }
    guard let info = userInfo as? [String: String],
      let requestId = info["requestId"]
    else {
      NSLog("[SystemTranslationServiceBridge] Ignored invalid request (missing required fields)")
      return
    }

    let operation = info["operation"] ?? "translate"

    if operation == "detectLanguage" {
      handleDetectLanguageRequest(requestId: requestId, info: info)
      return
    }

    guard let text = info["text"],
      let targetLang = info["targetLanguage"]
    else {
      NSLog("[SystemTranslationServiceBridge] Ignored invalid translation request")
      return
    }

    let sourceLang = info["sourceLanguage"]

    Task {
      let resultPayload: [String: String]

      do {
        guard #available(macOS 26, *) else {
          throw TranslationError.translationUnavailable
        }

        let tgtLocale = Locale.Language(identifier: targetLang)

        var sourceLanguage = sourceLang
        if sourceLanguage == nil || sourceLanguage!.isEmpty || sourceLanguage! == "auto" {
          // Detection may honestly refuse (see `detectLanguage`), but the
          // user asked for a translation — refusing to produce one is the
          // wrong answer. Unlike the standalone detect operation, where
          // "unknown" is a useful reply, here we owe a best effort.
          var resolved = await detectLanguage(text)
          if resolved == nil {
            resolved = await fallbackSourceLanguage(for: text, target: tgtLocale)
          }
          guard let resolved else {
            throw TranslationError.detectionFailed
          }
          sourceLanguage = resolved
        }

        let srcLocale = Locale.Language(identifier: sourceLanguage!)

        let availability = LanguageAvailability()
        let status = await availability.status(from: srcLocale, to: tgtLocale)
        switch status {
        case .installed:
          break
        case .supported:
          throw TranslationError.languagePairNotInstalled(
            source: sourceLanguage!,
            target: targetLang
          )
        case .unsupported:
          throw TranslationError.unsupportedLanguagePair(
            source: sourceLanguage!,
            target: targetLang
          )
        @unknown default:
          throw TranslationError.unsupportedLanguagePair(
            source: sourceLanguage!,
            target: targetLang
          )
        }

        let session = TranslationSession(installedSource: srcLocale, target: tgtLocale)
        let response = try await session.translate(text)

        resultPayload = [
          "requestId": requestId,
          "operation": "translate",
          "success": "true",
          "translatedText": response.targetText,
          "detectedSourceLanguage": sourceLanguage!,
        ]
      } catch {
        resultPayload = [
          "requestId": requestId,
          "operation": "translate",
          "success": "false",
          "error": error.localizedDescription,
        ]
      }

      postResponse(resultPayload)
    }
  }

  private static func handleDetectLanguageRequest(requestId: String, info: [String: String]) {
    let texts: [String]
    if let textsJson = info["texts"] {
      do {
        texts = try decodeTexts(textsJson)
      } catch {
        postResponse([
          "requestId": requestId,
          "operation": "detectLanguage",
          "success": "false",
          "error": error.localizedDescription,
        ])
        return
      }
    } else if let text = info["text"] {
      texts = [text]
    } else {
      NSLog("[SystemTranslationServiceBridge] Ignored invalid detect language request")
      return
    }

    Task {
      do {
        // Texts whose language cannot be identified are left out rather than
        // given a guess. Callers treat a missing detection as "unknown" and
        // fall back to their configured targets, which is the honest answer;
        // a fabricated language silently routes the translation elsewhere.
        var detections: [[String: String]] = []
        for text in texts {
          guard let language = await detectLanguage(text) else { continue }
          detections.append(["detected_language": language, "text": text])
        }

        let data = try JSONSerialization.data(withJSONObject: detections)
        guard let detectionsJson = String(data: data, encoding: .utf8) else {
          throw TranslationError.serializationFailed
        }

        postResponse([
          "requestId": requestId,
          "operation": "detectLanguage",
          "success": "true",
          "detections": detectionsJson,
        ])
      } catch {
        postResponse([
          "requestId": requestId,
          "operation": "detectLanguage",
          "success": "false",
          "error": error.localizedDescription,
        ])
      }
    }
  }

  // MARK: - Language detection

  /// Detects the language of `text`, or returns `nil` when it cannot be
  /// identified confidently enough to act on.
  ///
  /// `NLLanguageRecognizer.dominantLanguage` is an unconditional argmax over
  /// every language the OS knows, so a two-character input falls back to the
  /// model's prior and produces a confident-looking answer with no evidence
  /// behind it — the string "hi" scores Catalan at 0.80, because `hi` is a
  /// high-frequency Catalan pronoun (`hi ha`) and a rare English
  /// interjection. It then reports a language the provider cannot even
  /// translate (Apple Translate supports 21 languages; Catalan is not one).
  ///
  /// So instead of inventing a confidence cutoff, ask the framework the
  /// question that actually matters:
  ///
  /// 1. `LanguageAvailability.status(for:to:)` runs Apple's own
  ///    translation-side identifier and throws
  ///    `Translation.TranslationError.unableToIdentifyLanguage`
  ///    when it will not commit. That is a calibrated refusal, not a
  ///    threshold we guessed.
  /// 2. `NLLanguageRecognizer` is then constrained to the languages this
  ///    provider can actually translate, queried from the framework rather
  ///    than hardcoded, so it can never name an unusable language.
  /// 3. Han text is disambiguated deterministically (see `refineHanVariant`)
  ///    rather than left to a statistical coin flip.
  private static func detectLanguage(_ text: String) async -> String? {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    guard #available(macOS 15, *) else {
      return legacyDetectLanguage(trimmed)
    }

    // 1. Apple's own identifier gets to veto.
    do {
      _ = try await LanguageAvailability().status(for: trimmed, to: nil)
    } catch  where Translation.TranslationError.unableToIdentifyLanguage ~= error {
      return nil
    } catch {
      // Any other failure (pairing, availability, internal) says nothing
      // about identification — keep going.
    }

    // 2. Constrain to what this provider can translate.
    let recognizer = NLLanguageRecognizer()
    let constraints = await translatableLanguageConstraints()
    if !constraints.isEmpty {
      recognizer.languageConstraints = constraints
    }
    recognizer.processString(trimmed)
    guard let dominant = recognizer.dominantLanguage else { return nil }

    // 3. Han script carries no reliable simplified/traditional signal for
    //    the statistical model; decide it from the characters themselves.
    return refineHanVariant(dominant.rawValue, in: trimmed)
  }

  /// Detection path for macOS < 15, where `LanguageAvailability` — and with
  /// it Apple's refusal signal and the translatable-language list — does not
  /// exist. System translation itself requires macOS 26, so this only ever
  /// serves standalone detection requests. Best effort: require both real
  /// evidence and real confidence before committing.
  private static func legacyDetectLanguage(_ text: String) -> String? {
    let recognizer = NLLanguageRecognizer()
    recognizer.processString(text)
    guard let hypothesis = recognizer.languageHypotheses(withMaximum: 1).first else {
      return nil
    }

    // A single short Latin-script token is the failure mode ("hi", "ok",
    // "bye"): no evidence, high prior. Non-Latin scripts are far more
    // informative per character, so only gate Latin text on token count.
    let isLatin = text.unicodeScalars.allSatisfy { $0.value < 0x0250 }
    let tokens = text.split { !$0.isLetter }
    if isLatin && tokens.count < 2 { return nil }
    guard hypothesis.value >= 0.5 else { return nil }

    return refineHanVariant(hypothesis.key.rawValue, in: text)
  }

  /// Best-effort source language for the translate path, used only after
  /// `detectLanguage` has declined to commit.
  ///
  /// Identification refuses on genuinely low-evidence input, but the ranked
  /// hypotheses underneath are not worthless: `NLLanguageRecognizer` is
  /// reliable at telling scripts apart and only flounders *within* the Latin
  /// script. Two rules make that usable:
  ///
  /// * Prefer the highest-confidence candidate whose pair to `target` is
  ///   already installed. The Latin hypotheses the model over-ranks for
  ///   short input (Turkish for "hi", Polish for "ok") are exactly the ones
  ///   a user has no language files for, so this walks past them and lands
  ///   on the language they can actually translate from.
  /// * Otherwise return the top candidate anyway, so the availability check
  ///   downstream can report a precise, actionable
  ///   "Russian to Chinese is not installed" rather than a shrug.
  @available(macOS 26, *)
  private static func fallbackSourceLanguage(
    for text: String,
    target: Locale.Language
  ) async -> String? {
    let recognizer = NLLanguageRecognizer()
    let constraints = await translatableLanguageConstraints()
    if !constraints.isEmpty {
      recognizer.languageConstraints = constraints
    }
    recognizer.processString(text)

    let ranked = recognizer.languageHypotheses(withMaximum: 10)
      .sorted { $0.value > $1.value }
      .map { refineHanVariant($0.key.rawValue, in: text) }
    guard let top = ranked.first else { return nil }

    let availability = LanguageAvailability()
    for candidate in ranked {
      let source = Locale.Language(identifier: candidate)
      if await availability.status(from: source, to: target) == .installed {
        return candidate
      }
    }
    return top
  }

  /// NLLanguage codes for the languages the system translator can actually
  /// handle. Queried from `LanguageAvailability` so it tracks the OS instead
  /// of drifting against a hardcoded copy.
  @available(macOS 15, *)
  private static func translatableLanguageConstraints() async -> [NLLanguage] {
    var codes = Set<String>()
    for language in await LanguageAvailability().supportedLanguages {
      guard let base = language.languageCode?.identifier else { continue }
      // NLLanguage spells Chinese with its script ("zh-Hans"/"zh-Hant");
      // every other language is the bare subtag.
      if base == "zh", let script = language.script?.identifier {
        codes.insert("\(base)-\(script)")
      } else {
        codes.insert(base)
      }
    }
    return codes.sorted().map { NLLanguage(rawValue: $0) }
  }

  /// Replaces a `zh-*` guess with the variant the characters actually spell.
  ///
  /// Simplified and traditional Chinese are near-identical to a character
  /// n-gram model, so it effectively picks one at random — "你好" comes back
  /// as `zh-Hant`. ICU's `Traditional-Simplified` transform answers this
  /// exactly: text that survives the forward transform unchanged contains no
  /// traditional-only characters, and vice versa. Text that survives both is
  /// genuinely variant-neutral ("你好", "中文"), and there the user's own
  /// system languages are a better tiebreak than a coin flip.
  private static func refineHanVariant(_ language: String, in text: String) -> String {
    guard language.hasPrefix("zh") else { return language }

    let hasNoTraditionalOnly = transformHan(text, toTraditional: false) == text
    let hasNoSimplifiedOnly = transformHan(text, toTraditional: true) == text

    switch (hasNoTraditionalOnly, hasNoSimplifiedOnly) {
    case (true, true): return preferredChineseVariant()
    case (true, false): return "zh-Hans"
    case (false, true): return "zh-Hant"
    case (false, false): return language  // mixed; leave the model's call
    }
  }

  private static func transformHan(_ text: String, toTraditional: Bool) -> String {
    let mutable = NSMutableString(string: text) as CFMutableString
    CFStringTransform(mutable, nil, "Traditional-Simplified" as CFString, toTraditional)
    return mutable as String
  }

  /// Tiebreak for variant-neutral Han text, taken from the user's configured
  /// system languages rather than assumed.
  private static func preferredChineseVariant() -> String {
    // Parsed by subtag rather than via `Locale.Language`, which needs
    // macOS 13 while this bridge deploys back to 10.15.
    for identifier in Locale.preferredLanguages {
      let subtags = identifier.split(separator: "-").map(String.init)
      guard subtags.first?.lowercased() == "zh" else { continue }
      if subtags.contains(where: { $0.caseInsensitiveCompare("Hant") == .orderedSame }) {
        return "zh-Hant"
      }
      if subtags.contains(where: { $0.caseInsensitiveCompare("Hans") == .orderedSame }) {
        return "zh-Hans"
      }
      // Region-only spellings ("zh-TW", "zh-HK", "zh-MO") imply traditional.
      let traditionalRegions = ["TW", "HK", "MO"]
      if subtags.dropFirst().contains(where: { traditionalRegions.contains($0.uppercased()) }) {
        return "zh-Hant"
      }
      return "zh-Hans"
    }
    return "zh-Hans"
  }

  private static func decodeTexts(_ json: String) throws -> [String] {
    guard let data = json.data(using: .utf8),
      let texts = try JSONSerialization.jsonObject(with: data) as? [String]
    else {
      throw TranslationError.invalidDetectLanguagePayload
    }
    return texts
  }

  private static func postResponse(_ payload: [String: String]) {
    let center = CFNotificationCenterGetLocalCenter()
    CFNotificationCenterPostNotification(
      center,
      CFNotificationName(rawValue: responseName),
      nil,
      payload as CFDictionary,
      true
    )
  }
}

// MARK: - Local error

private enum TranslationError: LocalizedError {
  case detectionFailed
  case invalidDetectLanguagePayload
  case serializationFailed
  case translationUnavailable
  case languagePairNotInstalled(source: String, target: String)
  case unsupportedLanguagePair(source: String, target: String)

  var errorDescription: String? {
    switch self {
    case .detectionFailed:
      return "Unable to detect source language"
    case .invalidDetectLanguagePayload:
      return "Detect language request texts must be a JSON string array"
    case .serializationFailed:
      return "Unable to serialize language detection response"
    case .translationUnavailable:
      return "System translation requires macOS 26 or later"
    case .languagePairNotInstalled(let source, let target):
      return
        "System translation language files are not installed for \(source) to \(target). Install the languages in System Settings > General > Language & Region > Translation Languages, then try again."
    case .unsupportedLanguagePair(let source, let target):
      return "System translation does not support translating from \(source) to \(target)"
    }
  }
}

// MARK: - DispatchOnce helper

extension DispatchQueue {
  private static var onceTracker: Set<String> = []

  /// Executes `block` exactly once per unique `key` across the lifetime of
  /// the process. Thread-safe.
  fileprivate static func once(_ block: @escaping () -> Void) {
    objc_sync_enter(self)
    defer { objc_sync_exit(self) }
    let key = "com.beyondtranslate.SystemTranslationServiceBridge.start"
    guard !onceTracker.contains(key) else { return }
    onceTracker.insert(key)
    block()
  }
}
