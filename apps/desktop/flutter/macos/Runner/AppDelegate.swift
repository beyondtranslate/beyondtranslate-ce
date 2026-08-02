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
    self.engine = engine
    return engine
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    _ = flutterEngine
    observeWindows()
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
