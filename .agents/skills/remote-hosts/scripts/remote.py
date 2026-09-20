#!/usr/bin/env python3
"""remote.py - run things on another machine (Windows, Linux, macOS) over SSH. See ../SKILL.md.

  remote.py hosts [os]                     list the configured hosts, optionally one OS only
  remote.py <host> setup                   create the scratch dir, write the env files, push the kit
  remote.py <host> push <file>...          copy files into the scratch dir
  remote.py <host> pull <name> <local>     copy a file or directory back from the scratch dir
  remote.py <host> exec [opts] '<snippet>' run a snippet (PowerShell on Windows, bash elsewhere)
  remote.py <host> run [opts] <script> [args...]
                                           push a script (.ps1 / .sh / .py) and run it

exec and run work in the bare SSH session unless told otherwise:
  --gui            run inside the logged-on user's graphical session instead - the only place
                   windows, input and screen capture work - wait for it, print its output
  --timeout <s>    with --gui: how long to wait (default 600)

<host> is a section name in ../hosts.conf (git-ignored; template in ../hosts.example.conf),
or just an OS - windows, linux, macos - when that OS has one host or one marked default.
Set REMOTE_HOSTS_CONF to use a config file elsewhere.
"""
import configparser
import json
import os
import shlex
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
SKILLS = HERE.parent.parent
CONF = Path(os.environ.get("REMOTE_HOSTS_CONF") or HERE.parent / "hosts.conf")
OSES = ("windows", "linux", "macos")
SSH_OPTS = ["-o", "BatchMode=yes", "-o", "ConnectTimeout=10"]
HOSTRUN = "hostrun.py"  # the host-side half, pushed with the kit


def die(msg, code=2):
    print(msg, file=sys.stderr)
    sys.exit(code)


def usage():
    die(__doc__.strip())


# --- hosts.conf ---------------------------------------------------------------
# INI: a [section] per machine, plus an optional [defaults] every host inherits.
# No interpolation and no escapes, so Windows paths keep their backslashes.

def load_conf():
    if not CONF.is_file():
        die("no host config: %s is missing\ncopy %s to it and fill in your machines"
            % (CONF, HERE.parent / "hosts.example.conf"), 1)
    conf = configparser.ConfigParser(
        interpolation=None, default_section="defaults",
        comment_prefixes=("#", ";"), inline_comment_prefixes=("#",))
    try:
        conf.read(CONF, encoding="utf-8")
    except configparser.Error as exc:
        die("%s: %s" % (CONF, exc))
    return conf


def is_default(conf, name):
    return conf[name].get("default", "").lower() in ("yes", "true", "1", "on")


def resolve_host(conf, token):
    """A section name, or an OS with one obvious host."""
    if conf.has_section(token):
        return token
    if token not in OSES:
        die("unknown host '%s'; configured: %s" % (token, " ".join(conf.sections())))
    cands = [s for s in conf.sections() if conf[s].get("os") == token]
    marked = [s for s in cands if is_default(conf, s)]
    if marked:
        return marked[-1]
    if len(cands) == 1:
        return cands[0]
    if not cands:
        die("no %s host configured in %s" % (token, CONF))
    die("several %s hosts (%s); name one, or mark a section 'default = yes'"
        % (token, " ".join(cands)))


def with_bom(path, tmp):
    """Windows PowerShell 5.1 reads a BOM-less .ps1 in the system codepage, so any non-ASCII
    string in it silently turns to garbage. Push such a file with a UTF-8 BOM instead."""
    if path.suffix.lower() != ".ps1":
        return path
    data = path.read_bytes()
    if data.startswith(b"\xef\xbb\xbf") or data.isascii():
        return path
    copy = tmp / path.name
    copy.write_bytes(b"\xef\xbb\xbf" + data)
    return copy


class Host:
    def __init__(self, conf, name):
        sec = conf[name]
        self.name = name
        for key in ("os", "ssh", "workspace", "scratch"):
            if not sec.get(key):
                die("[%s] in %s is missing '%s'" % (name, CONF, key))
        self.os = sec["os"]
        if self.os not in OSES:
            die("[%s] os must be windows, linux or macos" % name)
        self.ssh = sec["ssh"]
        self.workspace = sec["workspace"]
        self.scratch = sec["scratch"]
        for path in (self.workspace, self.scratch):
            if "~" in path:
                die("[%s] workspace/scratch must be absolute paths, not ~ "
                    "(they are written into env files verbatim)" % name)
            if any(c in path for c in " '\""):
                die("[%s] workspace/scratch must not contain spaces or quotes" % name)
        self.windows = self.os == "windows"
        self.python = sec.get("python") or ("python" if self.windows else "python3")
        self.path_prepend = sec.get("path_prepend", "")
        self.display = sec.get("display") or ":0"
        self.sep = "\\" if self.windows else "/"

    def quote(self, args):
        """One command line for the host's login shell: cmd on Windows, sh elsewhere."""
        if self.windows:
            return subprocess.list2cmdline(args)
        return " ".join(shlex.quote(a) for a in args)

    def remote(self, args):
        return subprocess.call(["ssh"] + SSH_OPTS + [self.ssh, self.quote(args)])

    def scp_dir(self):
        return "%s:%s" % (self.ssh, self.scratch.replace("\\", "/"))

    def push(self, files):
        with tempfile.TemporaryDirectory() as tmp:
            files = [with_bom(Path(f), Path(tmp)) for f in files]
            cmd = ["scp", "-q"] + SSH_OPTS + [str(f) for f in files] + [self.scp_dir() + "/"]
            if subprocess.call(cmd) != 0:
                die("push to %s failed" % self.name, 1)

    def hostrun(self, *args):
        """Everything that runs on the host goes through its half of this tool."""
        return self.remote([self.python, "-X", "utf8", self.scratch + self.sep + HOSTRUN] + list(args))


