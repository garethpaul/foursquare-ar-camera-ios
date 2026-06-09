# Location Authorization Start Guard

date: 2026-06-09
status: completed

## Context

`LocationManager` started heading and location updates during initialization
before confirming that Core Location authorization was already available. On a
fresh install, that could start AR venue lookup behavior before the user had
granted location access.

## Completed Scope

- Added a helper that treats only `authorizedAlways` and `authorizedWhenInUse`
  as valid states for location updates.
- Requested when-in-use authorization before starting updates in initialization.
- Deferred heading and location updates until authorization is already present
  or newly granted through `didChangeAuthorization`.
- Extended the static baseline and docs to preserve the startup authorization
  boundary.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode build and device verification are still skipped locally because
`xcodebuild` is not installed in this environment.
