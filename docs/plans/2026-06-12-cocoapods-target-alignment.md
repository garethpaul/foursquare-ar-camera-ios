---
title: CocoaPods Target Alignment
date: 2026-06-12
status: completed
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

## Work Completed

- Aligned the Podfile with the checked-in `FoursquareARCamera` native target.
- Added source contracts for the single Podfile target, project target, and
  generated `Pods-FoursquareARCamera` support references.
- Preserved the legacy pod declarations, lockfile, Swift, deployment, and
  generated project settings outside the target-name repair.

## Verification Completed

- All four Make gates, shell syntax, and `git diff --check` passed locally;
  Xcode project listing was truthfully skipped because Xcode is unavailable.
- Implementation push run `27392510844` and pull-request run `27392514499`
  passed at commit `8c7f86f1e375cc3208925b2e4cdd2bf8c2600413`, including hosted
  `xcodebuild -list`.
- Post-merge push run `27392528885` and CodeQL run `27402320459` passed at
  default-branch merge commit `51938faf4329223b48bcf1583ab652c7f05a0f42`.
