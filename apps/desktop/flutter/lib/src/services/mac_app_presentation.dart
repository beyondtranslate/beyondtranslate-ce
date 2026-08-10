import 'dart:io';

import 'package:flutter/services.dart';

/// Thin wrapper over the `MacAppPresentationPlugin` channel.
///
/// Carries the Dock icon / menu bar decision down to AppKit, and the two events
/// only AppKit can see — a Dock icon click and the app menu's Preferences… item
/// — back up. The policy itself lives in [DockIconController]; the routing of
/// the callbacks lives in `app_router.dart`.
class MacAppPresentation {
  static const MethodChannel _channel = MethodChannel(
    'beyondtranslate/mac_app_presentation',
  );

  static VoidCallback? _onReopen;
  static VoidCallback? _onOpenSettings;
  static bool _isHandlerInstalled = false;

  /// Shows or hides the Dock icon by switching the process between macOS'
  /// `regular` and `accessory` activation policies. The main menu bar follows
  /// the Dock icon: `accessory` apps do not get one.
  static Future<void> setDockIconVisible(bool visible) async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>('setDockIconVisible', {
      'visible': visible,
    });
  }

  /// Registers what to do when the user clicks the Dock icon ([onReopen]) or
  /// picks Preferences… / ⌘, ([onOpenSettings]).
  static void setHandlers({
    VoidCallback? onReopen,
    VoidCallback? onOpenSettings,
  }) {
    if (!Platform.isMacOS) return;

    _onReopen = onReopen;
    _onOpenSettings = onOpenSettings;

    if (_isHandlerInstalled) return;
    _isHandlerInstalled = true;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onReopen':
          _onReopen?.call();
        case 'onOpenSettings':
          _onOpenSettings?.call();
      }
      return null;
    });
  }
}
