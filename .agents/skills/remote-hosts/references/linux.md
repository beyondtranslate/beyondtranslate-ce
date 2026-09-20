# Linux hosts

**Status: `setup`, `exec`, `run`, `push`, `pull` and the graphical-session path verified on Ubuntu 24.04
(GNOME 46, Wayland) on 2026-09-17/18.** Since then, on real projects: CMake, `cargo` and
`flutter build linux` builds in the SSH session, launching the bundle in the graphical session,
screen capture through Mutter ScreenCast, and a full GUI test with synthetic input all
worked. **Those runs used the earlier bash helper; its Python port (`hostrun.py`, same
session-environment import) has run on Windows and a local Mac only — the first `--gui`
run on a Linux host is the one to watch.** Verify each further step the first time and update this file with what you
learn — the Windows notes were all learned the hard way.

## Two places a script can run

**SSH session (plain `exec`, `run`)**: a plain login shell. No `DISPLAY`, so GUI programs
fail with "cannot open display". Fine for git, builds (`cmake`, `cargo`,
`flutter build linux`), logs.

**Logged-on desktop (`run --gui`, `exec --gui`)**: `hostrun.py` runs the script with the
environment of the user's graphical session, imported from
`systemctl --user show-environment` (GNOME puts `WAYLAND_DISPLAY`, `DISPLAY`,
`XAUTHORITY`, `XDG_SESSION_TYPE`, `XDG_CURRENT_DESKTOP` there). Fallbacks when that is
empty: `DISPLAY` = the host's `display` (default `:0`), `XAUTHORITY` from the `-auth` argument
of the Xorg/Xwayland process serving that display, then `~/.Xauthority`. The same user
must be logged on at the console. On a Wayland session GTK then picks its Wayland
backend (`GdkWaylandDisplay`), exactly as for an app started from the dock; force
`GDK_BACKEND=x11` in the script to test the Xwayland path instead.

Scripts find `REMOTE_HOST`, `REMOTE_WORKSPACE`, `REMOTE_SCRATCH`, `PYTHON` and the PATH
additions already in their environment.

## Wayland (GNOME on Wayland is the common target, not a problem to fix)

- **Check the session type, do not assume**: `loginctl show-session <id> -p Type` for the
  seat0 session (`who` shows `seat0 (login screen)` / `tty2` even while logged in).
- What a client cannot do on Wayland, by design: know its global window position, read
  the global pointer, see other apps' windows or stacking order, or capture the screen
  without a portal. Anything that grabs input or the screen either goes through a
  portal or only sees Xwayland — check which before blaming the test.
- The rootless Xwayland on `:0` is still there for X11 clients; its cookie is
  `/run/user/<uid>/.mutter-Xwaylandauth.XXXXXX` (new suffix per login — never hard-code
  it). Missing cookie → "Authorization required, but no authorization protocol specified".

### Synthetic input

- **`org.gnome.Mutter.RemoteDesktop` on the session bus.** `CreateSession` succeeds for a
  direct (non-sandboxed) caller with no consent dialog. Relative pointer motion, buttons,
  axis and keys work on the session alone. It is real input: it focuses and raises windows
  like a hand on the mouse.
- **Absolute motion needs a ScreenCast stream attached to the session**, and
  `NotifyPointerMotionAbsolute` takes the **`ScreenCast.Stream` object path**
  (`/org/gnome/Mutter/ScreenCast/Stream/uN`), not the `mapping-id`. Its coordinates are
  **stream pixels**, not logical points — verified by moving the pointer and diffing two
  captured frames: the cursor lands at exactly the requested pixel. Creating the cast is
  two more D-Bus calls (`ScreenCast.CreateSession` with `remote-desktop-session-id`, then
  `RecordMonitor`) and nothing needs to read its PipeWire buffers.
- **Start the RemoteDesktop session, not the cast.** With a screen-cast session tied to a
  remote-desktop session, `ScreenCast.Session.Start` answers `Must be started from remote
  desktop session` — start the RemoteDesktop session and both start together.
