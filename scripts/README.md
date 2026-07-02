# Scripts

Utility scripts for managing mmrs releases.

## `bump_version.py`

Prepares a release by updating version numbers and changelog.

### Usage

```bash
python3 scripts/bump_version.py <version> <release_type>
```

### Arguments

- `version`: Version number in semver format (e.g., `0.2.0`)
- `release_type`: Either `beta` or `stable`

### Examples

```bash
# Prepare mmrs 0.2.0 stable release
python3 scripts/bump_version.py 0.2.0 stable

# Prepare mmrs 0.2.0 beta release
python3 scripts/bump_version.py 0.2.0 beta
```

### What it does

1. Updates `version` in `mmrs/Cargo.toml`
2. Updates `mmrs/CHANGELOG.md` (moves Unreleased section to new version)

## Releasing

```bash
# 1. Bump version and update changelog
python3 scripts/bump_version.py 0.2.0 stable

# 2. Review and commit
git diff
git commit -am "chore(mmrs): prepare 0.2.0 release"

# 3. Push to master and tag
git push origin master
git tag mmrs-v0.2.0
git push origin mmrs-v0.2.0

# CI automatically publishes to crates.io
```
