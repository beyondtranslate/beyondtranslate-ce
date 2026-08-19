import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var engine: FlutterEngine?

  @MainActor
  var flutterEngine: FlutterEngine {
    if let engine {
      return engine
    }

    let engine = FlutterEngine(
      name: "beyondtranslate",
      project: nil,
      allowHeadlessExecution: true
    )
    engine.run(withEntrypoint: nil)
    RegisterGeneratedPlugins(registry: engine)
    MacWindowAppearancePlugin.register(
      with: engine.registrar(forPlugin: "MacWindowAppearancePlugin")
    )
    NativeTextFieldPlugin.register(
      with: engine.registrar(forPlugin: "NativeTextFieldPlugin")
    )
    NativeTextPlugin.register(
      with: engine.registrar(forPlugin: "NativeTextPlugin")
    )
    MacAppPresentationPlugin.register(
      with: engine.registrar(forPlugin: "MacAppPresentationPlugin")
    )
    self.engine = engine
    return engine
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  /// This is a menu bar app: closing the last window hides it rather than
  /// quitting, so the process must survive an empty window list.
  override func applicationShouldTerminateAfterLastWindowClosed(
    _ sender: NSApplication
  ) -> Bool {
    return false
  }

  /// Reached when the user clicks the Dock icon, which only exists while
  /// `DockIconController` has promoted the app to `.regular`. Dart decides what
  /// to bring forward; returning false stops AppKit from unhiding windows on
  /// its own.
  override func applicationShouldHandleReopen(
    _ sender: NSApplication,
    hasVisibleWindows flag: Bool
  ) -> Bool {
    MacAppPresentationPlugin.shared?.notifyReopen()
    return false
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    _ = flutterEngine
    observeWindows()
    connectPreferencesMenuItem()
  }

  /// The template's Preferences… item ships with no action, so it renders
  /// disabled once the menu bar becomes visible. Point it at the Dart side.
  private func connectPreferencesMenuItem() {
    guard let appMenu = NSApp.mainMenu?.items.first?.submenu else { return }

    for item in appMenu.items
    where item.keyEquivalent == ","
      && item.keyEquivalentModifierMask == .command
    {
      item.target = self
      item.action = #selector(openSettings(_:))
      return
    }
  }

  @objc private func openSettings(_ sender: Any?) {
    MacAppPresentationPlugin.shared?.notifyOpenSettings()
  }

  /// Windows are created by the Flutter multi-window API, so there is no
  /// NSWindow subclass to hook into. Attach the dummy toolbar as each window
  /// shows up instead.
  private func observeWindows() {
    for name in [NSWindow.didUpdateNotification, NSWindow.didBecomeKeyNotification] {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(installDummyToolbar(_:)),
        name: name,
        object: nil
      )
    }
  }

  /// An empty toolbar moves the traffic light buttons down into the toolbar row.
  @objc private func installDummyToolbar(_ notification: Notification) {
    guard
      let window = notification.object as? NSWindow,
      window.styleMask.contains(.titled),
      window.toolbar == nil
    else {
      return
    }

    window.toolbar = NSToolbar(identifier: "DummyToolbar")
  }
}
