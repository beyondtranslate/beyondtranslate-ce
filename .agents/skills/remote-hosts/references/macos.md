# macOS hosts

**Status: designed, not yet run against a remote Mac.** `hostrun.py gui` (including
`launchctl asuser`) was exercised on the local Mac only. Verify each step the first
time and update this file.

For the Mac you are already on, do not use this skill: run things directly.

## Two places a script can run

**SSH session (plain `exec`, `run`)**: needs Remote Login enabled (System Settings ›
General › Sharing). Runs outside the user's Aqua session: no window server access
for many APIs. Fine for git, builds, logs.

**Logged-on desktop (`run --gui`, `exec --gui`)**: `hostrun.py` starts the script with
`launchctl asuser <uid>`, which places it in the logged-on user's GUI bootstrap
namespace so apps it launches appear on screen. The same user must be logged on.

Scripts find `REMOTE_HOST`, `REMOTE_WORKSPACE`, `REMOTE_SCRATCH`, `PYTHON` and the PATH
additions already in their environment.

## Expected traps

- **TCC permissions follow the responsible process.** Synthetic input (Accessibility)
  and `screencapture` (Screen Recording) are granted per app; for an SSH-launched
  chain the responsible process is `sshd-keygen-wrapper` (`/usr/libexec/`), which has
  to be added in System Settings › Privacy & Security on that Mac by its user. Without
  it, input calls succeed silently and nothing moves; `screencapture` exits at once.
- Anything needing a graphical session *and* an Accessibility grant should be driven
  with `--gui` rather than in the bare SSH session — an SSH-launched binary inherits the SSH
  chain's (missing) grants.
- The keychain is locked in SSH sessions: code signing (`flutter build macos`, any
  signed build) may prompt or fail; build with the user logged on, or
  `security unlock-keychain`.
- A synthetic-input driver that compiles a small Objective-C helper on first use needs
  the Xcode command line tools installed on the host.
