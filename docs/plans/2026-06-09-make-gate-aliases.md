---
title: Make Gate Aliases
date: 2026-06-09
status: completed
execution: code
---

## Context

The repository had a working `make check` target, but the local pre-push gate
also expects `make lint`, `make test`, and `make build`. Without those aliases,
the first gate command fails before reaching the static baseline.

## Goals

- Provide stable Makefile targets for lint, test, build, and check.
- Keep the targets usable on machines without Xcode.
- Document that lint, test, and build currently delegate to the static baseline.
- Extend the static baseline so the aliases remain available.

## Implementation

- Added `lint`, `test`, and `build` aliases that delegate to `check`.
- Updated README, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full Xcode workspace listing is still skipped locally because `xcodebuild` is
not installed in this environment.
