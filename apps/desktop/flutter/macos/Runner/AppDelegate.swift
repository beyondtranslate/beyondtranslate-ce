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
  }
}
