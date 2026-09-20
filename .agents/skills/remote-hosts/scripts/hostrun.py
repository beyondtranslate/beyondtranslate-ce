#!/usr/bin/env python3
"""hostrun.py - the half of remote.py that runs on the host. Pushed by `setup`; lives in the
scratch dir next to the scripts it runs and the env.json that `setup` wrote.

  hostrun.py run <script> [args...]             run a script in this (SSH) session
  hostrun.py gui <timeout> <script> [args...]   run it inside the logged-on user's graphical
                                                session instead, capture what it prints in
                                                job.log, wait, report
  hostrun.py job                                internal: the graphical-session side on Windows

Scripts are .py, .sh or .ps1. Every one of them gets REMOTE_HOST, REMOTE_WORKSPACE,
REMOTE_SCRATCH, PYTHON (and REMOTE_DISPLAY) in its environment and the host's path_prepend on
PATH, whatever the language.

The graphical session is reached differently per OS:
  windows  a one-shot scheduled task (/IT) running pythonw.exe, which has no console window
  linux    the environment of the user's graphical session (Wayland socket, X display, cookie)
  macos    the user's Aqua session, through `launchctl asuser`
"""
import hashlib
import json
import os
import re
import subprocess
import sys
import time
import traceback

HERE = os.path.dirname(os.path.abspath(__file__))
WINDOWS = os.name == "nt"
LOG = os.path.join(HERE, "job.log")
DONE = os.path.join(HERE, "job.done")
JOB = os.path.join(HERE, "job.json")


def load_env():
    with open(os.path.join(HERE, "env.json"), encoding="utf-8") as f:
        conf = json.load(f)
    env = os.environ
    env["REMOTE_HOST"] = conf["host"]
    env["REMOTE_WORKSPACE"] = conf["workspace"]
    env["REMOTE_SCRATCH"] = HERE
    env["PYTHON"] = sys.executable
    if conf.get("path_prepend"):
        env["PATH"] = conf["path_prepend"] + os.pathsep + env.get("PATH", "")
    if not WINDOWS:
        env["REMOTE_DISPLAY"] = conf.get("display") or ":0"
    return conf


def command_for(script, args):
    """The interpreter comes from the extension."""
    path = os.path.join(HERE, script)
    if not os.path.isfile(path):
        sys.exit("hostrun: %s is not in %s" % (script, HERE))
    ext = os.path.splitext(script)[1].lower()
    if ext == ".py":
        python = sys.executable
        if WINDOWS and python.lower().endswith("pythonw.exe"):  # children want a real stdout
            python = python[:-len("pythonw.exe")] + "python.exe"
        return [python, "-X", "utf8", path] + args
    if ext == ".ps1" and WINDOWS:
        # Windows PowerShell answers in the OEM codepage (GBK, ...) unless told otherwise.
        inner = "[Console]::OutputEncoding=[Text.Encoding]::UTF8; & '%s' %s; exit $LASTEXITCODE" % (
            path, " ".join(args))
        return ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", inner]
    if ext == ".sh" and not WINDOWS:
        return ["bash", path] + args
    sys.exit("hostrun: cannot run %s here (%s)" % (script, ".ps1 or .py" if WINDOWS else ".sh or .py"))


def run(script, args):
    return subprocess.call(command_for(script, args), cwd=HERE)


# --- graphical session --------------------------------------------------------

def linux_session_env():
    """The desktop session imports its environment into the systemd user manager (GNOME,
    KDE and most others do): take the Wayland socket, X display and cookie from there."""
    env = os.environ
    wanted = ("DISPLAY", "XAUTHORITY", "WAYLAND_DISPLAY", "XDG_SESSION_TYPE",
              "XDG_CURRENT_DESKTOP", "XDG_RUNTIME_DIR", "DBUS_SESSION_BUS_ADDRESS")
    try:
        out = subprocess.run(["systemctl", "--user", "show-environment"], stdout=subprocess.PIPE,
                             stderr=subprocess.DEVNULL, universal_newlines=True).stdout
    except OSError:
        out = ""
    for line in out.splitlines():
        key, _, value = line.partition("=")
        if key in wanted:
            env[key] = value
    uid = os.getuid()
    env.setdefault("DISPLAY", env.get("REMOTE_DISPLAY", ":0"))
    env.setdefault("XDG_RUNTIME_DIR", "/run/user/%d" % uid)
    env.setdefault("DBUS_SESSION_BUS_ADDRESS", "unix:path=%s/bus" % env["XDG_RUNTIME_DIR"])
    if not env.get("XAUTHORITY"):
        # The cookie is wherever the display manager put it (GDM Xorg: /run/user/<uid>/gdm/
        # Xauthority, GNOME Wayland's Xwayland: /run/user/<uid>/.mutter-Xwaylandauth.*):
        # read it off the X server's command line.
        auth = None
        try:
            ps = subprocess.run(["pgrep", "-a", "-u", str(uid), "-f", "X(org|wayland)"],
                                stdout=subprocess.PIPE, universal_newlines=True).stdout
        except OSError:
            ps = ""
        for line in ps.splitlines():
            if re.search(r"X(org|wayland) %s( |$)" % re.escape(env["DISPLAY"]), line):
                m = re.search(r" -auth (\S+)", line)
                if m:
                    auth = m.group(1)
                    break
        if not auth and os.path.isfile(os.path.expanduser("~/.Xauthority")):
            auth = os.path.expanduser("~/.Xauthority")
        if auth:
            env["XAUTHORITY"] = auth


