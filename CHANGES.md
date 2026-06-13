# Changes

## 2026-06-13

- Required the dedicated reachability probe to return exactly HTTP 204.
- Required the exact application/json response media type before Foursquare
  JSON response handling.
- Added request-chain ordering, retry, documentation, and evidence contracts for
  media validation.
- Required a 2xx Foursquare venue response before JSON parsing and routed
  rejected statuses through the existing generic bounded retry path.
- Added a scoped static contract for request count, status range, ordering, and
  failure handling.
- Replaced the mutable CocoaLumberjack `master` selector with the exact Swift 4
  commit already recorded in `Podfile.lock`.
- Aligned lockfile source metadata without changing resolved pod versions and
  documented the remaining legacy Podfile-checksum regeneration requirement.

## 2026-06-12

- Added a bounded, least-privilege macOS GitHub Actions workflow that runs the
  maintenance baseline and parses the checked-in Xcode project.
- Enforced the workflow structurally so duplicate jobs, permissions, checkout
  settings, credential overrides, extra actions, or extra run steps fail local
  verification.
- Removed the empty `ReadMe.md` case-variant that overwrote the maintained
  `README.md` on default case-insensitive macOS filesystems.
- Aligned the Podfile with the checked-in `FoursquareARCamera` native target
  without changing the legacy dependency lockfile.

## 2026-06-10

- Rejected non-finite, out-of-range venue coordinates and negative distances
  before creating AR nodes or map annotations.
- Documented the Swift 4.0, iOS 11, CocoaPods, Mapbox, ARKit/Core Location, and
  Foursquare venue integration boundary with a staged modernization sequence,
  including the CocoaPods 1.3.1 lockfile baseline.

## 2026-06-09

- Bounded Foursquare venue lookup retries after missing credentials, request
  failures, or empty/malformed successful responses.
- Guarded map annotation updates so optional user and debug location markers are
  not force-unwrapped.
- Removed LocationManager force unwraps during manager setup and heading
  forwarding.
- Guarded FSQView nib outlet setup so missing or miswired venue card views do
  not crash rendering.
- Added `make lint`, `make test`, and `make build` aliases so local verification
  has the expected pre-push gate targets in addition to `make check`.
- Guarded debug info label updates so optional label text is not force-unwrapped
  when only partial AR state is available.
- Guarded Reachability initialization so the offline check cannot crash before
  displaying network state.

## 2026-06-08

- Gated Core Location heading and location updates on authorization before
  starting AR venue lookup behavior.
- Moved Mapbox and Foursquare credentials to local build settings.
- Removed tracked `.DS_Store` files and the empty `mapbox_access_token`
  placeholder.
- Removed detailed location debug logs from the venue lookup flow.
- Hardened venue response parsing and reachability checks.
- Replaced app/runtime `print` diagnostics with logger-backed calls.
- Guarded Foursquare venue rendering when the mask asset is missing.
- Guarded AR venue tap handling so one recognizer is installed and tapped nodes
  without materials do not crash highlighting.
- Added `make check` and `scripts/check-baseline.sh` for static credential,
  privacy, and project-shape verification.
