# Contributing

Thank you for wanting to contribute to `mmrs`!

I'm fairly accepting to all PR's, only with a couple caveats:

- Do not submit low-effort or purely LLM generated code. If you absolutely must, please disclose _how_ you used AI otherwise I will close the PR.
- Please try to (when possible) contribute to an [issue](https://github.com/freedesktop-rs/mmrs/issues). For smaller changes with no existing issue, a PR is fine but for larger changes, please open an issue first.

## Requirements

**To run or develop mmrs you need:**

- Rust (stable) via `rustup`
- A running `ModemManager` instance (or a modem simulator, e.g. `mm.py`/`libqmi`'s test tools)

I also provide a `Dockerfile` you can build if you don't use Linux and use macOS instead.

**To build the image:**

```bash
docker build -t mmrs-lib .
```

**To run tests:**

```bash
docker compose run test
```

**To run an interactive shell:**

```bash
docker compose run shell
```

If you just want quick builds/tests without the full ModemManager environment:

```bash
docker run --rm mmrs-lib cargo test --lib
docker run --rm -it -v $(pwd):/app mmrs-lib   # mounts local changes
```

```bash
cargo test                   # run library tests
cargo build                  # build the library
cargo check                  # you get the point...
```

## When your branch falls behind `master`

If the respective branch for a PR goes out of sync, I prefer you _rebase_.

## Issues and Commit Message Hygiene

Make your commit messages at least slightly meaningful. I don't really care much about the format, but please try to be descriptive to the reader.

A good example:

```log
fix(#24): fixed bug where something was happening
```

## Tests

All tests must pass before a merge takes place.

### Ensure ModemManager is running

```bash
sudo systemctl start ModemManager
```

### Test everything

```bash
cargo test --all-features
```

Most unit tests do not require a real modem or ModemManager instance — they operate on
decoded values and D-Bus property maps directly. Tests that do require a live modem
should skip gracefully when ModemManager or hardware is unavailable, following the same
pattern as [`nmrs`](https://github.com/cachebag/nmrs)'s integration tests.

## License

All contributions fall under the [MIT License](https://github.com/freedesktop-rs/mmrs?tab=MIT-1-ov-file).