- **Streams added after `Session.Start` work**: call `Stream.Start` on the new stream and
  it emits `PipeWireStreamAdded` normally.
- **Send input without waiting for the reply** when you are driving a drag.
  `NotifyPointerMotionAbsolute` and friends are handled in GNOME Shell's JS main loop —
  the same loop that is busiest while a window is being dragged — so a blocking round trip
  per pointer move makes the pointer fall behind the hand. D-Bus keeps per-connection
  ordering, so a press still follows the motion that aimed it.
- **Not XTEST.** `XTestFakeMotionEvent`/`XTestFakeButtonEvent` through Xwayland look
  like they work — presses even arrive at the right X11 window — but the compositor
  never sees them: the real cursor does not move, no window takes the focus, and no
  Wayland client notices. Anything that reacts to activation silently does nothing.
  Cost a couple of hours on 2026-09-18; use RemoteDesktop.
- `ydotool`/`wtype` are typically not installed, and `/dev/uinput` is root-only.
- **Focus arrives late.** The window manager moves the focus a few hundred milliseconds
  after the button goes down. An app that reacts to a press through a focus change (a
  tear-off drag, say) needs the button held still that long before the drag moves — a
  `hold_ms=700` before moving is what worked.
- **GTK only resizes a focused window.** An injected press on a window edge does nothing
  unless the window already has focus; with focus, the resize band is roughly 1-16 px
  *outside* the frame rect (inside it does nothing). Focus the target before the press.

### Screen capture

`scripts/linux/screenshot.py` ships in the kit and does the whole dance: Mutter
`DisplayConfig.GetCurrentState` for the connector name, `ScreenCast.CreateSession` →
`Session.RecordMonitor` → `Session.Start`, then `gst-launch-1.0 pipewiresrc path=<node>
num-buffers=15 ! videoconvert ! pngenc snapshot=true ! filesink`. Run it with
`--gui` (it needs the session bus of the logged-on session), point `SHOT_OUT` at the
file you want, and `remote.py <host> pull` it back:

```bash
$R <host> run --gui --timeout 120 my_test.sh   # runs screenshot.py with SHOT_OUT set
$R <host> pull shot.png ./shot.png
```

The easy routes are closed (checked 2026-09-18): `gnome-screenshot` is usually not
installed, and `org.gnome.Shell.Screenshot.Screenshot` answers `AccessDenied: Screenshot
is not allowed` — GNOME 46 only lets its own UI call it. ScreenCast is the only way in.
Traps met on the way:

- `num-buffers=1` is not enough — the first PipeWire buffers can be empty. 15 costs
  nothing and always produced a frame.
- `Gio.DBusConnection.signal_subscribe` calls back with **seven** arguments
  (connection, sender, path, interface, signal, params, user_data). A six-argument
  callback fails with a `TypeError` that is swallowed inside the main loop, so the
  symptom is only "no PipeWireStreamAdded within 10s".
- One capture takes about a second end to end; the session is torn down with
  `Session.Stop` so nothing keeps recording.

Going further than a single screenshot (PipeWire buffers read directly):

- **`RecordWindow` streams are monitor-sized**, not window-sized: the window's area
  arrives as PipeWire `VideoCrop` metadata (request it with a `SPA_PARAM_Meta` pod). That
  crop is the window's *buffer*, which also contains the shadow the app draws; trim it to
  the frame rect, and keep the shadow as **margins**, not an absolute rect — margins
  survive a resize, so a slightly stale window poll still trims correctly.
- **A window capture carries no position.** Mutter draws the window at the top-left of its
  monitor-sized buffer and the `VideoCrop` metadata is always at `(0, 0)`, giving only the
  size — per-frame window origins cannot come from the capture.
