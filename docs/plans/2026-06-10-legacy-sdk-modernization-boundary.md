# Foursquare AR Camera Legacy SDK Modernization Boundary

status: completed

## Context

The project is a preserved Swift 4.0 and iOS 11-era AR prototype. Its Xcode
project, CocoaPods workspace, ARKit/Core Location integration, Mapbox client,
Foursquare venue request shape, and third-party dependencies should not be
described as a current production baseline.

## Current Boundary

- `SWIFT_VERSION = 4.0` and `IPHONEOS_DEPLOYMENT_TARGET = 11.0` are the
  checked-in compiler and platform settings.
- The Podfile includes legacy CocoaPods dependencies and follows the
  CocoaLumberjack `master` branch rather than a reproducible release pin.
- `Podfile.lock` was generated with CocoaPods 1.3.1; modernization must record
  the replacement tool version and review the resulting dependency graph.
- The app uses the checked-in Foursquare venue search request and Mapbox SDK
  integration as historical sample behavior.
- Full functional verification requires a compatible macOS/Xcode/CocoaPods
  environment and a physical device for camera, AR, heading, and location
  behavior.
- Credential-free static validation lists the checked-in Xcode project; the
  workspace requires the generated Pods project after `pod install`.

## Modernization Sequence

1. Replace the mutable CocoaLumberjack branch with a reviewed release or commit,
   pin every CocoaPods dependency, and regenerate `Podfile.lock` with a
   documented CocoaPods version.
2. Move the project to a supported Swift language mode and raise deployment
   settings in a dedicated build-only change.
3. Replace or adapt deprecated AR/location, Mapbox, and venue API surfaces one
   integration at a time, preserving attribution and privacy boundaries.
4. Add device-level regression coverage for authorization, missing
   credentials, offline behavior, venue parsing, and AR annotation placement.
5. Re-run `make check` after each step and record the macOS/Xcode/device matrix
   used for functional verification.

## Verification

- `make check`
- `git diff --check`
