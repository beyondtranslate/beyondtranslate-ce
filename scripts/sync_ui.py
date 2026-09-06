#!/usr/bin/env python3
"""Vendor the upstream Fastforge UI Flutter package into this repository.

The Flutter design system is not maintained here: it is a copy of
<https://github.com/fastforgedev/ui>, taken verbatim and renamed into
BeyondTranslate's namespace. This script is the only supported way to update
it — hand edits are drift, and `--check` exists to catch them.

    upstream packages/ui_flutter -> packages/ui_flutter  (beyondtranslate_ui)

Usage:
    python3 scripts/sync_ui.py                  # sync to upstream main
    python3 scripts/sync_ui.py --ref v1.2.0     # sync to a branch, tag, or SHA
    python3 scripts/sync_ui.py --locked         # re-sync to the locked commit
    python3 scripts/sync_ui.py --check          # report drift, write nothing
    python3 scripts/sync_ui.py --check --ref main   # has upstream moved?
    python3 scripts/sync_ui.py --diff           # show the drift as a diff

The commit that produced the current tree is recorded in
`scripts/sync_ui.lock.json`. `--check` and `--diff` default to that commit, so
they answer "has anyone edited the vendored code?"; pass `--ref main` to ask
the other question, "has upstream moved on?".
"""

from __future__ import annotations

import argparse
import difflib
import hashlib
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOCK_FILE = ROOT / "scripts/sync_ui.lock.json"

UPSTREAM_HOMEPAGE = "https://github.com/fastforgedev/ui"
# SSH first: this repository's own remote is SSH, and the HTTPS endpoint fails
# behind some of the proxies developers here run. Either URL reaches the same
# repository, so falling through costs nothing.
UPSTREAM_URLS = (
    "git@github.com:fastforgedev/ui.git",
    "https://github.com/fastforgedev/ui.git",
)
DEFAULT_REF = "main"

CACHE_DIR = (
    Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache")
    / "beyondtranslate"
    / "upstream-ui"
)


@dataclass(frozen=True)
class Target:
    """One upstream package directory and where it lands in this repository.

    `exclude` holds paths relative to the upstream directory — a trailing
    slash drops a subtree, anything else drops the one file.
    """

    upstream: str
    local: str
    exclude: tuple[str, ...] = ()


TARGETS = (
    Target(
        upstream="packages/ui_flutter",
        local="packages/ui_flutter",
        # Upstream's storybook is a standalone Flutter app with its own Xcode
        # project and bundle identifier. Nothing here builds against it, so it
        # is not vendored — read it upstream.
        exclude=("example/",),
    ),
)

# The code stays upstream's, byte for byte; only its identity is rewritten —
# the pub package name and the product name in prose. Applied in order to both
# file contents and relative paths, which is what moves `lib/fastforge_ui.dart`
# to `lib/beyondtranslate_ui.dart` without a special case.
#
# Anything added here is divergence from upstream that has to be re-applied on
# every sync, so keep the list to names that must change for the code to build
# and read correctly under BeyondTranslate.
RENAMES: tuple[tuple[str, str], ...] = (
    ("fastforge_ui", "beyondtranslate_ui"),
    ("Fastforge UI", "BeyondTranslate UI"),
)

# The one deliberate addition to upstream's manifest. Upstream's package stands
# alone; here it is a member of the repository's Pub Workspace, which every
# member has to declare for `dart pub get` to resolve it from the root.
PUBSPEC_OVERRIDES: dict[str, str] = {"resolution": "workspace"}

# Inserted after this key when absent, so the manifest keeps reading in the
# conventional order rather than growing a stray key at the end.
PUBSPEC_ANCHOR = "version"

Tree = dict[str, bytes]


class SyncError(Exception):
    """A failure worth reporting as a message rather than a traceback."""


