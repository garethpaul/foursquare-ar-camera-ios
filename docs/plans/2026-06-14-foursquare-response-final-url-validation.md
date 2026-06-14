---
title: Foursquare Response Final URL Validation
type: security
status: planned
date: 2026-06-14
---

# Foursquare Response Final URL Validation

## Summary

Require successful Foursquare venue responses to finish at the exact HTTPS API
endpoint before Alamofire validates media metadata or invokes JSON parsing.

## Priority

1. Reject redirected or otherwise unexpected final response origins and paths.
2. Preserve the existing single request, 2xx status, JSON media, and bounded
   retry behavior.
3. Keep the legacy Swift 4, Alamofire, CocoaPods, AR, location, and credential
   boundaries unchanged.

## Requirements

- R1. A single custom Alamofire validator must require the final response URL
  to use `https`, host `api.foursquare.com`, have no explicit port, and use the
  exact `/v2/venues/search` path.
- R2. Final URL validation must run after the 2xx status validator and before
  content-type validation and the single `responseJSON` handler.
- R3. Rejected final URLs must reach the existing generic failure retry path
  without logging response content or redirect targets.
- R4. Static contracts must reject validator removal, scheme/host/path/port
  weakening, reordered validation, duplicate requests or handlers, weakened
  retry behavior, documentation drift, or incomplete plan evidence.
- R5. README, SECURITY, VISION, CHANGES, and AGENTS must describe the final URL
  boundary without claiming live API or device validation.
- R6. The completed plan must record actual local, mutation, and hosted
  verification evidence.

## Non-Goals

- Changing the Foursquare endpoint, parameters, credentials, API version,
  success status range, or JSON media allowlist.
- Disabling redirects globally or changing Alamofire session configuration.
- Changing venue parsing, coordinate validation, AR rendering, map annotations,
  retries, or logging.
- Updating Swift, iOS, Alamofire, CocoaPods, Mapbox, or project metadata.
- Claiming compilation, signing, simulator/device, camera, location, or live
  Foursquare validation from this Linux host.

## Implementation Units

### 1. Alamofire Final URL Validator

Files: `FoursquareARCamera/ViewController.swift`

- Add an exact scheme, host, port, and path validator between status and media
  validation.

### 2. Static Contracts

Files: `scripts/check-baseline.sh`

- Require one request, one status validator, one exact final URL validator, one
  JSON media validator, one response handler, exact ordering, generic failure
  retry behavior, documentation, and completed evidence.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the response-provenance boundary and continuing platform/live
  validation limits.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` from the
  repository root, plus `make check` through the absolute Makefile path from an
  external directory.
- Remove the validator, weaken scheme/host/path/port checks, move it after
  content-type validation, duplicate the handler, remove failure retry, and
  regress plan evidence; each mutation must be rejected.
- Run shell syntax, plist/workspace XML parsing, executable-mode checks,
  `git diff --check`, and intended-file secret/artifact scans.
- Take one bounded exact-head pull-request and code-scanning snapshot after
  push; do not start a watch loop.

## Work Completed

- Not yet implemented.

## Verification Completed

- Not yet run.