- **`SPA_PARAM_Meta` sizes must be a range, not a plain integer.** PipeWire intersects the
  two sides' meta params, and a plain `SPA_PARAM_META_size` integer only matches an
  identical one. Mutter allocates the cursor meta for a 384x384 sprite; asking for any
  other fixed size silently drops the metadata — negotiation succeeds, `update_params`
  reports no error, and `spa_buffer_find_meta_data(SPA_META_Cursor, …)` just returns NULL
  forever. Ask with `SPA_POD_CHOICE_RANGE_Int` (as OBS does). `SPA_META_VideoCrop` only
  worked because both sides happen to use `sizeof (struct spa_meta_region)`.
- **Mutter's cursor metadata**: the id is `1` while the pointer is on the stream and `0`
  when it is not (that is all `spa_meta_cursor_is_valid` tests) — it is *not* a sprite
  serial, so it cannot detect a shape change. The bitmap is attached only on the frames
  where the sprite actually changed; every other frame carries position only. Read a
  picture exactly when `bitmap_offset` is non-zero and de-duplicate on its contents.
- **Virtual monitors** (`RecordVirtual`) exist **only while a PipeWire consumer stays
  attached to the node** — drop the consumer and the monitor vanishes. The resolution is
  whatever the consumer negotiates.
- **Monitor scale is constrained**: `ApplyMonitorsConfig` refuses e.g. scale 2 on a
  1280x800 virtual monitor ("Scale 2 not valid for resolution 1280x800") because the
  logical size would be too small. Treat setting the scale as best-effort and read back
  what Mutter actually did.

### Window geometry and the outside view

- Nothing works out of the box for Wayland windows: `org.gnome.Shell.Eval` returns
  `(false, '')` (unsafe mode off) and `org.gnome.Shell.Introspect.GetWindows` answers
  `AccessDenied`. The options are to run the app under `GDK_BACKEND=x11` and read Xlib
  (`_NET_CLIENT_LIST`, `_NET_FRAME_EXTENTS`, `XTranslateCoordinates`), to assert from
  inside the app itself (a Flutter app through its VM service), or to install a small
  GNOME Shell extension exposing `global.get_window_actors()` over D-Bus.
- **A Wayland client has no root coordinates.** GTK fills `x_root`/`y_root` of an event
  with the *surface-local* point, so code that looks global can be silently
  surface-relative. To find a Wayland window from outside, move the pointer to a known
  screen point and have the app report the surface point under it — the difference is the
  window's origin. That is also the only way to check that a window moved.
- **Stage coordinates are not always logical pixels.** With `layout-mode: 2` (physical),
  the monitor geometry and `get_frame_rect()` are in physical pixels even at scale 2.
  Derive the mapping scale by dividing the monitor's pixel size by the extension's stage
  size instead of trusting the display configuration's scale.
- **Don't poll the Shell for window geometry.** A `ListWindows` round trip measured p50
  1.3 ms but p95 30 ms and max 41 ms, because it has to enter GNOME Shell's JS main loop —
  worst exactly during a drag, when the Shell is busy compositing. Have the extension emit
  a change signal instead, coalesced to one per main loop pass.

### GNOME Shell extensions

- **A running shell will not pick up a newly dropped extension.** `EnableExtension`,
  setting `enabled-extensions`, and `ReloadExtension` (deprecated, returns NotSupported)
  all fail. It loads only after a **log out / log back in**, which cannot be driven over
  SSH without the user's console password — so anything depending on a freshly installed
  extension needs the user to relogin once.
- The same applies to *editing* one: GJS caches the ES module, so `gnome-extensions
  disable` + `enable` re-runs `disable()`/`enable()` on the cached object and does **not**
  pick up a changed `extension.js`. Verify a reload by introspecting for something new on
  its D-Bus object, not by the extension's state, which stays ACTIVE either way.

## Things that end the user's session

- **An out-of-range monitor index passed to `meta_window_move_to_monitor` aborts Mutter**,
  and on Wayland that logs the user out. It is a plain `g_assert` in
  `meta_window_get_work_area_for_logical_monitor`, reached from
  `meta_monitor_manager_get_logical_monitor_from_number`, with no way for an extension to
  catch it. Check the index against `Main.layoutManager.monitors.length` first. This is
  easy to hit by accident: a virtual monitor exists only while a consumer is attached, so
  an index read a moment earlier can already be gone.
