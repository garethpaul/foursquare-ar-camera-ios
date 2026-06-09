---
title: Foursquare Venue Lookup Retry Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`ViewController.getFoursquareLocations(_:)` uses the `loaded` flag to avoid
starting overlapping venue searches. Before this pass, credential-missing,
request-failed, and malformed-or-empty response paths could retry immediately
on frequent location updates.

The AR scene should avoid request storms while still allowing a transient venue
lookup failure to recover.

## Goals

- Keep one venue lookup active or loaded at a time.
- Avoid immediate retry loops when credentials are missing, the API fails, or no
  valid venues are returned.
- Allow those non-success paths to retry after a bounded cooldown.
- Extend static verification and docs for the retry boundary.

## Implementation

- Added a `venueLookupRetryDelay` constant and helper that logs the reason and
  releases the lookup gate after 30 seconds.
- Reused the helper for missing credentials, request failure, and zero valid
  venues in a successful response.
- Counted only parsed venue payloads that reach AR and compass rendering.
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