# The kit: what every skill ships for this OS, by convention
#   <skill>/scripts/<os>/*   (and scripts/posix/* for Linux and macOS)   OS-specific helpers
#   <skill>/scripts/*.py                                                 portable tools
# It all lands flat in the scratch dir, so scripts find each other next to themselves.
def kit_files(host):
    dirs = [host.os] if host.windows else [host.os, "posix"]
    files = []
    for d in dirs:
        files += [f for f in sorted(SKILLS.glob("*/scripts/%s/*" % d)) if f.is_file()]
    files += [f for f in sorted(SKILLS.glob("*/scripts/*.py")) if f != Path(__file__).resolve()]
    return files


def setup(host):
    # Also proves there is a Python on the host, which everything else relies on.
    mkdir = "import os; os.makedirs(r'%s', exist_ok=True)" % host.scratch
    if host.remote([host.python, "-c", mkdir]) != 0:
        die("cannot create %s on %s - is '%s' a Python 3 there?"
            % (host.scratch, host.name, host.python), 1)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        env = {"host": host.name, "os": host.os, "workspace": host.workspace,
               "python": host.python, "path_prepend": host.path_prepend, "display": host.display}
        (tmp / "env.json").write_text(json.dumps(env, indent=2), encoding="utf-8")
        if host.windows:
            # For .ps1 scripts: . "$PSScriptRoot\env.ps1"
            lines = ["# Generated by remote.py setup for host '%s'." % host.name,
                     "$RemoteHost = '%s'" % host.name,
                     "$RemoteWorkspace = '%s'" % host.workspace,
                     "$RemoteScratch = $PSScriptRoot",
                     "$Python = '%s'" % host.python]
            if host.path_prepend:
                lines.append("$env:Path = '%s;' + $env:Path" % host.path_prepend)
            envfile = tmp / "env.ps1"
            envfile.write_text("\r\n".join(lines) + "\r\n", encoding="ascii")
        else:
            # For .sh scripts: . "$(dirname "$0")/env.sh"
            lines = ["# Generated by remote.py setup for host '%s'." % host.name,
                     "export REMOTE_HOST='%s'" % host.name,
                     "export REMOTE_WORKSPACE='%s'" % host.workspace,
                     "export REMOTE_SCRATCH='%s'" % host.scratch,
                     "export PYTHON='%s'" % host.python,
                     "export REMOTE_DISPLAY='%s'" % host.display]
            if host.path_prepend:
                lines.append("export PATH='%s':\"$PATH\"" % host.path_prepend)
            envfile = tmp / "env.sh"
            envfile.write_text("\n".join(lines) + "\n", encoding="utf-8")
        kit = kit_files(host)
        host.push([tmp / "env.json", envfile] + kit)
    print("kit pushed to %s:%s (%d files)" % (host.name, host.scratch, len(kit)))


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        usage()
    conf = load_conf()

    if argv[0] == "hosts":
        want = argv[1] if len(argv) > 1 else None
        rows = [s for s in conf.sections() if not want or conf[s].get("os") == want]
        if not rows:
            die("no hosts%s in %s" % (" with os = " + want if want else "", CONF), 1)
        for s in rows:
            os_ = conf[s].get("os", "?")
            mark = " (default for %s)" % os_ if is_default(conf, s) else ""
            print("%-14s %-8s %s%s" % (s, os_, conf[s].get("ssh", "?"), mark))
        return 0

    if len(argv) < 2:
        usage()
    host = Host(conf, resolve_host(conf, argv[0]))
    verb, rest = argv[1], argv[2:]

    if verb == "setup":
        setup(host)
        return 0
    if verb == "push" and rest:
        host.push(rest)
        return 0
    if verb == "pull" and len(rest) == 2:
        return subprocess.call(["scp", "-q", "-r"] + SSH_OPTS + [host.scp_dir() + "/" + rest[0], rest[1]])
    gui, timeout = False, "600"
    if verb in ("exec", "run"):  # options come before the script; the rest is the script's
        while rest and rest[0].startswith("--"):
            opt = rest.pop(0)
            if opt == "--gui":
                gui = True
            elif opt == "--timeout" and rest:
                timeout = rest.pop(0)
            else:
                usage()
    where = ["gui", timeout] if gui else ["run"]
    if verb == "exec" and len(rest) == 1:
        with tempfile.TemporaryDirectory() as tmp:
            if host.windows:
                snippet = Path(tmp) / "snippet.ps1"
                snippet.write_text('. "$PSScriptRoot\\env.ps1"\r\n' + rest[0] + "\r\n", encoding="utf-8-sig")
            else:
                snippet = Path(tmp) / "snippet.sh"
                snippet.write_text('. "$(dirname "$0")/env.sh"\n' + rest[0] + "\n", encoding="utf-8")
            host.push([snippet])
        return host.hostrun(*where, snippet.name)
    if verb == "run" and rest:
        host.push([rest[0]])
        return host.hostrun(*where, Path(rest[0]).name, *rest[1:])
    usage()


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
