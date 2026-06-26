---
title: Foursquare Request Location Boundary
type: bugfix
status: completed
date: 2026-06-26
---

# Foursquare Request Location Boundary

## Context

Venue response coordinates were validated before rendering, but the current AR
location used to construct the credential-bearing venue request was accepted
without a finite geographic range check. An invalid estimate could acquire the
single lookup generation and prevent a later valid estimate from proceeding.

## Requirements

- Add a Foundation-only production policy for finite latitude and longitude in
  the inclusive geographic ranges.
- Apply it before venue lookup state is claimed, credentials are read, or a
  network request is constructed.
- Do not log rejected coordinate values.
- Execute the production policy in a standalone Swift harness when `swiftc` is
  available and preserve dependency-free static and mutation contracts.
- Do not add freshness or horizontal-accuracy policy without device evidence.

## Implementation

- `FoursquareRequestLocationPolicy` accepts finite latitude in `-90...90` and
  longitude in `-180...180`.
- `ViewController.getFoursquareLocations` returns before `beginIfIdle()` for an
  invalid coordinate, leaving a later valid estimate eligible to start lookup.
- The app target, Make gate, behavior harness, maintenance baseline, and project
  guidance all share the same production boundary.

## Verification

- RED: `make check` rejected the missing production request-location policy.
- GREEN: repository-root and external-directory `make check` passed; this host
  truthfully skipped executable Swift and Xcode project parsing because
  `swiftc` and `xcodebuild` are unavailable.
- All six production Swift harnesses passed in a network-disabled Swift 5.10
  container, including the new request-location policy boundary cases.
- Seven request-location hostile mutations were rejected across finite/range
  checks, production ordering, test cases, app membership, Make, and runner
  wiring.
- No live Foursquare request was made and no credentials or location values
  were read, logged, or recorded.

## Scope Boundaries

- Preserve the current radius, API endpoint, response validation, retry state,
  and visible-scene lifecycle.
- Physical-device AR, Core Location, Mapbox, and live Foursquare behavior remain
  an external verification boundary.
