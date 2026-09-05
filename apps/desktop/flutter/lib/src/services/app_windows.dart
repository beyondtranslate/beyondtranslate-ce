// ignore_for_file: implementation_imports, invalid_use_of_internal_member

/// The app's two windows — the workbench and the mini translator — each with
/// its own lifecycle. They play different roles rather than excluding each
/// other:
///
///   * **the workbench is an ordinary document window.** It comes and goes
///     only through its own entry points — the tray menu's 显示窗口, the Dock
///     icon, the settings entries, ⌘W — and nothing the mini translator does
///     moves it.
///   * **the mini translator is a floating panel.** The global shortcut and the
///     tray icon's click toggle it; it closes as soon as it loses focus unless
///     it is pinned. On macOS it is a *non-activating* panel
///     (`Window.isNonActivating`): it takes key focus without activating this
///     app, so summoning it over another app neither brings the workbench
///     forward nor flashes the Dock icon, and putting it away hands the
///     keyboard straight back to where the user was. A non-activating panel at
///     the normal window level would sit behind the active app's windows, so
///     it lives at the floating level whether pinned or not — the pin only
///     decides whether blur closes it.
///
/// The hand-over between them falls out of focus rather than being wired up:
/// bringing the workbench front blurs the mini translator, which then closes
/// itself unless pinned. The one deliberate exception is
/// [handOffToWorkbench] — the mini translator's 在工作台中打开 is the user asking
/// to continue in the big window, so the small one is put away regardless.
///
/// Nothing outside this file shows or hides either window on its own — the
/// mini translator's close-on-blur, the workbench's close button and the
/// native close request all come back through [hideMiniTranslatorWindow] /
/// [hideWorkbenchWindow].
///
/// Hiding the workbench demotes the process to an accessory app (see
/// `DockIconController`); the macOS side keeps the app active through that
/// transition as long as one of our windows is still up.
library;

import 'dart:io';

import 'package:flutter/src/widgets/_window.dart' as flutter_window
    show
        WindowController,
        WindowControllerDelegate,
        WindowEntry,
        WindowRegistry;
import 'package:flutter/widgets.dart' hide Image;
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart';

import '../extensions/window_controller.dart';
import '../utils/platform_util.dart';
import 'dock_icon_controller.dart';

const kWorkbenchWindowTitle = 'BeyondTranslate';
const kMiniTranslatorWindowTitle = 'Mini Translator';
// The deck's main window: 840×560, panes scrolling internally rather than
// the window growing with content.
const _kWorkbenchWindowSize = Size(840, 560);
const _kWorkbenchWindowMinimumSize = Size(840, 560);
const _kMiniTranslatorTrayGap = 10.0;

GoRouter? _workbenchRouter;
String _pendingWorkbenchLocation = '/translate';
flutter_window.WindowRegistry? _windowRegistry;
WidgetBuilder? _miniTranslatorBuilder;
bool _miniTranslatorWindowRegistered = false;
bool _miniTranslatorEverPositioned = false;
bool _workbenchWindowConfigured = false;
bool _miniTranslatorWindowConfigured = false;

/// Text handed from the mini translator to the workbench's 翻译 page along with
/// [showWorkbenchWindow]. The page consumes it and sets it back to null.
final ValueNotifier<String?> workbenchTextHandoff = ValueNotifier(null);

enum WorkbenchDestination {
  translate('/translate'),
  history('/history'),
  glossary('/glossary'),
  settingsGeneral('/settings/general'),
  settingsServices('/settings/services'),
  settingsShortcuts('/settings/shortcuts'),
  settingsProviders('/settings/providers'),
  settingsAdvanced('/settings/advanced'),
  settingsAbout('/settings/about');

  const WorkbenchDestination(this.location);

  final String location;
}

// ──────────────────────────────────────────────────────────────────────────────
// Wiring from the widget layer
// ──────────────────────────────────────────────────────────────────────────────

/// Hands over the [registry] the mini translator window is registered with on
/// first use, and the widget tree to build into it. Called from the workbench
/// window's builder, which is the only place a registry is reachable from.
void attachWindowRegistry(
  flutter_window.WindowRegistry registry, {
  required WidgetBuilder miniTranslatorBuilder,
}) {
  _windowRegistry = registry;
  _miniTranslatorBuilder = miniTranslatorBuilder;
}

