---
title: Foursquare Venue Request Timeouts
type: reliability
date: 2026-06-15
status: in_progress
execution: code
---

# Foursquare Venue Request Timeouts

## Problem Frame

The dedicated Alamofire `SessionManager` rejects redirects and validates the
final response, but its `URLSessionConfiguration` still relies on platform
timeout defaults. A stalled venue lookup keeps `loaded` set until the request
eventually fails, delaying the existing bounded retry release. Request and
resource timeouts should be explicit and reviewable.

## Prioritized Engineering Work

1. **P0 - Request bound:** set an explicit per-request timeout before manager
   construction.
2. **P0 - Resource bound:** set a larger explicit total resource timeout before
   manager construction.
3. **P1 - Contract enforcement:** reject missing, reordered, non-positive, or
   excessively broad timeout values through the maintained baseline.
4. **P1 - Guidance:** document the bounds without claiming Linux runtime or
   live Foursquare validation.

## Requirements

- R1. Venue requests must use a 15-second request timeout.
- R2. The complete venue resource load must use a 30-second timeout.
- R3. Both values must be configured before `SessionManager(configuration:)`.
- R4. Redirect refusal, final URL validation, status/MIME checks, response
  parsing, credential handling, and the existing 30-second retry release must
  remain unchanged.
- R5. Static contracts must reject timeout removal, widening, ordering drift,
  guidance removal, and incomplete verification evidence.

## Implementation Units

### U1: Configure The Session

Files:

- `FoursquareARCamera/ViewController.swift`

Approach:

- Set `timeoutIntervalForRequest` to 15 seconds.
- Set `timeoutIntervalForResource` to 30 seconds.
- Keep both assignments adjacent to the existing headers and before manager
  construction.

### U2: Enforce The Boundary

Files:

- `scripts/check-venue-request-timeouts.py`
- `scripts/check-baseline.sh`

Approach:

- Scope checks to the dedicated session-manager initializer.
- Verify exact values and assignment-before-construction ordering.
- Require completed plan evidence and maintained guidance.

### U3: Synchronize Guidance

Files:

- `AGENTS.md`
- `CHANGES.md`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `docs/plans/2026-06-15-foursquare-venue-request-timeouts.md`

## Verification

- Focused static timeout checker and shell syntax.
- Repository and external-directory `make check`, plus maintained alias gates.
- Hostile mutations for request/resource removal, value widening, ordering,
  guidance, and completion evidence.
- Exact diff, Xcode project, generated artifact, conflict marker, and
  changed-line secret audits.

## Risks

- Slow networks may fail venue lookup sooner than the platform default. The
  existing generic failure path and 30-second retry release remain responsible
  for recovery.
- Xcode, simulator/device, and live Foursquare behavior cannot be established
  on this Linux host.

## Status: In Progress
