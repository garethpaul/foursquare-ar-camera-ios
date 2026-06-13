# AGENTS.md

## Repository purpose

`garethpaul/foursquare-ar-camera-ios` is a preserved Swift 4.0 and iOS 11 AR camera sample that combines ARKit, Core Location, Mapbox, and the Foursquare venue API.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Podfile` - CocoaPods dependency definition
- `FoursquareARCamera.xcodeproj` - Xcode project
- `FoursquareARCamera.xcworkspace` - Xcode workspace
- `FoursquareARCamera` - repository source or sample assets
- `ref` - repository source or sample assets

## Development commands

- Install dependencies: `pod install`
- Full baseline: `make check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build gate: `make build`
- Local Apple development: `open FoursquareARCamera.xcworkspace`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: Swift (16).
- Use the CocoaPods workspace when present; update `Podfile.lock` only with an intentional dependency change.
- Preserve legacy Xcode project settings and signing assumptions unless the change is explicitly about modernization.

## Testing guidance

- No dedicated test files were detected. The `lint`, `test`, and `build` targets delegate to the maintained static `make check` baseline rather than compiling or exercising app behavior.
- Hosted macOS CI additionally parses the checked-in Xcode project; it does not install Pods, sign or launch the app, call live APIs, or test camera, AR, Mapbox, and location behavior.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- Detected references to Foursquare, Mapbox. Keep API keys, OAuth credentials, tokens, and account-specific values in local configuration only.
- Required local build settings: `MAPBOX_ACCESS_TOKEN`, `FOURSQUARE_CLIENT_ID`, and `FOURSQUARE_CLIENT_SECRET`.
- Do not commit `.xcconfig` files, API credentials, signing material, camera output, or user location data.
- Avoid logging detailed location coordinates, camera frames, Foursquare credentials, Mapbox tokens, or raw venue responses.
- Keep the dedicated connectivity probe limited to exact HTTP 204 success.
- Keep Core Location updates gated on authorization before starting AR venue lookup behavior.
- Keep location manager setup and heading forwarding resilient when optional Core Location state is unavailable.
- Reject non-finite or out-of-range venue coordinates, and reject non-finite or negative distances, before creating AR nodes or map annotations.
- Keep credential, request, malformed-response, and empty-response retries bounded by the documented cooldown.
- Require a 2xx Foursquare response status before JSON parsing, and keep
  rejected responses on the generic no-body-log retry path.
- Require the exact JSON response media type after status validation and before
  response handling.
- Treat Swift, CocoaPods, Mapbox, ARKit/Core Location, and Foursquare API modernization as staged, device-verified work; update `Podfile.lock` only with an intentional dependency and CocoaPods toolchain review.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
