# foursquare-ar-camera-ios

## Overview

`garethpaul/foursquare-ar-camera-ios` is an Apple platform application or Swift sample. AR Camera using Foursquare API. 

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Swift (16).

## Repository Contents

- `Podfile` - Apple platform dependency metadata
- `FoursquareARCamera` - source or example code
- `FoursquareARCamera.xcodeproj` - Xcode project file
- `Podfile.lock` - Apple platform dependency metadata
- `ReadMe.md` - project overview and local usage notes
- `SECURITY.md` - security reporting and disclosure guidance
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: FoursquareARCamera
- Dependency and build manifests: Podfile, Podfile.lock
- Entry points or build surfaces: FoursquareARCamera.xcodeproj
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

- Open `FoursquareARCamera.xcodeproj` in Xcode, choose the app or sample scheme, and run it on the matching simulator/device.

## Testing and Verification

- Xcode's test action or `xcodebuild test` with the appropriate scheme and destination

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- Detected references to Foursquare, Mapbox. Keep API keys, OAuth credentials, tokens, and account-specific values in local configuration only.

## Security and Privacy Notes

- Review changes touching authentication or token handling; examples from the scan include FoursquareARCamera/AppDelegate.swift, FoursquareARCamera/Source/Views/SceneLocationView.swift, FoursquareARCamera/ViewController.swift.
- Review changes touching external API calls or credential-adjacent configuration; examples from the scan include FoursquareARCamera/AppDelegate.swift, FoursquareARCamera/Source/Helpers/CGPoint+Extensions.swift, FoursquareARCamera/Source/Helpers/CLLocation+Extensions.swift, FoursquareARCamera/Source/Helpers/FloatingPoint+Radians.swift, and 6 more.
- Review changes touching network requests, sockets, or service endpoints; examples from the scan include FoursquareARCamera/Info.plist, FoursquareARCamera/Source/Reachability.swift, FoursquareARCamera/ViewController.swift, Podfile.
- Review changes touching mobile permissions or privacy-sensitive device data; examples from the scan include FoursquareARCamera/Info.plist, FoursquareARCamera/Source/Helpers/CLLocation+Extensions.swift, FoursquareARCamera/Source/Helpers/LocationManager.swift, FoursquareARCamera/Source/Helpers/LocationNode.swift, and 4 more.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include FoursquareARCamera/Info.plist, FoursquareARCamera/Source/Helpers/LocationNode.swift, FoursquareARCamera/Source/Helpers/UIImage-Extension.swift, FoursquareARCamera/ViewController.swift.

## Maintenance Notes

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.

