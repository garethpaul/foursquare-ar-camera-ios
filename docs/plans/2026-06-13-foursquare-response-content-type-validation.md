---
title: Foursquare Response Content Type Validation
type: security
status: completed
date: 2026-06-13
---

# Foursquare Response Content Type Validation

## Summary

Require successful Foursquare venue responses to declare `application/json`
before Alamofire invokes the JSON response handler.

## Priority

1. Reject successful non-JSON representations before venue parsing.
2. Preserve the existing single-request, 2xx validation, and retry behavior.
3. Keep the legacy Swift 4, Alamofire, CocoaPods, AR, location, and credential
   boundaries unchanged.

## Requirements

- R1. The venue request chain must call
  `.validate(contentType: ["application/json"])` exactly once.
- R2. Content-type validation must run after the exact 2xx status validator and
  before the single `responseJSON` handler.
- R3. Missing or incompatible content types must reach the existing generic
  failure retry path without logging response content.
- R4. Static contracts must reject validator removal, widened media allowlists,
  reordered validation, duplicate requests or handlers, weakened retry
  behavior, documentation drift, or incomplete plan evidence.
- R5. README, SECURITY, VISION, CHANGES, and AGENTS must describe the exact JSON
  response boundary without claiming live API or device validation.
- R6. The completed plan must record actual local, mutation, and hosted
  verification evidence.

## Non-Goals

- Changing the Foursquare endpoint, parameters, credentials, API version, or
  success status range.
- Supporting vendor JSON, text/json, HTML, XML, or content sniffing.
- Changing venue parsing, coordinate validation, AR rendering, map annotations,
  retries, or logging.
- Updating Swift, iOS, Alamofire, CocoaPods, Mapbox, or project metadata.
- Claiming compilation, signing, simulator/device, camera, location, or live
  Foursquare validation from this Linux host.

## Implementation Units

### 1. Alamofire Media Validator

Files: `FoursquareARCamera/ViewController.swift`

- Add the exact JSON content-type validator between status validation and the
  response handler.

### 2. Static Contracts

Files: `scripts/check-baseline.sh`

- Require one request, one status validator, one JSON media validator, one
  response handler, exact ordering, the failure retry, documentation, and
  completed evidence.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the media-type boundary and continuing platform/live-validation
  limits.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the validator, widen the allowlist, move it after `responseJSON`,
  duplicate the handler, remove failure retry, and regress plan evidence; each
  mutation must be rejected.
- Run shell syntax, plist/workspace XML parsing, executable-mode checks,
  `git diff --check`, and intended-file secret/artifact scans.
- Take bounded exact-head push, pull-request, and code-scanning snapshots after
  push; do not start a watch loop.

## Work Completed

- Added the exact Alamofire `application/json` content-type validator between
  the existing 2xx validator and single JSON response handler.
- Preserved the generic failure retry so rejected status or media metadata does
  not log response content or create immediate request loops.
- Extended the static request-chain contract and repository guidance for exact
  media validation and continuing platform/live-validation limits.

## Verification Completed

- All four Make gates passed the maintained static baseline.
- The validator removal mutation failed the single-chain contract.
- The media allowlist mutation failed the exact validator contract.
- The validation ordering mutation failed after a valid status/media line swap.
- The duplicate handler mutation failed the single-handler contract.
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
