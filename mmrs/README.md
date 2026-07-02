# mmrs

[![Crates.io](https://img.shields.io/crates/v/mmrs)](https://crates.io/crates/mmrs)
[![Documentation](https://docs.rs/mmrs/badge.svg)](https://docs.rs/mmrs)
[![License](https://img.shields.io/crates/l/mmrs)](LICENSE)

Rust bindings for [ModemManager](https://modemmanager.org/) over D-Bus.

> **Status:** Early development. The public API covers modem enumeration, primary-modem
> connection helpers, SIM PIN operations, signal/access-technology queries, and
> per-modem scoping. Expect breaking changes before `1.0`.

## Why?

`mmrs` provides a high-level, async API for managing cellular modems on Linux systems.
It abstracts the complexity of D-Bus communication with ModemManager, offering typed
error handling and an ergonomic interface — mirroring the design of its sibling crate,
[`nmrs`](https://github.com/cachebag/nmrs) (NetworkManager).

## Features

- **Modem enumeration**: list all modems managed by ModemManager, or look one up by IMEI
- **Simple connect**: bring up a packet-data bearer with just an APN, or a full `BearerConfig`
- **SIM management**: PIN/PUK unlock, PIN enable/disable, PIN change
- **Signal & access technology**: query signal quality and decode the `AccessTechnology` bitmask (2G–5G, CDMA)
- **Per-modem scoping**: target a specific modem on multi-modem systems via `mm.modem(path)`
- **Typed errors**: structured `ModemError` variants instead of raw D-Bus strings
- **Fully async**: built on `zbus` with async/await throughout

## Requirements

- Linux with ModemManager running
- Rust 1.90.0+

## Installation

```toml
[dependencies]
mmrs = "0.1"
```
or
```bash
cargo add mmrs
```

## Contributing

Contributions welcome — see the [contributing guide](https://github.com/freedesktop-rs/mmrs/blob/master/CONTRIBUTING.md). In short:

- Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) (`type(#issue): description`)
- Run `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, and `cargo test -p mmrs` before submitting
- Attach a relevant [issue](https://github.com/freedesktop-rs/mmrs/issues) when possible
- All tests must pass before merge

## License

Licensed under either of [MIT](../LICENSE-MIT) or [Apache-2.0](../LICENSE-APACHE), at your option.
