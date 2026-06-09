---
title: Reachability Init Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`ViewController.viewDidLoad` force-unwrapped `Reachability()` before deciding
whether to show the offline alert. If the helper cannot be constructed, the app
can terminate before rendering the AR view or reporting the network state.

## Goals

- Avoid force-unwrapping reachability initialization.
- Preserve the existing offline alert behavior when reachability is available.
- Use a generic diagnostic when the helper cannot be created.
- Extend the static baseline so the guard remains in place without Xcode.

## Implementation

- Replaced `Reachability()!` with optional binding.
- Added a generic `DDLogWarn` path for failed reachability setup.
- Updated README, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode workspace listing is still skipped locally because `xcodebuild` is
not installed in this environment.
