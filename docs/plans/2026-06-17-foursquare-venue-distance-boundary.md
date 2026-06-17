---
title: Foursquare Venue Distance Boundary
type: bugfix
status: planned
date: 2026-06-17
---

# Foursquare Venue Distance Boundary

## Context

The venue parser accepts every finite nonnegative distance and then converts
meters to integer feet. A malformed but finite value can overflow the integer
conversion and terminate the app before the venue is skipped.

## Priority

1. Make the meters-to-feet conversion total for untrusted venue data.
2. Keep normal Foursquare distances and the current integer-foot display.
3. Execute the production policy in the hosted macOS gate.

## Requirements

- Add a small Foundation-only production policy that returns integer feet only
  for finite, nonnegative values whose converted result fits in `Int`.
- Use the policy from `FoursquareARCamera/ViewController.swift` before rendering
  a venue.
- Add standalone Swift behavior coverage for zero, ordinary values, the largest
  accepted value, overflow, negative values, NaN, and infinities.
- Wire the executable policy tests into `make check` and the canonical hosted
  workflow without requiring credentials or a live Foursquare request.
- Add mutation-sensitive static contracts and update maintained guidance.

## Implementation Units

### 1. Production conversion policy

Files:

- `FoursquareARCamera/Source/FoursquareVenueDistancePolicy.swift`
- `FoursquareARCamera/ViewController.swift`
- `FoursquareARCamera.xcodeproj/project.pbxproj`

Centralize safe conversion and make malformed distances follow the existing
skip-and-log path.

### 2. Executable and static regressions

Files:

- `Tests/FoursquareVenueDistancePolicyTests/main.swift`
- `scripts/run-foursquare-venue-distance-tests.sh`
- `scripts/check-baseline.sh`
- `.github/workflows/check.yml`
- `Makefile`

Compile the actual production helper with the standalone harness on macOS and
preserve portable static validation on Linux.

### 3. Guidance and evidence

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `AGENTS.md`
- `docs/plans/2026-06-17-foursquare-venue-distance-boundary.md`

Record only executed local and hosted evidence and preserve the historical
Mapbox rotation boundary without exposing its value.

## Validation

- Run the executable Swift policy tests where `swiftc` is available.
- Run repository-root and external-directory `make check`.
- Reject isolated mutations for production wiring, conversion bounds, behavior
  cases, workflow wiring, maintained guidance, and plan evidence.
- Audit the exact diff, project-file membership, generated artifacts,
  whitespace, conflict markers, and credential-shaped additions.
- Require exact-head hosted checks before recording terminal hosted evidence.

## Scope Boundaries

- Do not invent a tighter Foursquare business-distance limit.
- Do not make a live Foursquare request or require API credentials.
- Do not expose, copy, resolve, or close historical secret-scanning alert data.
- Do not merge or close this stacked pull request or its predecessors without
  explicit authorization.

## Verification Results

Implementation and verification are pending.
