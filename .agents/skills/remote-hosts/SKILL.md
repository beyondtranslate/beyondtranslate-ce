---
name: remote-hosts
description: Build, run, and GUI-test on another machine over SSH — a Windows laptop, a Linux box, another Mac — with one symmetric CLI for every OS. Push scripts, run them either in the bare SSH session or, with --gui, inside the real logged-on graphical session (needed for anything with windows, input, screen capture, and on Windows even for some builds), and pull results back. Use this whenever a task says "test on Windows/Linux/the other Mac", "does it work on <platform>", "build it there", "record on Windows", or needs to verify a platform-specific change on real hardware, even if the user only mentions the other machine in passing. It knows the traps per OS (Windows session 0, GBK output and PowerShell 5.1 encodings; X11 vs Wayland and Mutter's D-Bus APIs; macOS TCC) and how to leave the remote checkout clean.
---

# remote-hosts

Every remote machine is a **host**: a name, an OS, an SSH target, and a few paths. They
all live in one file, `hosts.conf` — one `[section]` per physical machine, git-ignored
(keep real addresses out of commits), with a filled-in template in `hosts.example.conf`.
Everything goes through one script with the same verbs on every OS:

```bash
R=<skills-root>/remote-hosts/scripts/remote.py
$R hosts [os]                              # what is configured: name, os, ssh target
$R <host> setup                            # once per session: scratch dir, env file, helper kit
$R <host> exec '<snippet>'                 # quick command (PowerShell / bash)
$R <host> push <file>…                     # copy extra files into the scratch dir
$R <host> run my_script.ps1|.sh|.py [args] # push + run a script
$R <host> run --gui --timeout 400 my_gui_test.py [args]
                                           # same, but inside the logged-on graphical session
$R <host> pull frames ./frames             # copy results back from the scratch dir
```

If the host the user means is not configured, ask for its SSH target and paths and add a
section to `hosts.conf` from the template; key-based SSH login must already work
(`ssh -o BatchMode=yes <target> echo ok`).

The tool is Python on both ends and nothing else: `scripts/remote.py` here, and
`scripts/hostrun.py`, which `setup` pushes and every verb runs through on the host. So
**each host needs a Python 3** (the `python` key) — that is the only requirement beyond
SSH. Your own test scripts can still be `.ps1`, `.sh` or `.py`; the extension picks the
interpreter.

## Several machines, one platform

`<host>` is either a section name or just an **OS** — `windows`, `linux`, `macos` —
which resolves to that OS's only host, or to the one marked `default = yes`:

```bash
$R hosts windows          # every Windows machine configured
$R windows setup          # the default Windows box
$R win-arm setup          # that specific machine
```

So a task phrased "test it on Windows" can start with `$R windows …` and needs no
lookup. When an OS has several hosts and none is the default, the script refuses and
lists them rather than guessing — pick one, and **say in your report which machine ran
what** (`$RemoteHost` / `$REMOTE_HOST` in the env file names it). Hardware differs: an
Arm laptop and an x64 desktop disagree about toolchains, GPUs and timing, so a green run
on one is not a green run on the other.

Give each machine its own `scratch` — two hosts may share a home directory over a
network mount, and the scratch dir is flat.

## The model (same on every OS)

- **Scratch directory** on the host: everything you push lands there, flat. Put build
  trees and results there too — never in the host's checkout. **One scratch dir per
  project** (`~/tmp/claude-<project>`): it is flat and shared by whoever points at it,
  so two repos aiming at the same path overwrite each other's `env.sh` and a build
  silently runs with the *other* project's workspace and `PATH`. If a script suddenly
  cannot find its workspace or its toolchain, `cat $REMOTE_SCRATCH/env.sh` first.
- **Environment**, written by `setup` and the same in every language: each script
  starts with `REMOTE_HOST`, `REMOTE_WORKSPACE`, `REMOTE_SCRATCH`, `PYTHON` (and
  `REMOTE_DISPLAY`) set and the host's `path_prepend` on `PATH` — a `.py` reads
  `os.environ`, a `.sh` just uses them. For PowerShell there is also `env.ps1` to
  dot-source (`$RemoteHost`, `$RemoteWorkspace`, `$RemoteScratch`, `$Python`), and
  `env.sh` for shell scripts written before the variables were exported. It is written
  per host, so re-run `setup` after switching machines — and read `REMOTE_HOST` when a
  result file needs to say where it came from.
- **Kit**, pushed by `setup` by convention, so skills stay symmetric without a list to
  maintain: from **every skill in the same skills root**, `scripts/<os>/*` (plus
  `scripts/posix/*` on Linux and macOS) and every portable `scripts/*.py` — prefer the
  last: one Python helper serves every OS, which is how `hostrun.py` itself ships. A new
  OS-specific helper dropped into `<skill>/scripts/<os>/` is picked up automatically.
  Re-run `setup` after editing kit files. `run` pushes only the one script you
  name, so keep test scripts self-contained apart from the kit (or `push` extra files
  first).
- **Two places a script can run**, and `--gui` is the switch between them. Plain
  `run`/`exec` work in the *SSH session*, which has no desktop on any OS: use it for git,
  files, logs, and (with the Windows caveat below) builds. `run --gui` / `exec --gui`
  put the same script into the *logged-on user's graphical session*, the only place
  windows, input and screen capture work (Windows: one-shot scheduled task; Linux: the
  graphical session's environment; macOS: `launchctl asuser`). It captures everything
  the script prints, waits up to `--timeout` seconds (default 600), and ends with
  `[gui] finished after Ns, exit C`. `exec --gui '<one-liner>'` is the quick check that
  the session is reachable at all. It needs the user logged on at the console
  and cannot unlock a screen. Output goes through one shared `job.log` in the scratch
  dir, so two sessions driving the same host at once read each other's output — check
  `ls -lt` in the scratch dir for fresh files before assuming a host is yours alone. On
  `TIMEOUT` the job may still be running — check before starting another, since both
  would fight over the mouse. For long jobs write progress to a file in the scratch dir
  and poll it with `exec`.

Then read the notes for the host's OS — this is where the hours go:

| OS | Notes | Status |
| --- | --- | --- |
| Windows | [references/windows.md](references/windows.md) — session 0, encodings, scheduled-task limits, CRLF | verified, used for real build, test and recording runs |
| Linux | [references/linux.md](references/linux.md) — X11 vs Wayland, XAUTHORITY, Mutter RemoteDesktop/ScreenCast | verified on GNOME 46 Wayland: build, launch, synthetic input, screenshot |
| macOS | [references/macos.md](references/macos.md) — TCC for SSH-launched input/capture | designed, not yet run against a remote Mac |

When you bring up a host on a new OS or desktop for the first time, expect to fix
things, and write what you learn into its reference file.

## The host's checkout

Two models are in use; know which one this host is before you touch it.

- **A normal clone.** Get changes there with `git pull` in each repo; for unpushed
  commits or an unreliable network (GitHub over HTTPS is flaky from some networks),
  fetch between checkouts on the host, or `scp` a patch / the changed files.
  **Leave it as you found it**: record `git status --short` of every repo you will
  touch *before* you start; at the end `git checkout --` only the files you changed and
  compare. Pre-existing local changes on that machine are the user's — do not revert
  them.
- **A mirror of the local working tree**, wiped and re-synced by a project script on
  every run. Then *nothing you leave in that directory survives*: keep logs, captures
  and probe output in the scratch dir, point the host's `workspace` at the same path the sync
  script uses, and put the build tree beside the source (not inside it) so a re-sync
  keeps incremental compilation. "Leave it as you found it" here means: never edit
  files there to fix something — fix them locally and re-sync.

## Project-specific notes

This skill is the shared, project-neutral core: the CLI, the per-OS host traps, and the
kit. Build recipes, toolchain quirks and app-specific findings belong to the project,
not here. When a project vendors this skill, keep those in the project (an
`AGENTS.md`/`CLAUDE.md` section, or a `references/<project>.md` added alongside these
files) and leave the shared references untouched, so this skill can be updated from
upstream without re-applying edits.

Anything you learn that would be true on *any* project using that host — an OS trap, a
desktop-session limitation, a D-Bus or TCC behaviour — belongs upstream here instead.

## After the work

Fix what the test found in the local checkout, copy the changed files over to re-test,
and only then commit locally. Clean up big artifacts in the scratch dir (`frames/`,
build trees) when the user is done with them — ask before deleting builds that take
minutes to recreate. Report per host what actually ran there.