/// The workbench's live router, so [showWorkbenchWindow] can navigate it.
/// `WorkbenchApp` attaches it for the lifetime of its state.
void attachWorkbenchRouter(GoRouter router) {
  _workbenchRouter = router;
}

void detachWorkbenchRouter(GoRouter router) {
  if (_workbenchRouter == router) {
    _workbenchRouter = null;
  }
}

/// Where a freshly created workbench router should start — the destination
/// the last [showWorkbenchWindow] asked for.
String get pendingWorkbenchLocation => _pendingWorkbenchLocation;

// ──────────────────────────────────────────────────────────────────────────────
// Workbench window
// ──────────────────────────────────────────────────────────────────────────────

/// Custom delegate that hides the window instead of destroying it when closed.
/// The app continues running in the system tray.
class _HideOnCloseDelegate extends flutter_window.WindowControllerDelegate {
  @override
  void onWindowCloseRequested(flutter_window.WindowController controller) {
    if (controller.window == workbenchWindowController.window) {
      hideWorkbenchWindow();
    }
  }
}

final workbenchWindowController = flutter_window.WindowController(
  size: _kWorkbenchWindowSize,
  title: kWorkbenchWindowTitle,
  delegate: _HideOnCloseDelegate(),
)
  ..setWillShowHook((window) {
    // Driving the Dock icon from the window hooks rather than from the call
    // sites keeps the two in sync no matter who shows or hides the workbench.
    dockIconController.setWorkbenchWindowVisible(true);
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.minimumSize = _kWorkbenchWindowMinimumSize;
      window.setSize(_kWorkbenchWindowSize, false);
      window.center();
      return true;
    }
    return true;
  })
  ..setWillHideHook((window) {
    dockIconController.setWorkbenchWindowVisible(false);
    return true;
  });

/// Brings the workbench up on [destination]. The mini translator is left to
/// its blur rule: an unpinned one closes as the focus moves, a pinned one
/// stays floating above.
void showWorkbenchWindow({
  WorkbenchDestination destination = WorkbenchDestination.translate,
  String? text,
}) {
  _pendingWorkbenchLocation = destination.location;
  if (text != null) {
    workbenchTextHandoff.value = text;
  }
  _workbenchRouter?.go(_pendingWorkbenchLocation);
  focusWorkbenchWindow();
}

/// Hands [text] from the mini translator to the workbench's 翻译 page and puts
/// the mini translator away — the user has asked to carry on in the big
/// window, so the small one goes even when pinned.
void handOffToWorkbench(String text) {
  showWorkbenchWindow(text: text);
  hideMiniTranslatorWindow();
}

/// Brings the workbench front wherever it was — no navigation.
void focusWorkbenchWindow() {
  final window = workbenchWindowController.window;
  if (Platform.isWindows && !_workbenchWindowConfigured) {
    _workbenchWindowConfigured = true;
    window.titleBarStyle = TitleBarStyle.hidden;
    window.minimumSize = _kWorkbenchWindowMinimumSize;
    window.center();
  }
  // A minimized window is brought front but not out of the Dock by show().
  if (window.isMinimized) window.restore();
  window.show();
  window.focus();
}

/// The tray icon's left click pops the mini translator up under the icon, the
/// way menu bar utilities do, whatever the workbench is doing. The workbench
/// has its own ways back: the tray menu's 显示窗口, and the Dock icon while it
/// is open.
Future<void> handleTrayIconClick({Rect? trayBounds}) async {
  await showMiniTranslatorWindow(trayBounds: trayBounds);
}

void showSettingsWindow() {
  showWorkbenchWindow(destination: WorkbenchDestination.settingsGeneral);
}

/// Hides the workbench; the app lives on in the tray (or, with the tray off,
/// in the Dock). Safe to call when it is already hidden.
void hideWorkbenchWindow() {
  workbenchWindowController.window.hide();
}

// ──────────────────────────────────────────────────────────────────────────────
// Mini translator window
// ──────────────────────────────────────────────────────────────────────────────

