# Windows hosts

Verified on a Windows 11 laptop (VS 2022, PowerShell 5.1, OpenSSH server, Python 3.11);
the Python `hostrun.py` path — `setup`, `exec`, `run`, `--gui`, `pull`, timeouts, a
throwing script, non-ASCII output — re-verified there on 2026-09-19.

## Two places a script can run

**SSH session (plain `exec`, `run`)** is Windows *session 0*: no desktop, no windows, no
input, no screen. Fine for git, file operations, `cmake` configure, `cargo` builds and
tests, reading logs.

**Logged-on desktop (`run --gui`, `exec --gui`)** runs the script hidden inside the user's interactive
session through a one-shot scheduled task: `schtasks /IT` starts `pythonw.exe hostrun.py
job <script>` — `pythonw` because it has no console window to flash on the user's
screen — which runs the script with its output in `job.log` and leaves the exit code in
`job.done`. The task is named after the scratch dir (`ClaudeDesktop_<hash>`), so two
projects driving one machine do not replace each other's task. Use it for:

- anything that creates windows, sends input, or captures the screen;
- **builds that hang in session 0.** A parallel MSBuild (`cmake --build`,
  `flutter build windows`) hung there forever — build those with `--gui`. `cargo`
  builds are fine over plain SSH.

It needs the user to be logged on at the console — check with
`remote.py <host> exec 'Get-Process explorer | Select Id, SessionId'` (a session other
than 0; `query user` is not reachable from the SSH shell). It cannot unlock a locked
screen.

The task runs **unelevated** (`/IT`, no `/RL HIGHEST`). Anything that needs
administrator rights — writing under `HKLM`, driver or display settings, some service
control — will fail silently or with access denied through `--gui`; for those, run an
elevated `schtasks … /it /rl highest` command instead, and keep it in the project's own
notes.

Scripts start with:

```powershell
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\env.ps1"      # $RemoteHost, $RemoteWorkspace, $RemoteScratch, $Python, PATH
```

## Encoding and quoting traps

- The default SSH shell is `cmd` with GBK output. `remote.py` runs everything through
  Python in UTF-8 mode and makes PowerShell answer in UTF-8; do not call
  `ssh host "some command"` raw and trust the text.
- **Console tools still answer in the OEM codepage.** `schtasks`, `tasklist`, `net` and
  friends print GBK on a Chinese Windows whatever Python's UTF-8 mode says: capturing
  them with `text=True` under `-X utf8` dies with `UnicodeDecodeError: … byte 0xb3`
  (the first byte of 成功). Decode with `encoding="oem", errors="replace"`.
- **Non-ASCII in a `.ps1` needs a BOM.** Windows PowerShell 5.1 reads BOM-less scripts
  in the system codepage; a `·` or `…` in a string silently becomes garbage and title
  matches fail. `remote.py` adds the BOM to any non-ASCII `.ps1` it pushes, so this
  only bites files that get there another way (`scp`, git checkout).
- Write result files with `Out-File -Encoding utf8`; `*>` redirection writes UTF-16.
- Avoid inline quoting through ssh → cmd → powershell. If a snippet needs quotes
  beyond single quotes, put it in a file and use `run`.
- The scratch path must not contain spaces (it is passed unquoted to `schtasks /TR`).

## Toolchain traps

- **Symlinked tool proxies fail over SSH.** The rustup proxies in
  `%USERPROFILE%\.cargo\bin` are symlinks and fail with **os error 448** when run from
  an SSH session. Put the real toolchain first in the host's `path_prepend`, as a concrete
  path (`C:\Users\<user>\.rustup\toolchains\stable-x86_64-pc-windows-msvc\bin`) — not
  one going through `%USERPROFILE%`, which the env file stores literally.
- Likewise the `fvm\default` junction does not resolve over SSH — point
  `path_prepend` at a concrete `fvm\versions\<channel>\bin`.
- If a Rust or bindgen step fails on `libclang.dll`, set `$env:LIBCLANG_PATH` to the
  LLVM `bin` directory before building.

## The checkout on a Windows host

- Get changes there with `git pull` in each repo — but **GitHub over HTTPS is flaky
  from some networks**. For unpushed or unreachable commits, fetch between local
  checkouts on the host instead, or `scp` a patch / the changed files.
- **Big clones crawl too** (~60 KiB/s seen; `fvm install <channel>` clones all of
  Flutter). Build the new checkout from one already on the host instead:
  `git clone --no-checkout <existing> <new>`, bring the missing branch over as a
  `git bundle` made locally (`git bundle create b <branch> ^$(git merge-base <branch>
  <have>)`), fetch from the bundle and check out. Binary SDK downloads are fast; it is
  only git over that link that is slow. (If this host's
  checkout is a re-synced mirror rather than a clone, see the SKILL.md section on that
  model.)
- Put build trees in the scratch dir (`-B $RemoteScratch\<name>-build`), not in the
  checkout. Where a build system insists on writing into the checkout (`target\`,
  `build\`), leave those alone and keep your *own* artifacts — logs, frames, probe
  output — in the scratch dir.
- `core.autocrlf` makes `git status` noisy, and `flutter pub get` / package managers
  rewrite generated files. Judge real changes with `git diff --ignore-cr-at-eol --stat`.
- **Leave it as you found it.** Record `git status --short` for every repo you will
  touch (including nested checkouts) *before* you start; at the end `git checkout --`
  only the files you touched and compare. Pre-existing local changes on that machine
  are the user's — do not revert them.

## Building

**Send build output to a file, not down a PowerShell pipeline.** With
`cmake --build … 2>&1 | Select-String …` a `cl.exe` sat at 0 % CPU for twenty minutes
until the job timed out — and outlived it (`taskkill /F /T /PID` to clear it). The same
build through a redirect finished in under a minute:

```powershell
cmd /c "cmake --build `"$build`" --config Debug --target <t> -- /nologo /v:minimal > `"$log`" 2>&1"
Get-Content $log | Select-String " error |vcxproj ->"
```

A cold Rust, CMake or Flutter Windows build takes several minutes; give `--gui` a
generous `--timeout` (900+).
