# foursquare-ar-camera-ios

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/foursquare-ar-camera-ios` is an Apple platform application or Swift sample. AR Camera using Foursquare API. 

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Swift (16).

## Repository Contents

- `Podfile` - Apple platform dependency metadata
- `CHANGES.md` - concise history of maintenance changes
- `Makefile` - local verification entry point
- `FoursquareARCamera` - source or example code
- `FoursquareARCamera.xcodeproj` - Xcode project file
- `FoursquareARCamera.xcworkspace` - CocoaPods workspace to open after dependency install
- `Podfile.lock` - Apple platform dependency metadata
- `ReadMe.md` - project overview and local usage notes
- `SECURITY.md` - security reporting and disclosure guidance
- `scripts/check-baseline.sh` - static credential, privacy, and project-shape checks
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: FoursquareARCamera
- Dependency and build manifests: Podfile, Podfile.lock
- Entry points or build surfaces: FoursquareARCamera.xcworkspace, FoursquareARCamera.xcodeproj
- Test-looking files: no obvious test files detected

## Getting Started

### Prerequisites

- Git
- macOS with Xcode for building Apple platform projects
- CocoaPods if dependencies need to be installed

### Setup

```bash
git clone https://github.com/garethpaul/foursquare-ar-camera-ios.git
cd foursquare-ar-camera-ios
pod install
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Open `FoursquareARCamera.xcworkspace` in Xcode after `pod install`, choose the app or sample scheme, and run it on a physical device for AR/camera/location behavior.
- Configure `MAPBOX_ACCESS_TOKEN`, `FOURSQUARE_CLIENT_ID`, and `FOURSQUARE_CLIENT_SECRET` as local build settings, for example through an untracked `.xcconfig` file or Xcode scheme environment.

## Testing and Verification

Run the static baseline:

```bash
make lint
make test
make build
make check
```

The `lint`, `test`, and `build` targets currently delegate to the static
baseline so the repository has a consistent local gate even when Xcode is not
installed. The baseline verifies that credentials are build settings, tracked
machine artifacts are absent, location logs avoid detailed coordinates, and the
venue mask asset is not force-unwrapped. The workspace can be listed when
`xcodebuild` is installed. The venue tap interaction guard keeps one tap
recognizer on the scene and skips nodes without highlight materials. Location
and heading updates start only after Core Location authorization is available.
Debug info label updates avoid force-unwrapping optional label text when partial
AR state is available. Reachability setup avoids force-unwrapping initialization
before showing offline state. FSQView nib outlet setup is guarded before venue
card subviews are added.
For functional verification, use Xcode's test action or `xcodebuild test` with
the appropriate scheme and destination.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- Detected references to Foursquare, Mapbox. Keep API keys, OAuth credentials, tokens, and account-specific values in local configuration only.
- Required local build settings: `MAPBOX_ACCESS_TOKEN`, `FOURSQUARE_CLIENT_ID`, and `FOURSQUARE_CLIENT_SECRET`.
- Do not commit `.xcconfig` files, API credentials, signing material, camera output, or user location data.

## Security and Privacy Notes

- Review changes touching authentication or token handling; examples from the scan include FoursquareARCamera/AppDelegate.swift, FoursquareARCamera/Source/Views/SceneLocationView.swift, FoursquareARCamera/ViewController.swift.
- Review changes touching external API calls or credential-adjacent configuration; examples from the scan include FoursquareARCamera/AppDelegate.swift, FoursquareARCamera/Source/Helpers/CGPoint+Extensions.swift, FoursquareARCamera/Source/Helpers/CLLocation+Extensions.swift, FoursquareARCamera/Source/Helpers/FloatingPoint+Radians.swift, and 6 more.
- Review changes touching network requests, sockets, or service endpoints; examples from the scan include FoursquareARCamera/Info.plist, FoursquareARCamera/Source/Reachability.swift, FoursquareARCamera/ViewController.swift, Podfile.
- Review changes touching mobile permissions or privacy-sensitive device data; examples from the scan include FoursquareARCamera/Info.plist, FoursquareARCamera/Source/Helpers/CLLocation+Extensions.swift, FoursquareARCamera/Source/Helpers/LocationManager.swift, FoursquareARCamera/Source/Helpers/LocationNode.swift, and 4 more.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include FoursquareARCamera/Info.plist, FoursquareARCamera/Source/Helpers/LocationNode.swift, FoursquareARCamera/Source/Helpers/UIImage-Extension.swift, FoursquareARCamera/ViewController.swift.
- Avoid logging detailed location coordinates, camera frames, Foursquare credentials, Mapbox tokens, or raw venue responses.
- Keep Core Location updates gated on authorization before starting AR venue
  lookup behavior.
- Keep debug info label updates resilient when only position, heading, or
  timestamp data is available.
- Keep reachability setup resilient so network-check initialization cannot crash
  before the offline alert path.
- Keep FSQView nib outlet setup resilient so missing or miswired venue card
  views do not crash rendering.

## Maintenance Notes

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make lint`, `make test`, `make build`, and `make check` before pushing
  changes that touch credentials, location/camera behavior, CocoaPods, or
  project files.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `docs/plans/2026-06-09-foursquare-ar-mask-asset-guard.md` for venue mask
  asset guardrails.
- See `docs/plans/2026-06-09-foursquare-ar-tap-interaction-guard.md` for venue
  tap interaction guardrails.
- See `docs/plans/2026-06-09-location-authorization-start-guard.md` for
  Core Location authorization startup guardrails.
- See `docs/plans/2026-06-09-info-label-text-guard.md` for debug info label
  text guardrails.
- See `docs/plans/2026-06-09-reachability-init-guard.md` for reachability
  initialization guardrails.
- See `docs/plans/2026-06-09-make-gate-aliases.md` for local verification
  target guardrails.
- See `docs/plans/2026-06-09-fsq-view-nib-outlet-guard.md` for venue card nib
  outlet guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
