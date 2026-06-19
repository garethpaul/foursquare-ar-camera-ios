---
title: Reachability Exact 204 Status
type: reliability
status: completed
date: 2026-06-13
---

# Reachability Exact 204 Status

## Summary

Treat the dedicated `generate_204` connectivity probe as successful only when
the probe response is exactly 204 without following redirects.

## Requirements

- R1. Replace the current `200..<400` success range with exact 204 acceptance.
- R2. Keep the probe URL, HEAD method, cache policy, timeout, and generic
  offline behavior unchanged.
- R3. Add a named helper and mutation-sensitive static contracts for 204
  acceptance plus 200, redirects, client errors, and server errors rejection.
- R4. Update maintained docs and record truthful local/platform limitations.
- R5. Do not claim device connectivity or live probe execution.

## Verification Plan

- Run all four Make gates and shell/diff/project metadata checks.
- Reject widened range, exact-200, removed helper, stale-plan, and missing
  evidence mutations.
- Take one bounded exact-head push/PR/code-scanning snapshot after push.

## Non-Goals

- Replacing the synchronous reachability architecture.
- Changing URLSession redirect delegates or the probe provider.
- Exercising camera, AR, location, Mapbox, or Foursquare behavior.

## Work Completed

- Added a named status helper that accepts only HTTP 204.
- Wired the maintained probe into the app target and offline-alert path.
- Routed the final probe response through the helper without changing request
  construction, timeout, or offline behavior.
- Added static, documentation, and completed-plan contracts.

## Verification Completed

- The five hostile mutations were rejected: widened 2xx acceptance, exact 200,
  helper bypass, stale plan status, and missing evidence.
- The all four Make gates passed result was confirmed against the final tree.
- Shell syntax, plist/workspace parsing, `git diff --check`, artifact, protected
  path, and secret scans are included in final verification.
- `xcodebuild was unavailable` on this Linux host, so no signed build or
  simulator execution was attempted.
- No live connectivity probe, camera, AR, location, Mapbox, or Foursquare flow
  was exercised.
