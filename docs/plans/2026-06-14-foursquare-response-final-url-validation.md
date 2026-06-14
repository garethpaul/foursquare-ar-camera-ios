---
title: Foursquare Response Final URL Validation
type: security
status: completed
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

- Added an Alamofire validator that requires the final response URL to use the
  exact HTTPS Foursquare API host and path without userinfo, an explicit port,
  or a fragment.
- Kept final URL validation between the existing status and media validators so
  rejected redirects reach the generic bounded retry before JSON handling.
- Extended the static request-chain contract and repository guidance for final
  URL provenance and continuing platform/live-validation limits.

## Verification Completed

- All four Make gates passed the maintained static baseline from the repository
  root, and the absolute-Makefile check passed from an external directory.
- The validator removal mutation failed the single-chain contract.
- The scheme mutation failed the exact HTTPS endpoint contract.
- The host mutation failed the exact Foursquare host contract.
- The path mutation failed the exact venue-search path contract.
- The port mutation failed the no-explicit-port contract.
- The validation ordering mutation failed after moving final URL validation
  behind media validation.
- The failure retry mutation failed the bounded generic retry contract.
- The plan evidence mutation failed the completed-evidence contract.
- Shell syntax, plist/workspace XML parsing, executable-mode verification,
  `git diff --check`, and intended-file secret and artifact scans are included
  in final-tree verification.
- `xcodebuild`, CocoaPods installation, signing, simulator/device execution,
  camera, AR, location, Mapbox, and live Foursquare behavior are unavailable or
  intentionally unclaimed on this Linux host.
- The hosted pull-request check and code-scanning snapshot will be recorded
  against the exact pushed head in the external engineering tracker.
