# Foursquare AR Tap Interaction Guard

date: 2026-06-09
status: completed

## Context

The venue rendering loop added a new tap recognizer for every venue returned by
Foursquare, and tap highlighting force-unwrapped the tapped node geometry and
first material. A repeated venue response could stack recognizers, while taps on
SceneKit nodes without materials could crash the interaction path.

## Completed Scope

- Added a one-time venue tap recognizer guard for the scene view.
- Replaced indexed hit-result access with an optional first-hit guard.
- Guarded tapped node material lookup before starting the highlight animation.
- Extended the static baseline and docs to preserve the tap interaction
  boundary.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode build and device verification are still skipped locally because
`xcodebuild` is not installed in this environment.
