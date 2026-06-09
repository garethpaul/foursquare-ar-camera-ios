---
title: FSQView Nib Outlet Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`FSQView.commonInit()` loaded `FSQView.xib` and immediately used the
implicitly-unwrapped `view` outlet. If the nib failed to load or the outlet was
miswired, venue card rendering could crash before the existing AR mask and tap
guards had a chance to run.

## Goals

- Guard the loaded nib outlet before setting its frame or adding it as a
  subview.
- Keep the existing venue card nib layout and initializer behavior.
- Log a generic warning without location, credential, or venue payload details.
- Extend static verification and docs for the nib outlet boundary.

## Implementation

- Added `guard let loadedView = view` in `FSQView.commonInit()`.
- Logged a generic CocoaLumberjack warning when the nib outlet is unavailable.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`

Full workspace verification still requires a macOS/Xcode environment with the
legacy CocoaPods dependencies installed.