def main() -> int:
    args = parse_args()
    lock = read_lock()
    read_only = args.check or args.diff

    ref = resolve_ref(args, lock, read_only=read_only)
    urls = [args.repo] if args.repo else list(UPSTREAM_URLS)

    try:
        commit = fetch(urls, ref)
    except SyncError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1

    print(f"==> upstream {UPSTREAM_HOMEPAGE} @ {ref} ({commit[:12]})", flush=True)

    try:
        staged = {target.local: stage(commit, target) for target in TARGETS}
    except SyncError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1

    if read_only:
        return report(staged, show_diff=args.diff)

    dirty = [target for target in TARGETS if has_local_work(target, lock)]
    if dirty and not args.force:
        print(
            "error: uncommitted changes under "
            + ", ".join(target.local for target in dirty)
            + "\n       commit or stash them first, or re-run with --force to discard them",
            file=sys.stderr,
        )
        return 1

    for target in TARGETS:
        install(target, staged[target.local])

    # A `--locked` re-sync asked for a raw SHA, but the tree still came from
    # whatever branch or tag the lock already names — keep that provenance.
    recorded_ref = lock.get("ref", ref) if args.locked and not args.ref else ref
    write_lock(recorded_ref, commit, staged)
    print_next_steps()
    return 0


# --------------------------------------------------------------------------
# Upstream access
# --------------------------------------------------------------------------


def fetch(urls: list[str], ref: str) -> str:
    """Fetch `ref` into the local cache and return the commit it resolves to."""
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    if not (CACHE_DIR / "HEAD").exists():
        git(["init", "--quiet", "--bare"], cwd=CACHE_DIR)

    failures: list[str] = []
    for url in urls:
        git(["remote", "remove", "origin"], cwd=CACHE_DIR, check=False)
        git(["remote", "add", "origin", url], cwd=CACHE_DIR)
        # Depth 1 keeps the cache small; GitHub serves a bare SHA this way, so
        # the same call handles a branch, a tag, and a pinned commit.
        result = git(
            ["fetch", "--quiet", "--depth", "1", "origin", ref],
            cwd=CACHE_DIR,
            check=False,
        )
        if result.returncode == 0:
            return git(["rev-parse", "FETCH_HEAD"], cwd=CACHE_DIR).stdout.strip()

        reason = result.stderr.strip().splitlines()
        failures.append(f"  {url}: {reason[-1] if reason else 'failed'}")

    raise SyncError(f"could not fetch '{ref}' from upstream\n" + "\n".join(failures))


def stage(commit: str, target: Target) -> Tree:
    """The upstream tree for one target, minus its exclusions, renamed."""
    tree = export(commit, target)
    if not tree:
        raise SyncError(f"'{target.upstream}' is empty once its exclusions are applied")

    return rename(tree)


def is_excluded(path: str, target: Target) -> bool:
    return any(
        path.startswith(pattern) if pattern.endswith("/") else path == pattern
        for pattern in target.exclude
    )


def export(commit: str, target: Target) -> Tree:
    """Read one directory of the upstream tree into memory, path -> bytes.

    Exclusions are applied here rather than after the fact: an excluded subtree
    is upstream's business, so neither its file modes nor its size should be
    able to fail a sync that never wanted it.
    """
    listing = git(
        ["ls-tree", "-r", "-z", "--full-tree", f"{commit}:{target.upstream}"],
        cwd=CACHE_DIR,
    ).stdout

    tree: Tree = {}
    dropped = 0
    for entry in listing.split("\0"):
        if not entry:
            continue
        meta, path = entry.split("\t", 1)
        mode, kind, blob = meta.split(" ", 2)
        if is_excluded(path, target):
            dropped += 1
            continue
        if kind != "blob":
            raise SyncError(f"{target.upstream}/{path}: unsupported entry type '{kind}'")
        if mode != "100644":
            raise SyncError(f"{target.upstream}/{path}: unsupported file mode {mode}")
        tree[path] = git_bytes(["cat-file", "blob", blob])

    if dropped:
        skipped = ", ".join(target.exclude)
        print(f"    {target.local}: skipping {skipped} ({dropped} files)", flush=True)
    if not tree:
        raise SyncError(f"upstream has no files under '{target.upstream}' at {commit[:12]}")
    return tree


# --------------------------------------------------------------------------
# Renaming
# --------------------------------------------------------------------------


def rename(tree: Tree) -> Tree:
    """Apply RENAMES to every path and to the contents of every text file."""
    renamed: Tree = {}
    for path, data in sorted(tree.items()):
        renamed[substitute(path)] = rename_contents(path, data)

    manifest = renamed.get("pubspec.yaml")
    if manifest is not None:
        renamed["pubspec.yaml"] = override_pubspec(manifest)
    return renamed


def rename_contents(path: str, data: bytes) -> bytes:
    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError:
        # Binary asset — copied through untouched.
        return data
    return substitute(text).encode("utf-8")


