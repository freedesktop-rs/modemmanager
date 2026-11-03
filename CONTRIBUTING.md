# Contributing

Thank you for wanting to contribute to `modemmanager`!

I'm fairly accepting to all PR's, only with a couple caveats:

- Do not submit low-effort or purely LLM generated code. If you absolutely must, please disclose _how_ you used AI otherwise I will close the PR.
- Please try to (when possible) contribute to an [issue](https://github.com/freedesktop-rs/mmrs/issues). For smaller changes with no existing issue, a PR is fine but for larger changes, please open an issue first.

## Requirements

- Rust (stable) via `rustup`
- Linux with ModemManager only if you want to exercise the library against a real modem

Unit and documentation tests run anywhere; they never contact ModemManager.

```bash
cargo fmt --all -- --check
cargo clippy --locked --all-targets --all-features -- -D warnings
cargo test --locked --lib --all-features
cargo test --locked --doc --all-features
```

## Docker

The `Dockerfile` builds the crate with ModemManager installed, for working on
a non-Linux host:

```bash
docker build -t modemmanager-lib .
docker compose run --rm test
docker compose run --rm shell
```

There is no modem in the container, so this only proves the crate builds and
its unit tests pass next to a running daemon.

## When your branch falls behind `master`

If the respective branch for a PR goes out of sync, I prefer you _rebase_.

## Issues and Commit Message Hygiene

Make your commit messages at least slightly meaningful. I don't really care much about the format, but please try to be descriptive to the reader.

A good example:

```log
fix(#24): fixed bug where something was happening
```

## Tests

All unit and documentation tests must pass before a merge takes place. Tests
operate on decoded values and D-Bus property maps directly; do not add tests
that need a live modem and silently pass when one is absent.

## License

All contributions are dual-licensed under [MIT](./LICENSE-MIT) or [Apache-2.0](./LICENSE-APACHE), at your option.