final miniTranslatorWindowController = flutter_window.WindowController(
  // The deck's mini popover width (`--bt-mini-width`).
  size: const Size(396, 420),
  title: kMiniTranslatorWindowTitle,
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.isWindowControlButtonsVisible = false;
      if (kIsMacOS) {
        // Mini translator uses solid background, no transparency needed.
      }
      return false;
    }
    return true;
  });

/// Brings the mini translator up. The workbench is not touched.
///
/// The window is created on first use. [position] wins over [trayBounds],
/// which anchors the window under the tray icon; with neither the window stays
/// wherever it last was.
Future<void> showMiniTranslatorWindow({
  Offset? position,
  Rect? trayBounds,
}) async {
  if (!_miniTranslatorWindowRegistered) {
    final registry = _windowRegistry;
    final builder = _miniTranslatorBuilder;
    if (registry == null || builder == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMiniTranslatorWindow(position: position, trayBounds: trayBounds);
      });
      return;
    }
    _miniTranslatorWindowRegistered = true;
    registry.register(
      flutter_window.WindowEntry(
        controller: miniTranslatorWindowController,
        builder: builder,
      ),
    );
    await WidgetsBinding.instance.endOfFrame;
  }

  final window = miniTranslatorWindowController.window;
  if (!_miniTranslatorWindowConfigured) {
    _miniTranslatorWindowConfigured = true;
    if (Platform.isWindows) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.isWindowControlButtonsVisible = false;
    }
    if (kIsMacOS) {
      // See the note at the top of the file: a non-activating panel, kept at
      // the floating level so it shows in front of the active app.
      window.isNonActivating = true;
      window.isAlwaysOnTop = true;
    }
  }
  var newPosition = position ??
      (trayBounds != null
          ? _miniTranslatorPositionBelowTray(trayBounds)
          : null);
  // A first-ever show with no anchor (the global shortcut) would otherwise
  // appear wherever the OS created the window.
  if (newPosition == null && !_miniTranslatorEverPositioned) {
    newPosition = miniTranslatorPositionAtCursorScreenTopRight();
  }
  if (newPosition != null) {
    _miniTranslatorEverPositioned = true;
    window.position = newPosition;
  }
  window.show();
}

/// Hides the mini translator. Safe to call before it was ever shown and when
/// it is already hidden.
void hideMiniTranslatorWindow() {
  // Nothing to hide until the window exists — and touching the controller
  // before then would create it (the controller's constructor creates the
  // native window), while `ExtendedWindowController.window` would bind the
  // title to whatever unbound window it finds.
  if (!_miniTranslatorWindowRegistered) return;
  miniTranslatorWindowController.window.hide();
}

// ──────────────────────────────────────────────────────────────────────────────
// Mini translator placement
// ──────────────────────────────────────────────────────────────────────────────

Offset? _miniTranslatorPositionBelowTray(Rect trayBounds, {Size? windowSize}) {
  final size = windowSize ?? miniTranslatorWindowController.window.size;
  final anchor = _resolveTrayAnchor(trayBounds);
  if (anchor == null) return null;

  if (!kIsMacOS) {
    final position = Offset(
      anchor.bounds.left - (size.width - anchor.bounds.width) / 2,
      anchor.bounds.bottom + _kMiniTranslatorTrayGap,
    );
    return _clampPositionToDisplay(position, size, anchor.display);
  }

  final displayBounds = _displayBounds(anchor.display);
  final menuBarBottom = anchor.display.workArea.top > displayBounds.top
      ? anchor.display.workArea.top
      : displayBounds.top + anchor.bounds.height;
  final position = Offset(
    anchor.bounds.center.dx - size.width / 2,
    menuBarBottom + _kMiniTranslatorTrayGap,
  );
  return _clampPositionToDisplay(position, size, anchor.display);
}

