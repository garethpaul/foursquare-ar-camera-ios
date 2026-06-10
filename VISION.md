## Foursquare AR Camera iOS Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Foursquare AR Camera iOS is a Swift AR camera app that uses location, Mapbox,
SceneKit, and the Foursquare API to display nearby food venues in augmented
reality.

The repository is useful as a preserved location-based AR prototype with a
compass map, venue annotations, and Foursquare attribution. Setup context lives
in [`ReadMe.md`](ReadMe.md).

The goal is to keep the AR venue lookup flow understandable while making
location privacy, API credentials, and platform modernization explicit.

The current focus is:

Priority:

- Preserve the AR scene, compass, and nearby venue annotation flow
- Keep Foursquare and Mapbox credential handling visible
- Avoid committing real API credentials, access tokens, or user location data
- Maintain attribution and network reachability behavior

Current baseline:

- `scripts/check-baseline.sh`, `make lint`, `make test`, `make build`, and
  `make check` verify credential placeholders, local artifact ignores,
  Info.plist XML, and workspace visibility.
- `MAPBOX_ACCESS_TOKEN`, `FOURSQUARE_CLIENT_ID`, and
  `FOURSQUARE_CLIENT_SECRET` are local build settings.
- detailed location logs are avoided in the venue lookup and scene-location
  delegate flow.
- Venue rendering keeps working without force-unwrapping the optional
  `fsqMask` asset.
- Venue tap handling installs one gesture recognizer and skips nodes without
  highlight materials.
- FSQView nib setup guards missing outlets before venue card subviews are added.
- Map annotation updates avoid force-unwrapping optional annotations while user
  and debug location markers change.
- Location and heading updates start only after Core Location authorization is
  already available or newly granted.
- Location manager setup avoids force-unwrapping optional manager or heading
  state while forwarding delegate updates.
- Debug info label updates avoid force-unwrapping optional label text when
  partial AR state is available.
- Reachability setup avoids force-unwrapping initialization before the offline
  alert path.
- Foursquare venue lookup retries use a bounded cooldown when credentials are
  missing, requests fail, or successful responses contain no valid venues.
- Venue response coordinates and distances are finite and range-checked before
  AR nodes or map annotations are created.
- The local Makefile exposes lint, test, build, and check targets for a stable
  pre-push gate.
- `.DS_Store` and `mapbox_access_token` are ignored and not tracked.
- Swift 4.0 and iOS 11 remain the checked-in legacy compiler and deployment
  boundary; this repository does not claim a current production SDK baseline.

Next priorities:

- Verify AR, camera, location, Mapbox, and Foursquare behavior on a physical device
- Add tests or manual checklists for missing credentials and API failure states
- Keep venue tap handling resilient when SceneKit node shapes change
- Keep debug overlays resilient when AR position, heading, and time values
  update independently
- Keep Core Location authorization gating intact when changing AR startup
- Preserve the LocationManager optional-state guard when changing Core Location
  setup or heading forwarding
- Keep reachability setup optional-safe when changing network checks
- Preserve the FSQView nib outlet guard when changing venue card rendering
- Preserve the map annotation optional-state guard when changing map tracking
  overlays
- Preserve bounded Foursquare venue lookup retries when changing API failure
  handling
- Keep local verification targets available even while full Xcode testing needs
  a macOS toolchain
- Modernize Swift, dependencies, AR/location APIs, and project settings in a
  dedicated pass
- Pin CocoaPods dependencies before changing Swift, Mapbox, ARKit/Core
  Location, or Foursquare API behavior
- Add safer error handling for API failures and missing credentials

Contribution rules:

- One PR = one focused AR, location, API, build, or documentation change.
- Verify location and AR behavior on a physical device when changing core flow.
- Preserve Foursquare attribution and credential placeholders.
- Keep generated signing files and local paths out of git.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

The app uses camera, location, and venue search data. It must not upload camera
frames, store user location histories, or log API credentials.

Location-based requests should be user-visible and use documented configuration.

## What We Will Not Merge (For Now)

- Hardcoded real Foursquare or Mapbox credentials
- Background location tracking or camera data upload
- Broad dependency migrations bundled with AR behavior changes
- Venue API changes without attribution and failure-handling notes

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
