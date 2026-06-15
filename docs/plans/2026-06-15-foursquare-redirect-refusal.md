---
title: Foursquare Redirect Refusal
type: security
status: in_progress
date: 2026-06-15
---

# Foursquare Redirect Refusal

## Summary

Refuse HTTP redirects for the credential-bearing Foursquare venue request so
URLSession cannot forward its query parameters to another destination.

## Priority

1. Prevent Foursquare client credentials from being forwarded across redirects.
2. Preserve exact final-response URL, status, media-type, and bounded retry
   validation as defense in depth.
3. Keep the pinned Swift 4, Alamofire 4.5.1, CocoaPods, and iOS 11 boundaries.

## Requirements

- R1. Venue lookup must use one dedicated `SessionManager` whose Alamofire
  redirect delegate returns `nil` for every redirect.
- R2. The dedicated manager must issue the existing single venue request; the
  global Alamofire manager and unrelated URLSession traffic must not change.
- R3. A refused redirect must flow through the existing non-2xx validation and
  generic bounded retry without logging URLs, credentials, or response bodies.
- R4. The exact final URL validator must remain after status validation and
  before media validation and JSON handling.
- R5. Static contracts must reject manager removal, redirect-policy weakening,
  fallback to the global request helper, chain duplication, retry weakening,
  documentation drift, and incomplete plan evidence.
- R6. The completed plan must record actual local, mutation, and hosted
  verification evidence without claiming unavailable Apple-platform execution.

## Non-Goals

- Rotating credentials or changing their local configuration mechanism.
- Changing the Foursquare endpoint, parameters, API version, success status
  range, JSON media allowlist, response schema, retry delay, or UI behavior.
- Updating Swift, iOS, Alamofire, CocoaPods, Mapbox, or project metadata.
- Claiming compilation, signing, simulator/device, camera, location, or live
  Foursquare validation from this Linux host.

## Implementation Units

### 1. Dedicated Redirect-Refusing Session

Files: `FoursquareARCamera/ViewController.swift`

- Construct one private `SessionManager` with the default Alamofire headers.
- Set `taskWillPerformHTTPRedirection` to return `nil`.
- Issue venue requests through that manager.

### 2. Static Contracts

Files: `scripts/check-baseline.sh`

- Require the dedicated manager, exact redirect refusal, single request chain,
  existing validation ordering, generic failure retry, and completed evidence.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record redirect refusal for credential-bearing venue requests and the
  continuing legacy platform and live-validation limits.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` from the
  repository root, plus `make check` through the absolute Makefile path from an
  external directory.
- Remove the dedicated manager, permit the redirected request, fall back to
  `Alamofire.request`, duplicate the request, remove final URL validation,
  weaken failure retry, and regress completed evidence; each mutation must be
  rejected.
- Run shell syntax, plist/workspace XML parsing, executable-mode checks,
  `git diff --check`, and intended-file secret and artifact scans.
- Take one bounded exact-head pull-request and code-scanning snapshot after
  push; do not start a watch loop.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and validation.