def finish(start, code):
    with open(LOG, "rb") as f:
        sys.stdout.buffer.write(f.read())
    sys.stdout.buffer.flush()
    print("[gui] finished after %ds, exit %s" % (time.time() - start, code), flush=True)
    return code


def timed_out(timeout, what):
    if os.path.exists(LOG):
        with open(LOG, "rb") as f:
            sys.stdout.buffer.write(f.read())
        sys.stdout.buffer.flush()
    print("[gui] TIMEOUT after %ds - %s may still be running" % (timeout, what), flush=True)
    return 1


def gui_posix(conf, script, args, timeout):
    cmd = command_for(script, args)
    if conf["os"] == "linux":
        linux_session_env()
    elif conf["os"] == "macos":
        cmd = ["launchctl", "asuser", str(os.getuid())] + cmd
    start = time.time()
    with open(LOG, "wb") as log:
        proc = subprocess.Popen(cmd, cwd=HERE, stdin=subprocess.DEVNULL, stdout=log,
                                stderr=subprocess.STDOUT, start_new_session=True)
    while proc.poll() is None:
        if time.time() - start >= timeout:
            return timed_out(timeout, "the job (pid %d)" % proc.pid)
        time.sleep(1)
    return finish(start, proc.returncode)


def gui_windows(script, args, timeout):
    """An SSH session is session 0 and has no desktop. A scheduled task with /IT runs in the
    logged-on user's session; pythonw.exe keeps it from flashing a console window there."""
    command_for(script, args)  # fail here, not silently inside the task
    with open(JOB, "w", encoding="utf-8") as f:  # /TR is short and hard to quote: pass it in a file
        json.dump({"script": script, "args": args}, f)
    # One task per scratch dir, so two projects driving this machine do not replace each other's.
    task = "ClaudeDesktop_" + hashlib.md5(HERE.lower().encode()).hexdigest()[:8]
    pythonw = os.path.join(os.path.dirname(sys.executable), "pythonw.exe")
    if not os.path.isfile(pythonw):
        print("[gui] no pythonw.exe next to %s - a console window will show" % sys.executable)
        pythonw = sys.executable
    # No quoting inside /TR: the scratch path has no spaces (remote.py refuses one that does).
    action = "%s %s job" % (pythonw, os.path.abspath(__file__))
    user = os.environ.get("USERNAME") or os.getlogin()
    # schtasks answers in the OEM codepage (GBK on a Chinese Windows), whatever -X utf8 says.
    quiet = dict(stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding="oem", errors="replace")
    start = time.time()
    try:
        made = subprocess.run(["schtasks", "/Create", "/TN", task, "/TR", action, "/SC", "ONCE",
                               "/ST", "23:59", "/RU", user, "/IT", "/F"], **quiet)
        if made.returncode != 0:
            print(made.stdout)
            return made.returncode
        subprocess.run(["schtasks", "/Run", "/TN", task], **quiet)
        while not os.path.exists(DONE):
            if time.time() - start >= timeout:
                return timed_out(timeout, "the job")
            time.sleep(1)
    finally:
        subprocess.run(["schtasks", "/Delete", "/TN", task, "/F"], **quiet)
    with open(DONE) as f:
        return finish(start, int(f.read().strip() or 1))


def job():
    """Runs under pythonw.exe in the graphical session: no stdout here, everything goes to job.log."""
    code = 1
    with open(LOG, "wb") as log:
        try:
            with open(JOB, encoding="utf-8") as f:
                spec = json.load(f)
            code = subprocess.call(command_for(spec["script"], spec["args"]), cwd=HERE, stdin=subprocess.DEVNULL,
                                   stdout=log, stderr=subprocess.STDOUT,
                                   creationflags=0x08000000)  # CREATE_NO_WINDOW
        except BaseException:
            log.write(traceback.format_exc().encode("utf-8"))
        finally:
            with open(DONE, "w") as f:
                f.write(str(code))
    return code


def main(argv):
    verb = argv[0] if argv else ""
    conf = load_env()
    if verb == "job":
        return job()
    if verb == "run" and len(argv) >= 2:
        return run(argv[1], argv[2:])
    if verb != "gui" or len(argv) < 3:
        sys.exit(__doc__.strip())
    timeout, script, args = int(argv[1]), argv[2], argv[3:]
    for stale in (LOG, DONE):
        if os.path.exists(stale):
            os.remove(stale)
    if WINDOWS:
        return gui_windows(script, args, timeout)
    return gui_posix(conf, script, args, timeout)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
