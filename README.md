# <p align="center"> modemmanager 🦀

[![Crates.io](https://img.shields.io/crates/v/modemmanager)](https://crates.io/crates/modemmanager)
[![Documentation](https://docs.rs/modemmanager/badge.svg)](https://docs.rs/modemmanager)
[![CI](https://github.com/freedesktop-rs/mmrs/actions/workflows/ci.yml/badge.svg)](https://github.com/freedesktop-rs/mmrs/actions/workflows/ci.yml)
[![License](https://img.shields.io/crates/l/modemmanager)](LICENSE-MIT)

An async-first Rust API for [ModemManager](https://modemmanager.org/) over [D-Bus](https://dbus.freedesktop.org/doc/dbus-specification.html). The goal is to provide a safe and simple high-level API for managing cellular modems on Linux systems, built on [`zbus`](https://docs.rs/zbus) for reliable D-Bus communication.

`modemmanager` is the ModemManager counterpart to [`nmrs`](https://github.com/freedesktop-rs/nmrs) (NetworkManager) — same author, same design philosophy: typed errors, async throughout, no leaking of raw D-Bus internals into the public API.

## Sample usage

### Listing modems

```rust,no_run
use modemmanager::ModemManager;

#[tokio::main]
async fn main() -> modemmanager::Result<()> {
    let mm = ModemManager::new().await?;

    for modem in mm.list_modems().await? {
        println!(
            "{} {} — {} ({}%, {})",
            modem.manufacturer, modem.model, modem.access_technologies,
            modem.signal_quality, modem.state,
        );
    }

    Ok(())
}
```

### Connecting the primary modem

```rust,no_run
use modemmanager::{BearerConfig, IpType, ModemManager};

#[tokio::main]
async fn main() -> modemmanager::Result<()> {
    let mm = ModemManager::new().await?;

    // Quick path: just an APN
    let bearer = mm.connect_simple("internet").await?;
    println!("connected on {}", bearer.interface);

    // Or a full bearer configuration
    let cfg = BearerConfig::new("internet")
        .with_ip_type(IpType::Ipv4v6)
        .with_user("user")
        .with_password("hunter2");
    mm.connect(&cfg).await?;

    Ok(())
}
```

### SIM PIN handling

```rust,no_run
use modemmanager::{ModemError, ModemManager};

#[tokio::main]
async fn main() -> modemmanager::Result<()> {
    let mm = ModemManager::new().await?;

    match mm.unlock_pin("1234").await {
        Ok(()) => println!("SIM unlocked"),
        Err(ModemError::WrongPin) => eprintln!("incorrect PIN"),
        Err(ModemError::WrongPuk) => eprintln!("incorrect PUK, SIM may now require PUK"),
        Err(e) => eprintln!("error: {e}"),
    }

    Ok(())
}
```

### Multi-modem systems

```rust,no_run
use modemmanager::ModemManager;

#[tokio::main]
async fn main() -> modemmanager::Result<()> {
    let mm = ModemManager::new().await?;

    for modem in mm.list_modems().await? {
        let scope = mm.modem(&modem.path);
        let status = scope.status().await?;
        println!("{}: connected = {}", modem.path, status.connected);
    }

    Ok(())
}
```

## Documentation

Complete API documentation: [docs.rs/modemmanager](https://docs.rs/modemmanager)

## Roadmap / Implementation Status

If something is missing that you'd like to see, please file a PR or issue, adding it to this roadmap.

### Modem

- [x] Modem enumeration and lookup by IMEI
- [x] Primary-modem convenience helpers (`enable`, `disable`, `connect`, `status`, ...)
- [x] Per-modem scoping via `mm.modem(path)`
- [x] Signal quality and access technology (2G–5G, CDMA) queries
- [ ] Real-time modem/bearer state monitoring
- [ ] Location (GPS/cell-tower) support
- [ ] USSD support
- [ ] Firmware/carrier configuration management

### SIM

- [x] PIN unlock, PUK unlock, PIN enable/disable, PIN change
- [x] Active SIM snapshot (ICCID, IMSI, operator name)
- [ ] Multi-SIM slot switching

### Bearers

- [x] Simple connect via APN
- [x] Full `BearerConfig` (IP type, credentials, roaming)
- [x] Bearer snapshot with IPv4 config and stats
- [ ] IPv6 config decoding
- [ ] Manual bearer create/delete (outside `Simple.Connect`)

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## Requirements

- **Rust**: 1.90.0+
- **ModemManager**: Running and accessible via D-Bus
- **Linux**: This library is Linux-specific

## License

This project is dual-licensed under either of the following licenses, at your option:

- MIT License
- Apache License, Version 2.0

You may use, copy, modify, and distribute this software under the terms of either license.

See the following files for full license texts:

- [MIT License](./LICENSE-MIT)
- [Apache License 2.0](./LICENSE-APACHE)
