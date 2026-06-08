---
title: Issue 4 HTTPS Reachability Probe
type: fix
status: active
date: 2026-06-08
origin: https://github.com/garethpaul/foursquare-ar-camera-ios/issues/4
execution: code
---

# Issue 4 HTTPS Reachability Probe

## Summary

Move the reachability probe off plain HTTP so the app does not use a cleartext runtime network check.

## Problem Frame

Issue #4 was filed from the public repository review because `FoursquareARCamera/Source/Reachability.swift` checks connectivity with `http://google.com/`. The rest of the app's Foursquare API request already uses HTTPS, so the reachability probe is the remaining cleartext runtime endpoint found by the review.

## Requirements

- R1. `FoursquareARCamera/Source/Reachability.swift` must not contain `http://google.com/`.
- R2. The reachability check must continue to send a `HEAD` request and expect status code `200`.
- R3. The change must avoid CocoaPods, Xcode project, Swift migration, AR, Mapbox, or Foursquare API changes.
- R4. The PR must reference `https://github.com/garethpaul/foursquare-ar-camera-ios/issues/4`.

## Implementation Unit

### U1. HTTPS Probe URL

- **Goal:** Replace the cleartext Google reachability URL with an HTTPS URL that is compatible with the existing `HEAD` and `200` status check.
- **Files:** `FoursquareARCamera/Source/Reachability.swift`
- **Test Scenarios:** Verify no cleartext Google probe remains, the request method remains `HEAD`, and the status-code check remains `200`.
- **Verification:** `rg -n "http://google\\.com|https://www\\.google\\.com|HTTPMethod|statusCode == 200" FoursquareARCamera/Source/Reachability.swift` and `git diff --check`.

## Risks

- This workspace does not provide `xcodebuild` or CocoaPods, so compile and simulator verification are unavailable locally.
- The reachability helper still uses synchronous legacy networking. Modernizing that should be a separate behavior-aware pass.