/// Positions the mini translator at the top-right corner (50, 50) of the
/// display that currently contains the mouse cursor.
Offset? miniTranslatorPositionAtCursorScreenTopRight({Size? windowSize}) {
  final cursorPosition = DisplayManager.instance.getCursorPosition();
  final displays = DisplayManager.instance.getAll();
  if (displays.isEmpty) return null;

  // Find the display that contains the cursor position
  Display? cursorDisplay;
  for (final display in displays) {
    final displayRect = Rect.fromLTWH(
      display.position.dx,
      display.position.dy,
      display.size.width,
      display.size.height,
    );
    if (displayRect.contains(cursorPosition)) {
      cursorDisplay = display;
      break;
    }
  }

  cursorDisplay ??= displays.first;
  final size = windowSize ?? miniTranslatorWindowController.window.size;

  // Top-right corner of the cursor's display, offset by (50, 50)
  final position = Offset(
    cursorDisplay.position.dx + cursorDisplay.size.width - size.width - 50,
    cursorDisplay.position.dy + 50,
  );

  return _clampPositionToDisplay(position, size, cursorDisplay);
}

Offset _clampPositionToDisplay(
  Offset position,
  Size windowSize,
  Display display,
) {
  final workArea = display.workArea;
  return Offset(
    _clampDouble(position.dx, workArea.left, workArea.right - windowSize.width),
    _clampDouble(
      position.dy,
      workArea.top,
      workArea.bottom - windowSize.height,
    ),
  );
}

_TrayAnchor? _resolveTrayAnchor(Rect rawBounds) {
  final displays = DisplayManager.instance.getAll();
  if (displays.isEmpty) return null;

  final rawCenter = rawBounds.center;
  for (final display in displays) {
    if (_displayBounds(display).contains(rawCenter)) {
      return _TrayAnchor(
        display: display,
        bounds: _trayBoundsOnDisplay(rawBounds, display),
      );
    }
  }

  for (final display in displays) {
    if (_containsHorizontally(_displayBounds(display), rawCenter.dx)) {
      return _TrayAnchor(
        display: display,
        bounds: _trayBoundsOnDisplay(rawBounds, display),
      );
    }
  }

  for (final display in displays) {
    final normalizedBounds = _normalizeScaledTrayBounds(rawBounds, display);
    if (_containsHorizontally(
      _displayBounds(display),
      normalizedBounds.center.dx,
    )) {
      return _TrayAnchor(
        display: display,
        bounds: _trayBoundsOnDisplay(normalizedBounds, display),
      );
    }
  }

  displays.sort((a, b) {
    final aDistance = _distanceSquared(_displayBounds(a).center, rawCenter);
    final bDistance = _distanceSquared(_displayBounds(b).center, rawCenter);
    return aDistance.compareTo(bDistance);
  });
  final display = displays.first;
  return _TrayAnchor(
    display: display,
    bounds: _trayBoundsOnDisplay(rawBounds, display),
  );
}

Rect _displayBounds(Display display) {
  return Rect.fromLTWH(
    display.position.dx,
    display.position.dy,
    display.size.width,
    display.size.height,
  );
}

Rect _trayBoundsOnDisplay(Rect bounds, Display display) {
  return Rect.fromLTWH(
    bounds.left,
    _displayBounds(display).top,
    bounds.width,
    bounds.height,
  );
}

Rect _normalizeScaledTrayBounds(Rect bounds, Display display) {
  final scaleFactor = display.scaleFactor;
  if (scaleFactor == 0 || scaleFactor == 1) return bounds;

  final displayBounds = _displayBounds(display);
  return Rect.fromLTWH(
    displayBounds.left +
        (bounds.left - displayBounds.left * scaleFactor) / scaleFactor,
    displayBounds.top +
        (bounds.top - displayBounds.top * scaleFactor) / scaleFactor,
    bounds.width / scaleFactor,
    bounds.height / scaleFactor,
  );
}

bool _containsHorizontally(Rect rect, double x) {
  return x >= rect.left && x <= rect.right;
}

double _distanceSquared(Offset a, Offset b) {
  final dx = a.dx - b.dx;
  final dy = a.dy - b.dy;
  return dx * dx + dy * dy;
}

double _clampDouble(double value, double min, double max) {
  if (max < min) return min;
  return value.clamp(min, max).toDouble();
}

class _TrayAnchor {
  const _TrayAnchor({required this.display, required this.bounds});

  final Display display;
  final Rect bounds;
}
