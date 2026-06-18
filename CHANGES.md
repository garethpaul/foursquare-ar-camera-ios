# Changes

## 2026-06-18

- Normalize venue text before rendering, rejecting blank required names and
  retaining the neutral category fallback through an executable Swift policy.

## 2026-06-17

- Bound venue distance conversion before integer rendering and added an
  executable Swift policy harness for normal and hostile values.

## 2026-06-16

- Extracted the exact Foursquare final-response endpoint predicate into app
  production source and added a standalone Swift harness that executes the same
  policy against accepted and hostile URLs when `swiftc` is available.
- Extended the static baseline to require app-target membership, production
  delegation, harness wiring, and complete endpoint-case coverage.

## 2026-06-15

- Foursquare venue networking uses a 15-second request timeout and a 30-second resource timeout.
- Refused redirects for credential-bearing Foursquare venue requests before
  URLSession can forward their query parameters.
- Added dedicated-session, redirect-policy, request-routing, documentation, and
  completed-evidence contracts.

## 2026-06-14

- Required the exact final HTTPS Foursquare API endpoint before response media
  validation or JSON handling.
- Added scheme, host, userinfo, port, path, fragment, ordering, retry,
  documentation, and completed-evidence contracts for response provenance.

## 2026-06-13

- Made static verification independent of the caller's working directory by
  resolving the baseline checker from the loaded Makefile.
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
