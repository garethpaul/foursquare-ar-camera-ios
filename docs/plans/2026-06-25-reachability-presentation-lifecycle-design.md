# Reachability Presentation Lifecycle Design

Status: Approved

## Current State

`ViewController.viewDidLoad()` starts a background reachability probe. An
offline result returns to the main queue and presents an alert whenever the
controller still exists. The callback is not tied to the view's appearance, so
it can present after `viewWillDisappear()` or an older probe can present during
a later appearance.

Apple documents `viewWillAppear(_:)` as the point immediately before a view is
added to a hierarchy and `viewWillDisappear(_:)` as the point before removal:

- <https://developer.apple.com/documentation/uikit/uiviewcontroller/viewwillappear(_:)> 
- <https://developer.apple.com/documentation/uikit/uiviewcontroller/viewwilldisappear(_:)> 

## Constraints

- Keep the reachability probe off the main queue.
- Preserve exact-204 connectivity semantics in `Reachability.swift`.
- Do not add a new network dependency or call live services in tests.
- Preserve Swift 4.0-compatible syntax.
- Prevent callbacks from an earlier appearance from presenting later.

## Considered Approaches

### Recommended: Visible-scene generations

Start one probe from `viewWillAppear()`. Capture a generation from a small
production state object and present only if that generation is still current
when the callback reaches the main queue. Invalidate the generation from
`viewWillDisappear()`.

This rejects both off-screen callbacks and callbacks from an older appearance,
while remaining independently testable without UIKit or networking.

### Rejected: Boolean visibility flag

A boolean blocks callbacks while hidden, but an old callback can become valid
again after the next appearance and present stale state.

### Rejected: Check `view.window` only

This couples policy to UIKit state and does not distinguish an old probe from
the current appearance.

## Validation

- RED: compile a harness against the missing generation state.
- Prove current, disappeared, superseded, and replacement generations.
- Require app-target membership and exact view lifecycle ordering.
- Reject hostile mutations that permit stale or hidden presentation.
- Run all standalone Swift harnesses and the canonical static gate.
