import AppKit
import FlutterMacOS

/// Owns how the process presents itself to macOS: with a Dock icon and the main
/// menu bar (`.regular`), or as a status-bar-only app (`.accessory`).
///
/// The *decision* lives in Dart (`DockIconController`) because it depends on
/// app state — which windows are open, whether the tray icon is enabled. This
/// plugin only applies it, because the transition itself needs AppKit care that
/// has no Dart equivalent:
///
///   * promoting to `.regular` gives the process a Dock icon immediately, but
///     the menu bar is only drawn once the app becomes frontmost;
///   * demoting to `.accessory` while the app is frontmost leaves the stale
///     menu bar on screen until some other app takes over.
///
/// It also carries the two menu/Dock events that only AppKit sees back to Dart:
/// a click on the Dock icon, and the Preferences… item (⌘,).
final class MacAppPresentationPlugin: NSObject, FlutterPlugin {
  static let channelName = "beyondtranslate/mac_app_presentation"

  /// Set by [register] so `AppDelegate` can forward AppKit callbacks without
  /// threading the instance through the engine registrar.
  private(set) static weak var shared: MacAppPresentationPlugin?

  private let channel: FlutterMethodChannel

  private init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
  }

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: registrar.messenger
    )
    let instance = MacAppPresentationPlugin(channel: channel)
    shared = instance
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setDockIconVisible":
      guard
        let arguments = call.arguments as? [String: Any],
        let visible = arguments["visible"] as? Bool
      else {
        result(
          FlutterError(
            code: "bad_args",
            message: "Expected a boolean `visible`.",
            details: nil
          ))
        return
      }
      Task { @MainActor in
        Self.setDockIconVisible(visible)
        result(nil)
      }
    case "isDockIconVisible":
      Task { @MainActor in
        result(NSApp.activationPolicy() == .regular)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // AppKit → Dart
  // ──────────────────────────────────────────────────────────────────────────

  /// The user clicked the Dock icon (or re-launched the app while it runs).
  func notifyReopen() {
    channel.invokeMethod("onReopen", arguments: nil)
  }

  /// The user chose the app menu's Preferences… item (⌘,).
  func notifyOpenSettings() {
    channel.invokeMethod("onOpenSettings", arguments: nil)
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Activation policy
  // ──────────────────────────────────────────────────────────────────────────

  @MainActor
  static func setDockIconVisible(_ visible: Bool) {
    let policy: NSApplication.ActivationPolicy = visible ? .regular : .accessory
    guard NSApp.activationPolicy() != policy else { return }

    NSApp.setActivationPolicy(policy)

    // Both fix-ups have to run after AppKit has settled the policy change,
    // otherwise the activation is applied against the old policy and ignored.
    DispatchQueue.main.async {
      if visible {
        activateApp()
      } else if NSApp.isActive, !hasVisibleActivatableWindow() {
        // Hand the menu bar back to whatever the user was in before. Skipped
        // while one of our own windows is still up — deactivating would blur
        // the mini translator, which closes itself on blur.
        NSApp.deactivate()
      }
    }
  }

  /// `ignoringOtherApps` is deprecated since macOS 14 in favour of the
  /// cooperative `activate()`, but cooperative activation is refused for an app
  /// that has just promoted itself out of `.accessory` — it stays behind the
  /// previous app and never draws its menu bar. Promotion here is always the
  /// result of the user asking for a window, so taking the focus is the
  /// intended behaviour.
  @available(macOS, deprecated: 14.0)
  @MainActor
  private static func activateApp() {
    NSApp.activate(ignoringOtherApps: true)
  }

  @MainActor
  private static func hasVisibleActivatableWindow() -> Bool {
    NSApp.windows.contains { $0.isVisible && $0.canBecomeKey }
  }
}
