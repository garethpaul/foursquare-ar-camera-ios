# Visible Core Location Lifecycle

status: completed

## Context

`ViewController` starts and pauses `SceneLocationView` with its visible view
lifecycle. `SceneLocationView.pause()` stopped the AR session and its estimate
timer, but the owned `CLLocationManager` started GPS and compass delivery during
initialization and never stopped either service. Leaving the AR screen could
therefore continue privacy-sensitive sensor delivery and power use even though
the scene no longer consumed updates.

Apple directs clients to call `stopUpdatingLocation()` and
`stopUpdatingHeading()` whenever those events are no longer needed so the
system can disable related hardware, then restart them when needed again.

## Requirements

- R1. Constructing `LocationManager` must configure and request authorization
  without starting location or heading hardware.
- R2. Starting the visible AR scene must request update ownership and start both
  services only when authorized.
- R3. Pausing the AR scene must revoke update ownership and stop location and
  heading delivery before pausing AR or invalidating the estimate timer.
- R4. An authorization callback may start updates only while the visible scene
  still owns them.
- R5. A denied or restricted authorization state must stop both services.
- R6. Existing current-location, heading, AR session, timer, venue lookup, and
  authorization behavior must remain otherwise unchanged.
- R7. Portable contracts must reject missing, late, commented-out, or automatic
  initialization updates.

## Primary Sources

- Apple, `CLLocationManager.stopUpdatingLocation()`:
  https://developer.apple.com/documentation/corelocation/cllocationmanager/stopupdatinglocation%28%29
- Apple, `CLLocationManager.stopUpdatingHeading()`:
  https://developer.apple.com/documentation/corelocation/cllocationmanager/stopupdatingheading%28%29
- Apple, `CLLocationManager.startUpdatingLocation()`:
  https://developer.apple.com/documentation/corelocation/cllocationmanager/startupdatinglocation%28%29

## Implementation Units

### U1. Explicit manager ownership

**File:** `FoursquareARCamera/Source/Helpers/LocationManager.swift`

Track whether the AR scene requests updates, centralize authorized start and
unconditional stop operations, and prevent late authorization callbacks from
restarting a paused scene.

### U2. Scene lifecycle wiring

**File:** `FoursquareARCamera/Source/Views/SceneLocationView.swift`

Acquire Core Location before starting the AR session and release it before AR
pause and timer invalidation.

### U3. Portable regression and guidance

**Files:** `scripts/check-baseline.sh`, `AGENTS.md`, `README.md`, `SECURITY.md`,
`VISION.md`, `CHANGES.md`, and this plan.

Add method-scoped comment-aware ordering checks, maintained documentation, and
completed verification evidence.

## Test Scenarios

- Manager initialization requests permission but does not start hardware.
- Visible scene run starts authorized location and heading delivery.
- Scene pause stops both services before other pause side effects.
- Authorization granted while visible starts both services.
- Authorization granted after pause does not restart services.
- Denied or restricted authorization stops both services.
- Commented-out lifecycle calls and reordered stop behavior fail verification.

## Scope Boundaries

- Do not change credentials, request URLs, venue parsing, retry timing, AR node
  placement, camera behavior, CocoaPods, signing, or deployment metadata.
- Do not retrieve or record historical secret-alert values.
- Do not claim local AR, camera, Core Location, or Xcode execution when the
  Apple toolchain is unavailable.

## Verification Completed

- All four Make gates passed from the checkout and `make check` passed through
  the absolute Makefile path from `/tmp`.
- `python3 -m py_compile scripts/check-venue-request-timeouts.py`, all maintained
  runner shell syntax checks, and `git diff --check` passed.
- Eight isolated hostile mutations were rejected for automatic initialization,
  missing start or stop ownership, late stop ordering, authorization restart,
  line-comment suppression, and block-comment suppression.
- Generated-artifact, protected-metadata, and changed-line credential audits
  found no unintended additions.
- Local `swiftc` and xcodebuild was unavailable; hosted macOS remains
  authoritative for executable Swift policy tests and Xcode project parsing.
