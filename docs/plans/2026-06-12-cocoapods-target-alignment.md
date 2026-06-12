---
title: CocoaPods Target Alignment
date: 2026-06-12
status: planned
execution: build-configuration
---

## Context

The checked-in Xcode project has one native app target named
`FoursquareARCamera`, and its generated CocoaPods support references are named
`Pods-FoursquareARCamera`. The Podfile instead declares `PlacesARCamera`, which
does not exist in the project, so `pod install` cannot integrate dependencies
with the app target described by the repository.

## Goals

- Align the Podfile target with the checked-in Xcode native target.
- Guard against reintroducing the stale `PlacesARCamera` name.
- Keep the existing Swift 4.0, iOS 11, pod declarations, lockfile, and generated
  project references unchanged in this focused repair.
- Document that dependency resolution and lockfile regeneration still require a
  dedicated legacy CocoaPods/Xcode modernization pass.

## Implementation

- Change the Podfile target to `FoursquareARCamera`.
- Extend `scripts/check-baseline.sh` to require one matching Podfile target,
  reject `PlacesARCamera`, and verify the project/native CocoaPods references.
- Update README, VISION, SECURITY, and CHANGES with the target-alignment and
  lockfile boundary.

## Verification

- `sh -n scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
- Hosted macOS `xcodebuild -list` project parsing

`pod install` is intentionally not claimed here because CocoaPods and the
legacy dependency toolchain are unavailable in this environment.
