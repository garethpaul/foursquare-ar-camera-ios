---
title: Map Annotation Optional Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`ViewController.updateUserLocation()` created map annotations lazily, then
force-unwrapped the optional annotation properties when centering the map and
updating the debug location estimate. The properties are expected to be present
after creation, but the method already handles partial AR and location state, so
the map overlay boundary should stay explicit.

## Goals

- Avoid force-unwrapping the user annotation while updating or centering the map.
- Avoid force-unwrapping the debug location estimate annotation.
- Preserve existing user-location and debug-overlay behavior.
- Extend the dependency-free baseline and docs for the map annotation boundary.

## Implementation

- Bound the user annotation to a local `MKPointAnnotation`, creating and adding
  it only when the stored annotation is missing.
- Bound the debug location estimate annotation to a local `MKPointAnnotation`
  and removed it through optional binding when no estimate is available.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

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
