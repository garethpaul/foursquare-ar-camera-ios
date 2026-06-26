# Changes

## 2026-06-26T12:34:00Z — P1 correctness/privacy — cycle: request location boundary

### Summary
Rejected invalid current-location coordinates before the app can claim venue
lookup ownership or construct a credential-bearing Foursquare request.

### Work completed
- Added a Foundation-only finite geographic coordinate policy to the app target.
- Applied the policy before lookup generation acquisition and request parameters.
- Kept invalid-location diagnostics free of coordinate values.
- Added an executable production-policy harness and seven hostile mutations.
- Updated security, verification, contributor, and roadmap guidance.

### Threads
- None; the focused request boundary was implemented directly.

### Files changed
- `FoursquareRequestLocationPolicy.swift`, `ViewController.swift`, and the Xcode
  project — production policy, ordering, and app-target membership.
- `Tests/`, `scripts/`, and `Makefile` — executable and static regressions.
- `README.md`, `SECURITY.md`, `VISION.md`, `AGENTS.md`, and this changelog —
  maintained boundary guidance.
- `docs/plans/2026-06-26-foursquare-request-location-boundary.md` — completed
  implementation and local evidence.

### Validation
- RED: `make check` rejected the missing production policy.
- GREEN: repository-root and external-directory `make check` passed the static
  baseline; this host has no `swiftc` or `xcodebuild`.
- All six production Swift harnesses passed in a network-disabled Swift 5.10
  container.
- Seven focused hostile mutations were rejected.

### Blockers
- Xcode project parsing and physical-device AR, Core Location, Mapbox, and live
  Foursquare behavior require hosted macOS or a compatible device environment.

## 2026-06-26T03:06:41Z — P1 lifecycle/correctness — cycle: reachability presentation ownership

### Summary
Bound asynchronous offline-alert presentation to the current visible AR scene
so hidden or superseded reachability callbacks cannot present stale UI.

### Work completed
- Added a Swift 4-compatible visible-generation state.
- Moved reachability probe startup from `viewDidLoad` to `viewWillAppear`.
- Invalidated presentation ownership from `viewWillDisappear`.
- Added a fifth standalone production-state harness and hostile contracts.

### Threads
- None; the focused lifecycle change was implemented directly.

### Files changed
- `ViewController.swift`, `FoursquareReachabilityPresentationState.swift`, the
  Xcode project, harness/Make/static gates, guidance, and implementation plans.

### Validation
- RED: the Swift harness failed because production presentation state was missing.
- GREEN: current, disappeared, superseded, and replacement generations pass.
- All five production Swift harnesses passed in a network-disabled Swift 5.10 container.
- The canonical static gate passed and rejected four hostile presentation mutations.
- `make lint`, `make test`, `make build`, and `make check` passed through the
  container-backed Swift compiler/execution adapter.
- Hosted Check runs `28214619678` and `28214620695` and CodeQL run
  `28214619620` passed on the reviewed head.
- Codex review was attempted but blocked by OpenAI API HTTP 401. Manual review
  found and fixed two trailing spaces in design links; no runtime finding remained.

### Bugs / findings
- P1: the `viewDidLoad` probe could present an offline alert after scene departure
  or during a later appearance.

### Blockers
- Camera, ARKit, Core Location, Mapbox, credentials, and live connectivity still
  require a compatible device environment.

### Next action
- Merge the final hosted-green head, then preserve generation ownership in
  future connectivity and presentation changes.

## 2026-06-25T21:27:05Z — P1 correctness/privacy — cycle: venue lookup lifecycle ownership

### Summary
Bound Foursquare request and retry callbacks to the visible scene generation so
off-screen or superseded work cannot mutate AR and compass annotations.

### Work completed
- Added an idle/loading/loaded state machine with unique lookup generations.
- Retained and cancelled only in-flight Alamofire requests on scene departure.
- Rejected stale response and retry callbacks while preserving completed venue
  results across temporary scene disappearance.
- Added a fourth standalone Swift harness plus static and four mutation
  contracts.

### Threads
- Started: Foursquare request/retry generation ownership.
- Continued: visible-scene Core Location ownership and bounded retry handling.
- Stopped: none.

### Files changed
- `ViewController.swift`, `FoursquareVenueLookupState.swift`, Xcode project
  membership, Make/static gates, behavioral tests, and maintenance docs.

### Validation
- RED: `make check` rejected the missing production lifecycle state.
- GREEN: local static validation passes; this host has no `swiftc` or Xcode.
- The hosted macOS gate will compile all four production policy/state harnesses.
- Codex review caught the Swift 4-incompatible `&+=` spelling; the production
  state now uses the legacy-compatible wrapping expression `value = value &+ 1`.
- A second Codex pass caught scene departure clearing an active retry cooldown;
  cooling down is now distinct from in-flight work and is not cancelled.

### Bugs / findings
- P1: an in-flight response could add venue UI after `viewWillDisappear`.
- P1: an old delayed retry could clear the guard for a newer lookup generation.
- P1 review: `&+=` compiled on current hosted Swift but not the preserved Swift
  4.0 target; replaced it with the Swift 4-compatible `&+` expression.
- P2 review: treating retry cooldown as in-flight work let scene departure
  bypass the 30-second throttle; cooldown now has its own preserved phase.

### Blockers
- Camera, ARKit, Core Location, Mapbox, CocoaPods, credentials, and live
  Foursquare behavior still require a compatible physical-device environment.

### Next action
- Require exact-head Codex review plus hosted macOS and CodeQL success before
  merge, then preserve lifecycle ownership in future venue-flow changes.

## 2026-06-25 06:55 PDT

- Bound GPS and compass delivery to the visible AR scene: scene run starts
  authorized Core Location updates, while scene pause stops both services
  before pausing AR and invalidating its estimate timer.
- Prevented late authorization callbacks from restarting Core Location after
  the visible AR scene has relinquished update ownership.

## 2026-06-18

- Normalize venue text before rendering, rejecting blank required names and
  retaining the neutral category fallback through an executable Swift policy.
- Treat zero-width or BOM-only venue labels as blank, and trim those invisible
  boundary characters before publishing names or categories.
- Cancel the reachability URLSession probe when its semaphore wait times out.
- Wire the maintained exact-204 reachability probe into the app target and run
  it off the main queue before presenting offline state.
- Correct the CocoaPods lockfile checksum to match the reviewed Podfile.

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
  kept the Podfile checksum matched to the reviewed Podfile contents.

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