- **After two crashes GNOME turns off every user extension**, by setting
  `org.gnome.shell disable-user-extensions` to `true`. The extension then reads as
  `Enabled: No, State: INITIALIZED` and `gnome-extensions enable` appears to do nothing.
  Put it back with `gsettings set org.gnome.shell disable-user-extensions false`.
  One silver lining: an extension that was never enabled in this session has not been
  imported yet, so enabling it after dropping in a new `extension.js` loads the new file
  without a relogin.
- The crash itself is in the journal: `journalctl --user -b | grep -i gnome-shell` shows
  the failed assertion, `GNOME Shell crashed with signal 6`, and a GJS stack trace naming
  the extension file and line that called in.

## Other traps

- **Installing dev packages without root.** SSH hosts often have no usable sudo password.
  `apt-get download <pkg>…` plus `dpkg -x` into `~/prefix` is enough to both build and run
  against a library: point `PKG_CONFIG_PATH` / `PKG_CONFIG_SYSROOT_DIR` (and
  `LIBCLANG_PATH` for bindgen) at it, and at run time
  `LD_LIBRARY_PATH=$HOME/prefix/usr/lib/x86_64-linux-gnu`. Keep those in a small env file
  the build script sources. Watch for headers whose env var wants the directory
  *containing* the package's include dir, not the include dir itself.
- Device access usually needs no group change: `logind` puts an ACL on `/dev/dri/render*`
  for the logged-in user.
- **Flutter's experimental multi-window does not run under Xwayland** (checked 2026-09-18,
  Flutter 3.48.0-1.0.pre-805): the app dies as the second window appears with
  `BadAccess … request_code 149 (GLX) minor_code 26`, in every renderer configuration
  (Impeller, Skia, `LIBGL_ALWAYS_SOFTWARE`, `GDK_GL=egl|gles`, software rendering). A
  single-window Flutter app under `GDK_BACKEND=x11` is fine. Since an app can only be
  *measured* from outside under X11, multi-window Flutter examples currently cannot be
  GUI-tested from outside at all — only launched as Wayland clients and asserted from
  inside.
- **Flutter's windowing feature is baked in at build time.** `isWindowingEnabled` is
  `const String.fromEnvironment('FLUTTER_ENABLED_FEATURE_FLAGS').contains('windowing')`,
  filled from `flutter config --enable-windowing` *when the app is built* (on channels
  that have that setting — `stable` does not, and an app there has to switch the
  windowing API on itself in `main()`). Build without
  it and every window the app asks for silently never appears; the stock runner's own GTK
  window stays up, empty and black, and the only clue in the log is

  ```
  ** (app:NNNN): WARNING **: Timed out waiting for subsurface frame of size 380x200 (have 0x0)
  ```

  That means "Dart never rendered into this view", not "the GPU failed" — chasing it
  through `GDK_BACKEND=x11` and `FLUTTER_ENGINE_SWITCH_1=enable-impeller=false` changes
  only the wording (`OpenGL frame` instead of `subsurface frame`). Check
  `flutter config --list` before the build, and confirm afterwards with

  ```bash
  grep -o 'DART_DEFINES=[^ ]*' build/linux/x64/debug/build.ninja   # base64, ','-separated
  ```

  that `FLUTTER_ENABLED_FEATURE_FLAGS=windowing` is among the defines.
- On an X11 session ("Ubuntu on Xorg") GDM's cookie is `/run/user/<uid>/gdm/Xauthority`;
  `~/.Xauthority` usually does not exist. `xdotool` would be the input driver there.
- Build dependencies seen so far: GTK apps need `libgtk-3-dev`; Flutter needs `clang`,
  `ninja`, `pkg-config`; Rust crates need a toolchain (per-user rustup is fine) plus
  `libclang` for any bindgen step.
