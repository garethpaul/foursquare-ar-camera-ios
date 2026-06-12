# Foursquare AR Camera Hosted Project Validation

status: completed

## Context

The repository has a dependency-free static maintenance gate, but it previously
had no hosted runner. Linux can verify the source and documentation contracts;
only macOS with Xcode can also prove the checked-in project metadata parses.
The CocoaPods workspace is intentionally not used because generated Pods files
are not committed.

## Contract

- Run `make check` for pushes, pull requests, and manual dispatches.
- Use a bounded `macos-15` job with cancellation for superseded runs.
- Grant only read access to repository contents.
- Pin the checkout action and disable persisted checkout credentials.
- Parse `FoursquareARCamera.xcodeproj` when `xcodebuild` is available without
  requiring credentials, signing, CocoaPods installation, or a device.
- Keep workflow structure enforced by the local baseline so duplicate or
  overriding security-sensitive YAML keys fail before push.

## Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- hostile workflow mutation checks
- `git diff --check`

Hosted Xcode validation remains narrower than a functional build. Camera, AR,
location authorization, Mapbox rendering, Foursquare requests, signing, and
physical-device behavior still require an era-compatible Apple toolchain and
controlled local credentials.
