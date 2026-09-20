#!/usr/bin/env python3
"""Screenshot the GNOME/Wayland desktop through Mutter ScreenCast + PipeWire.

GNOME 46 refuses org.gnome.Shell.Screenshot to outside callers and
gnome-screenshot is not installed, so ScreenCast is the only way in.
Run me from the logged-on desktop session (remote.py <host> run --gui).
"""
import os
import subprocess
import sys

import gi

gi.require_version("Gio", "2.0")
from gi.repository import Gio, GLib  # noqa: E402

OUT = os.environ.get("SHOT_OUT") or os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "shot.png"
)

bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)


def call(name, path, iface, method, params=None, sig=None):
    return bus.call_sync(
        name, path, iface, method, params, sig, Gio.DBusCallFlags.NONE, 10000, None
    )


def connectors():
    state = call(
        "org.gnome.Mutter.DisplayConfig",
        "/org/gnome/Mutter/DisplayConfig",
        "org.gnome.Mutter.DisplayConfig",
        "GetCurrentState",
    )
    # (serial, monitors, logical_monitors, properties)
    return [m[0][0] for m in state[1]]


names = connectors()
print(f"[shot] monitors: {names}")
if not names:
    sys.exit("[shot] no monitors reported by Mutter")
connector = names[0]

session_path = call(
    "org.gnome.Mutter.ScreenCast",
    "/org/gnome/Mutter/ScreenCast",
    "org.gnome.Mutter.ScreenCast",
    "CreateSession",
    GLib.Variant("(a{sv})", ({},)),
)[0]
print(f"[shot] session {session_path}")

stream_path = call(
    "org.gnome.Mutter.ScreenCast",
    session_path,
    "org.gnome.Mutter.ScreenCast.Session",
    "RecordMonitor",
    GLib.Variant("(sa{sv})", (connector, {"cursor-mode": GLib.Variant("u", 1)})),
)[0]
print(f"[shot] stream {stream_path}")

loop = GLib.MainLoop()
node = {}


def on_signal(_conn, _sender, _path, _iface, signal, params, _user_data=None):
    if signal == "PipeWireStreamAdded":
        node["id"] = params[0]
        loop.quit()


bus.signal_subscribe(
    None,
    "org.gnome.Mutter.ScreenCast.Stream",
    "PipeWireStreamAdded",
    stream_path,
    None,
    Gio.DBusSignalFlags.NONE,
    on_signal,
    None,
)

call(
    "org.gnome.Mutter.ScreenCast",
    session_path,
    "org.gnome.Mutter.ScreenCast.Session",
    "Start",
)
GLib.timeout_add_seconds(10, loop.quit)
loop.run()

if "id" not in node:
    sys.exit("[shot] no PipeWireStreamAdded within 10s")
print(f"[shot] pipewire node {node['id']}")

pipeline = [
    "gst-launch-1.0",
    "-q",
    "pipewiresrc",
    f"path={node['id']}",
    "num-buffers=15",
    "!",
    "videoconvert",
    "!",
    "pngenc",
    "snapshot=true",
    "!",
    "filesink",
    f"location={OUT}",
]
print("[shot] " + " ".join(pipeline))
rc = subprocess.run(pipeline, capture_output=True, text=True, timeout=60)
sys.stdout.write(rc.stdout)
sys.stderr.write(rc.stderr)

try:
    call(
        "org.gnome.Mutter.ScreenCast",
        session_path,
        "org.gnome.Mutter.ScreenCast.Session",
        "Stop",
    )
except Exception as exc:  # noqa: BLE001
    print(f"[shot] Stop failed: {exc}")

if os.path.exists(OUT):
    print(f"[shot] wrote {OUT} ({os.path.getsize(OUT)} bytes)")
else:
    sys.exit(f"[shot] gst wrote nothing (rc={rc.returncode})")
