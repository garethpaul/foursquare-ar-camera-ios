# Reachability Presentation Lifecycle Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Prevent delayed or superseded reachability callbacks from presenting an offline alert outside the current visible AR scene.

**Architecture:** Add a Swift 4-compatible generation state with begin, invalidate, and accepts operations. Start each reachability probe from `viewWillAppear`, capture its generation, and gate main-queue alert presentation against the current visible generation.

**Tech Stack:** Swift 4.0, UIKit lifecycle, Foundation, standalone `swiftc` harnesses, POSIX shell, static repository contracts.

---

Status: Completed

### Task 1: Prove generation semantics

**Files:**
- Create: `Tests/FoursquareReachabilityPresentationStateTests/main.swift`
- Create: `scripts/run-foursquare-reachability-presentation-state-tests.sh`
- Create: `FoursquareARCamera/Source/FoursquareReachabilityPresentationState.swift`

1. Write tests for current, disappeared, superseded, and replacement generations.
2. Run the focused harness and verify RED because the production state is missing.
3. Implement the minimal Swift 4-compatible state.
4. Run the focused harness and verify GREEN.

### Task 2: Own the probe lifecycle

**Files:**
- Modify: `FoursquareARCamera/ViewController.swift`
- Modify: `FoursquareARCamera.xcodeproj/project.pbxproj`

1. Move probe startup from `viewDidLoad()` into a dedicated generation-capturing method.
2. Begin the probe in `viewWillAppear()` before scene work.
3. Invalidate presentation ownership in `viewWillDisappear()` before pause.
4. Present only when the captured generation remains current.

### Task 3: Lock verification and evidence

**Files:**
- Modify: `Makefile`
- Modify: `scripts/check-baseline.sh`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `AGENTS.md`
- Modify: `CHANGES.md`
- Modify: `docs/plans/2026-06-25-reachability-presentation-lifecycle.md`

1. Add app-target, harness, ordering, documentation, and mutation contracts.
2. Run all focused harnesses and `make check`.
3. Mark this plan completed with exact local and hosted evidence.

## Verification Evidence

- RED: the focused Swift harness failed because
  `FoursquareReachabilityPresentationState.swift` did not exist.
- GREEN: current, disappeared, superseded, replacement, and repeated-appearance
  generation cases passed against production state in Swift 5.10.
- All five production Swift harnesses passed in a network-disabled container.
- `make lint`, `make test`, `make build`, and `make check` passed with all five
  harnesses and four reachability presentation hostile mutations;
  `xcodebuild` was unavailable locally.
- Hosted Check runs `28214619678` and `28214620695` passed macOS Swift harness
  and Xcode project validation on commit
  `1181194215e4330e8ed76314f6b3891bb3bcbad7`.
- Hosted CodeQL run `28214619620` passed Actions and Python analysis.
- `codex review --base origin/master` was attempted but could not authenticate
  to the OpenAI API (HTTP 401). Manual exact-head review found two trailing
  spaces in design links; commit `1181194` removed them, and no runtime finding remained.
- No live connectivity, camera, location, Mapbox, or Foursquare request ran.
