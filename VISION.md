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

- `scripts/check-baseline.sh` and `make check` verify credential placeholders,
  local artifact ignores, Info.plist XML, and workspace visibility.
- `MAPBOX_ACCESS_TOKEN`, `FOURSQUARE_CLIENT_ID`, and
  `FOURSQUARE_CLIENT_SECRET` are local build settings.
- detailed location logs are avoided in the venue lookup and scene-location
  delegate flow.
- Venue rendering keeps working without force-unwrapping the optional
  `fsqMask` asset.
- Venue tap handling installs one gesture recognizer and skips nodes without
  highlight materials.
- `.DS_Store` and `mapbox_access_token` are ignored and not tracked.

Next priorities:

- Verify AR, camera, location, Mapbox, and Foursquare behavior on a physical device
- Add tests or manual checklists for missing credentials and API failure states
- Keep venue tap handling resilient when SceneKit node shapes change
- Modernize Swift, dependencies, AR/location APIs, and project settings in a
  dedicated pass
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
