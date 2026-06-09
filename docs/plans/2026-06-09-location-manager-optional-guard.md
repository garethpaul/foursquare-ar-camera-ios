---
title: Location Manager Optional Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`LocationManager` created a Core Location manager and then repeatedly
force-unwrapped the optional property during setup. It also stored a heading and
force-unwrapped it when forwarding delegate updates. Those paths are normally
initialized, but the AR/location code already treats authorization and partial
state carefully, so this optional boundary should stay explicit.

## Goals

- Avoid force-unwrapping the stored Core Location manager during setup.
- Avoid force-unwrapping the stored heading when forwarding delegate updates.
- Preserve authorization-gated heading and location updates.
- Extend static verification and docs for the optional-state boundary.

## Implementation

- Set up a local `CLLocationManager` instance before storing it.
- Used the local manager for setup, authorization-gated starts, and current
  location assignment.
- Forwarded a local `headingValue` to the delegate instead of `self.heading!`.
- Extended README, SECURITY, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full workspace verification still requires a macOS/Xcode environment with the
legacy CocoaPods dependencies installed.