def substitute(text: str) -> str:
    for old, new in RENAMES:
        text = text.replace(old, new)
    return text


def override_pubspec(data: bytes) -> bytes:
    """Re-apply PUBSPEC_OVERRIDES to the manifest's top-level keys.

    Rewritten line by line rather than through a YAML round-trip: the manifest
    is upstream's file, and every comment, quote style and blank line in it
    should survive a key this repository has to add.
    """
    lines = data.decode("utf-8").splitlines(keepends=True)
    pending = dict(PUBSPEC_OVERRIDES)

    out: list[str] = []
    for line in lines:
        match = re.match(r"([A-Za-z0-9_-]+):", line)
        key = match.group(1) if match else None

        if key is not None and key in pending:
            out.append(f"{key}: {pending.pop(key)}\n")
            continue

        out.append(line)
        if key == PUBSPEC_ANCHOR and pending:
            out.extend(f"{name}: {value}\n" for name, value in pending.items())
            pending = {}

    out.extend(f"{name}: {value}\n" for name, value in pending.items())
    return "".join(out).encode("utf-8")


# --------------------------------------------------------------------------
# Writing
# --------------------------------------------------------------------------


def install(target: Target, tree: Tree) -> None:
    """Replace the local directory with the staged tree, keeping build output."""
    local = ROOT / target.local
    kept = ignored_entries(target.local)

    removed = 0
    if local.exists():
        removed = clear(local, kept)

    for path, data in sorted(tree.items()):
        destination = local / path
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(data)

    print(f"    {target.local}: {len(tree)} files written, {removed} removed", flush=True)


def clear(local: Path, kept: set[Path]) -> int:
    """Delete everything under `local` except the paths git already ignores."""
    removed = 0
    for path in sorted(local.rglob("*"), key=lambda item: len(item.parts), reverse=True):
        if path in kept or any(parent in kept for parent in path.parents):
            continue
        if path.is_dir() and not path.is_symlink():
            if not any(path.iterdir()):
                path.rmdir()
        else:
            path.unlink()
            removed += 1
    return removed


def ignored_entries(relative: str) -> set[Path]:
    """The gitignored paths inside a target — build/, .dart_tool, .idea..."""
    listing = git(
        [
            "ls-files",
            "--others",
            "--ignored",
            "--exclude-standard",
            "--directory",
            "-z",
            "--",
            relative,
        ]
    ).stdout
    return {ROOT / entry.rstrip("/") for entry in listing.split("\0") if entry}


def has_local_work(target: Target, lock: dict) -> bool:
    """Whether a target holds uncommitted work this sync would destroy.

    A synced-but-uncommitted target is dirty to git yet safe to overwrite: the
    diff against HEAD is the previous run's own output. The lock file's digest
    tells the two apart, so syncing twice before committing does not need
    `--force` while a hand edit still does.
    """
    if not git(["status", "--porcelain", "--", target.local]).stdout.strip():
        return False

    recorded = lock.get("targets", {}).get(target.local, {}).get("digest")
    return recorded != digest(read_local(target.local))


# --------------------------------------------------------------------------
# Checking
# --------------------------------------------------------------------------


def report(staged: dict[str, Tree], *, show_diff: bool) -> int:
    """Compare the working tree against the staged upstream tree."""
    drifted = False
    for target in TARGETS:
        expected = staged[target.local]
        actual = read_local(target.local)

        added = sorted(set(actual) - set(expected))
        missing = sorted(set(expected) - set(actual))
        changed = sorted(
            path for path in set(expected) & set(actual) if expected[path] != actual[path]
        )

        if not (added or missing or changed):
            print(f"    {target.local}: in sync ({len(expected)} files)", flush=True)
            continue

        drifted = True
        print(
            f"    {target.local}: {len(changed)} changed, "
            f"{len(added)} extra, {len(missing)} missing"
        )
        for path in changed:
            print(f"      M {target.local}/{path}")
        for path in added:
            print(f"      + {target.local}/{path}")
        for path in missing:
            print(f"      - {target.local}/{path}")

        if show_diff:
            for path in changed:
                print_diff(f"{target.local}/{path}", expected[path], actual[path])

    if drifted:
        sys.stdout.flush()
        print(
            "\nthe vendored tree does not match upstream — run "
            "`python3 scripts/sync_ui.py --locked` to restore it",
            file=sys.stderr,
        )
        return 1

    print("\nvendored tree matches upstream", flush=True)
    return 0


