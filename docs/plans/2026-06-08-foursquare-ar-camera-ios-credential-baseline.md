# Foursquare AR Camera iOS Credential Baseline

date: 2026-06-08
status: completed

## Context

Foursquare AR Camera iOS is a legacy Swift AR prototype that combines camera
access, location data, Mapbox, and Foursquare venue search. The highest-risk
maintenance surfaces are committed credentials, tracked machine artifacts, and
detailed location logs.

## Completed Scope

- Replaced the committed Mapbox token with the `MAPBOX_ACCESS_TOKEN` build
  setting.
- Added `FOURSQUARE_CLIENT_ID` and `FOURSQUARE_CLIENT_SECRET` Info.plist build
  settings and guarded Foursquare requests when credentials are missing.
- Stopped constructing a Foursquare URL string with interpolated credentials.
- Removed detailed coordinate/location debug logs from the view controller.
- Switched the reachability probe to HTTPS.
- Removed tracked `.DS_Store` files and the tracked `mapbox_access_token`
  placeholder while keeping those paths ignored.
- Added `scripts/check-baseline.sh` and `make check` for repeatable static
  verification.

## Verification

- `make check`

## Follow-Ups

- Run `xcodebuild test` or Xcode's test action on a macOS machine with the
  legacy CocoaPods toolchain installed.
- Verify AR, camera, location, Mapbox, and Foursquare behavior on a physical
  device with local credentials configured outside source control.
- Modernize dependencies only in a dedicated migration with lockfile updates.
