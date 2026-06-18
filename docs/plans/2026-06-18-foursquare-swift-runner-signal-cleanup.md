---
title: Foursquare Swift Runner Signal Cleanup
type: reliability
date: 2026-06-18
status: planned
execution: code
---

# Foursquare Swift Runner Signal Cleanup

## Status: Planned

## Summary

Make all three standalone Swift policy runners remove their temporary build
directories when interrupted while `swiftc` is still running.

## Baseline

The response-URL, venue-distance, and venue-text runners remove temporary build
output after success and compiler failure, but their exit-only signal traps
leave runner-specific temporary directories behind after `TERM` under the
repository's POSIX `/bin/sh` execution path.

## Priority

P1 test-infrastructure reliability. The leak affects maintained executable
policy gates without changing app, AR, location, camera, or network behavior.

## Requirements

- Invoke cleanup directly from each runner's signal handler before returning
  the conventional signal-derived status.
- Keep normal exit cleanup and each existing compiler/test command unchanged.
- Extend the structured baseline to reject exit-only handlers and missing
  `HUP`, `INT`, or `TERM` bindings in every runner.
- Verify success, compiler failure, and bounded termination independently for
  all three runners using isolated fake compilers and temporary directories.
- Keep this plan planned until exact implementation-head hosted checks pass;
  then record completed local and hosted evidence in a separate commit.

## Implementation Units

### U1: Direct signal cleanup

Update these runners with the same POSIX-compatible cleanup handler:

- `scripts/run-foursquare-response-url-tests.sh`
- `scripts/run-foursquare-venue-distance-tests.sh`
- `scripts/run-foursquare-venue-text-tests.sh`

### U2: Mutation-sensitive runner contracts

Extend `scripts/check-baseline.sh` to parse all three runners and require direct
cleanup plus exact signal bindings. Require this plan and its current status.

### U3: Verification and completion evidence

Run repository/external Make gates, isolated fake-compiler probes, hostile
mutations, artifact/secret audits, and exact-head hosted checks. Only after the
implementation head is terminal-green, change this plan to completed and pin
the implementation SHA and canonical run identifiers.

## Scope Boundaries

- Do not change venue policy, response URL behavior, app target membership, AR
  rendering, Foursquare requests, camera/location permissions, or dependencies.
- Do not retrieve, copy, resolve, or close the historical Mapbox secret alert;
  provider-side revocation remains external work.
