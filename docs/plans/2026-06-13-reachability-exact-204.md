---
title: Reachability Exact 204 Status
type: reliability
status: planned
date: 2026-06-13
---

# Reachability Exact 204 Status

## Summary

Treat the dedicated `generate_204` connectivity probe as successful only when
its final HTTP response is exactly 204.

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
