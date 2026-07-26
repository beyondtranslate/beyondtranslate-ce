import Cocoa
import FlutterMacOS
import beyondtranslate_runtime

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
    smokeTestBeyondtranslateRuntime()
    self.engine = engine
    return engine
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    _ = flutterEngine
  }

  private func smokeTestBeyondtranslateRuntime() {
    NSLog("[beyondtranslate_runtime] version() = %@", beyondtranslate_runtime.version())
    NSLog(
      "[beyondtranslate_runtime] add(a: 2, b: 3) = %d",
      add(a: 2, b: 3)
    )
    NSLog(
      "[beyondtranslate_runtime] greet(name: \"AppDelegate\") = %@",
      greet(name: "AppDelegate")
    )
  }
}