def read_local(relative: str) -> Tree:
    """Read a local target back, skipping whatever git ignores there."""
    local = ROOT / relative
    if not local.exists():
        return {}

    kept = ignored_entries(relative)
    tree: Tree = {}
    for path in local.rglob("*"):
        if not path.is_file():
            continue
        if path in kept or any(parent in kept for parent in path.parents):
            continue
        tree[path.relative_to(local).as_posix()] = path.read_bytes()
    return tree


def print_diff(label: str, expected: bytes, actual: bytes) -> None:
    try:
        upstream_lines = expected.decode("utf-8").splitlines(keepends=True)
        local_lines = actual.decode("utf-8").splitlines(keepends=True)
    except UnicodeDecodeError:
        print(f"\n--- {label} (binary differs)")
        return

    print()
    sys.stdout.writelines(
        difflib.unified_diff(
            upstream_lines,
            local_lines,
            fromfile=f"upstream/{label}",
            tofile=f"local/{label}",
        )
    )


# --------------------------------------------------------------------------
# Lock file
# --------------------------------------------------------------------------


def read_lock() -> dict:
    if not LOCK_FILE.exists():
        return {}
    return json.loads(LOCK_FILE.read_text(encoding="utf-8"))


def write_lock(ref: str, commit: str, staged: dict[str, Tree]) -> None:
    lock = {
        "repository": UPSTREAM_HOMEPAGE,
        "ref": ref,
        "commit": commit,
        "synced_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "targets": {
            target.local: {
                "upstream": target.upstream,
                "files": len(staged[target.local]),
                "digest": digest(staged[target.local]),
            }
            for target in TARGETS
        },
    }
    LOCK_FILE.write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
    print(f"    {LOCK_FILE.relative_to(ROOT)}: pinned to {commit[:12]}", flush=True)


def digest(tree: Tree) -> str:
    """A stable fingerprint of a tree, so drift is visible in the lock diff."""
    accumulator = hashlib.sha256()
    for path, data in sorted(tree.items()):
        accumulator.update(path.encode("utf-8"))
        accumulator.update(b"\0")
        accumulator.update(hashlib.sha256(data).digest())
    return f"sha256:{accumulator.hexdigest()}"


# --------------------------------------------------------------------------
# Plumbing
# --------------------------------------------------------------------------


def git(
    command: list[str], *, cwd: Path = ROOT, check: bool = True
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        ["git", *command],
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if check and result.returncode != 0:
        raise SyncError(f"git {' '.join(command)} failed: {result.stderr.strip()}")
    return result


def git_bytes(command: list[str]) -> bytes:
    result = subprocess.run(
        ["git", *command],
        cwd=CACHE_DIR,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        raise SyncError(f"git {' '.join(command)} failed: {result.stderr.decode().strip()}")
    return result.stdout


def resolve_ref(args: argparse.Namespace, lock: dict, *, read_only: bool) -> str:
    if args.ref:
        return args.ref
    if args.locked or read_only:
        locked = lock.get("commit")
        if locked:
            return locked
        if args.locked:
            raise SystemExit(f"error: no lock file at {LOCK_FILE.relative_to(ROOT)}")
    return DEFAULT_REF


def print_next_steps() -> None:
    print(
        "\nNext:\n"
        "    dart pub get                      # upstream's dependency set differs\n"
        "    dart run melos run analyze\n"
        "    dart run melos run test\n"
        "\nDo not run scripts/format.py over the vendored package: upstream owns\n"
        "its formatting, and reformatting it here shows up as drift.",
        flush=True,
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Vendor the upstream Fastforge UI Flutter package into this repository.",
    )
    parser.add_argument(
        "--ref",
        help=f"Upstream branch, tag, or commit to sync (default: {DEFAULT_REF}).",
    )
    parser.add_argument(
        "--locked",
        action="store_true",
        help="Sync to the commit recorded in the lock file.",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Report drift against upstream and write nothing. Exits 1 on drift.",
    )
    parser.add_argument(
        "--diff",
        action="store_true",
        help="Like --check, but print the differences as a unified diff.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite the vendored package even if it has uncommitted changes.",
    )
    parser.add_argument(
        "--repo",
        help="Upstream repository URL, overriding the built-in default.",
    )
    return parser.parse_args()


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except SyncError as error:  # pragma: no cover - top-level guard
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(1) from None
