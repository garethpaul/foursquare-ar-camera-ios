---
title: Foursquare Swift Runner Signal Cleanup
type: reliability
date: 2026-06-18
status: completed
execution: code
---

# Foursquare Swift Runner Signal Cleanup

## Status: Completed

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
- Keep completed evidence pinned to the exact implementation head and canonical
  hosted run identifiers.

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

## Verification Completed

- `sh -n` passed for all three runners and the baseline gate.
- `make check`, `make lint`, `make test`, and `make build` passed from the
  repository, and absolute-Makefile `make check` passed from `/tmp`.
- Isolated fake compilers proved success cleanup, compiler-failure cleanup with
  status 42, and bounded `TERM` cleanup independently for the response-URL,
  venue-distance, and venue-text runners, with no residual temporary output.
- Mutations removing direct cleanup, restoring an exit-only `TERM` binding,
  and prematurely completing the plan were rejected.
- Review found no actionable correctness, maintainability, testing, or
  plan-completeness issues.
- Diff, executable-mode, worktree, generated-artifact, and high-confidence
  credential-pattern audits passed.
- The implementation was committed and pushed as
  `ae7cd17b9db57728f2aa4714be130582e03f71e6`.
- Push run `27747566549` and pull-request run `27747567053` completed
  successfully on that exact head, including all three Swift policy harnesses,
  the Xcode project check, and the credential baseline. PR #19 remained open
  and mergeable, with zero open branch code-scanning or Dependabot alerts.
- The historical Mapbox secret-scanning alert remains an external provider-side
  rotation or revocation boundary; no secret value was retrieved or recorded.

## Scope Boundaries

- Do not change venue policy, response URL behavior, app target membership, AR
  rendering, Foursquare requests, camera/location permissions, or dependencies.
- Do not retrieve, copy, resolve, or close the historical Mapbox secret alert;
  provider-side revocation remains external work.
