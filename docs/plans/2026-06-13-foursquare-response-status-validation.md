---
title: Foursquare Response Status Validation
type: security
status: completed
date: 2026-06-13
---

# Foursquare Response Status Validation

## Summary

Reject non-success Foursquare HTTP responses before parsing response JSON or
creating AR venue state.

## Priority

1. Keep HTTP error responses out of the successful venue parsing path.
2. Reuse the existing bounded retry release for rejected responses.
3. Preserve the legacy Alamofire, Swift, API request, credential, and UI
   boundaries.

## Requirements

- R1. The venue search request must validate status codes in `200..<300`
  before `responseJSON` handles the body.
- R2. Status validation must use the existing Alamofire 4 request chain and
  must not add a second request or dependency.
- R3. Rejected status codes must reach the existing generic failure branch and
  bounded retry release without logging response bodies, URLs, credentials, or
  location details.
- R4. Successful venue parsing, coordinate validation, empty-result retry,
  credential lookup, request parameters, and AR/map rendering must remain
  unchanged.
- R5. Static contracts must reject validator removal, a widened status range,
  validation after `responseJSON`, duplicate requests, and weakened failure
  handling.
- R6. README, SECURITY, VISION, CHANGES, and AGENTS must describe the status
  boundary without claiming runtime or live-service validation.

## Non-Goals

- Changing the Foursquare endpoint, API version, parameters, credentials,
  attribution, response schema, retry delay, or request timeout behavior.
- Upgrading Alamofire, SwiftyJSON, Swift, iOS, CocoaPods, Xcode, ARKit, Mapbox,
  or other dependencies.
- Adding response-body logging, detailed server errors, telemetry, or user
  interface changes.
- Claiming compilation, signing, simulator/device behavior, or live Foursquare
  compatibility from this Linux environment.

## Implementation Units

### 1. Request Status Boundary

Files: `FoursquareARCamera/ViewController.swift`

- Insert the exact 2xx status validator between request construction and JSON
  response handling.
- Preserve the existing generic failure and bounded retry path.

### 2. Static Contract

Files: `scripts/check-baseline.sh`

- Scope request-chain checks to `getFoursquareLocations`.
- Require one venue request, one exact status validator, validator-before-body
  ordering, and the retained generic failure retry.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the non-2xx rejection boundary and the continuing platform/live
  validation limitations.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the validator, widen it to include redirects, move it after
  `responseJSON`, duplicate the request, and remove the failure retry; the
  static gate must reject each mutation.
- Run shell syntax, plist/workspace parsing, executable-mode verification,
  `git diff --check`, and intended-path secret and artifact scans.
- Take bounded exact-head push, pull-request, and code-scanning snapshots after
  push; do not start a polling or watch loop.

## Work Completed

- Chained Alamofire's exact `200..<300` status validator between the existing
  venue request and `responseJSON` handler.
- Preserved the existing request parameters, JSON parsing, coordinate checks,
  rendering, generic failure message, and bounded retry release.
- Added a function-scoped static contract for one request, one exact validator,
  validator-before-body ordering, and one generic failure retry.
- Documented the response status boundary and continuing legacy platform and
  live-service validation limits.

## Verification Completed

- The validator removal mutation failed with the one-request/validator/handler
  contract error.
- The status range mutation failed after widening the accepted range to
  `200..<400`.
- The validation ordering mutation failed after moving the validator below the
  JSON response handler.
- The duplicate request mutation failed after adding a second venue request.
- The failure retry mutation failed after replacing the bounded retry release
  with a warning-only branch.
- `make check`, `make lint`, `make test`, and `make build` passed the maintained
  static baseline; each correctly reported that local `xcodebuild` is
  unavailable.
- `sh -n scripts/check-baseline.sh`, Info.plist and workspace XML parsing,
  executable-mode verification, and `git diff --check` passed.
- Intended-path artifact and secret scans found no generated files or embedded
  credentials.
- The hosted pull-request check and code-scanning results are recorded against
  the exact pushed head in the external engineering tracker. Embedding that SHA
  here would create a new head without exact-head hosted evidence.
