# AGENTS.md

Context for AI agents working in this repository.

## Project overview

`modemmanager` is a Rust library for managing cellular modems through
ModemManager over D-Bus. It is the ModemManager counterpart to
[`nmrs`](https://github.com/freedesktop-rs/nmrs) and follows the same
design: typed errors, async throughout, no raw D-Bus types in the public
API. The GitHub repository is `freedesktop-rs/mmrs`; the crate is
published as `modemmanager` because `mmrs` on crates.io belongs to an
unrelated project.

## Layout

```
src/
  lib.rs                — public API surface; re-exports from api/
  api/
    modem_manager.rs    — ModemManager struct, the single entry point; primary-modem helpers
    modem_scope.rs      — ModemScope, the same operations bound to one modem path
    models/             — public types, enums, ModemError, Result
  dbus/                 — zbus proxy definitions, one file per ModemManager interface; crate-private
scripts/                — bump_version.py and its README
```

Only what `lib.rs` re-exports is public API. `dbus` stays `pub(crate)`.

## Commands

These match CI exactly. Everything runs with `--locked`; a dependency
change must include `Cargo.lock`.

```bash
cargo fmt --all -- --check
cargo clippy --locked --all-targets --all-features -- -D warnings
cargo test --locked --lib --all-features
cargo test --locked --doc --all-features
```

No test contacts ModemManager. Tests operate on decoded property maps
and model values. There is no integration harness yet (#5, #8); do not
add tests that need a modem and pass silently without one.

## Toolchain

- Edition 2024, stable Rust. `rust-version` in `Cargo.toml` is the MSRV.
- `[lints]` in `Cargo.toml`: `unused = "warn"`; clippy allows
  `too_many_arguments` and `type_complexity`. Do not add `#[allow]` in
  code for lints already handled there.

## Code conventions

- Every public fallible operation returns `modemmanager::Result<T>`
  (`Result<T, ModemError>`). Use existing variants before adding one.
  `ModemError` must stay at or under 128 bytes or clippy's
  `result_large_err` fails the build; that is why `DbusOperation` boxes
  its `zbus::Error`.
- No `unwrap()`, `expect()`, or `panic!` outside `#[cfg(test)]`.
- Public structs and enums are `#[non_exhaustive]`. Config structs use
  `with_*` builders returning `Self` with `#[must_use]`.
- Enum decoders are `const fn from_raw(value)` with an `Unknown` arm for
  values this crate does not know, never a panic or an error.
- Every public item has a doc comment. Examples use `modemmanager::`
  paths and must compile under `cargo test --doc`.
- Unit tests live in `#[cfg(test)] mod tests` next to the code. Assert
  observable behavior through the public API.
- A bug fix includes a test that fails without the fix.

## ModemManager semantics

- **Object paths carry indices that change.** Modems are
  `/org/freedesktop/ModemManager1/Modem/N`; `N` is reassigned when a
  modem resets, is replugged, or ModemManager restarts. Never persist a
  path; look modems up again by IMEI (`modem_by_imei`) or re-enumerate.
- **"/" is the null path.** ModemManager uses the root path where D-Bus
  has no `None`: a modem with no SIM reports `Sim = "/"`, and
  `Simple.Disconnect("/")` disconnects every bearer on the modem. Decode
  `"/"` as `None`.
- **The primary modem is the lowest numeric index.** Paths are sorted
  numerically, not lexically, so `Modem/2` precedes `Modem/10`.
- **Modem state is a signed enum.** `-1` is `Failed`, `0` is `Unknown`,
  and `1` through `11` are `Initializing`, `Locked`, `Disabled`,
  `Disabling`, `Enabling`, `Enabled`, `Searching`, `Registered`,
  `Disconnecting`, `Connecting`, `Connected`. A modem must be `Enabled`
  or later before `Simple.Connect` succeeds; `Locked` means the SIM
  needs a PIN first.
- **`Simple.Connect` owns the bearer.** It creates the bearer from the
  properties map (`apn`, `ip-type`, `user`, `password`,
  `allow-roaming`) and activates it in one call, returning the bearer
  path. Manual `CreateBearer` plus `Bearer.Connect` is a separate path
  (#7) and not what the current API does.
- **Signal quality is `(u32, bool)`.** The bool says whether the value
  is recent. A stale value is treated as unknown rather than reported.
- **Access technology is a bitmask.** Multiple bits can be set at once
  (an LTE modem camping on 5G NSA reports both). Test with the `has_*`
  and `is_*` helpers; never compare for equality.
- **SIM lock state is `MMModemLock`.** `0` unknown, `1` none, `2`
  `SimPin`, `3` `SimPin2`, `4` `SimPuk`, `5` `SimPuk2`, then the phone
  locks. `unlock_puk` sets a new PIN at the same time; there is no
  PUK-only unlock.
- **PIN errors are D-Bus error names.**
  `org.freedesktop.ModemManager1.Error.MobileEquipment.IncorrectPassword`
  and `.IncorrectPin` map to `WrongPin`; `.IncorrectPuk` maps to
  `WrongPuk`. Match on the error name, never on the message text.
- **Property strings are not guaranteed UTF-8.** Operator names and
  identifiers come from the SIM and the network; `InvalidUtf8` exists
  for a reason.

## CI

`ci.yml` runs format, clippy, lib and doc tests, and an aarch64 cross
build on every push and pull request. There is no semver check until the
first version is published and a baseline exists.

`publish-lib.yml` runs on a `v*` tag: it checks the tag against
`Cargo.toml`, runs `cargo publish --locked`, and creates the GitHub
release.

## Changelog and commits

Commits: `type(#issue): description`, one logical change each.

`CHANGELOG.md` is Keep a Changelog. Entries go under `[Unreleased]` in
`Added`, `Changed`, or `Fixed`, and cite the pull request in
parentheses, never the issue.

## Releasing

On a branch:

```bash
python3 scripts/bump_version.py X.Y.Z stable
git commit -am "chore(release): prepare X.Y.Z release"
```

Open a PR to master. After it merges:

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```
