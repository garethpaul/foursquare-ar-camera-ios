# Venue Lookup Lifecycle Ownership

status: completed

## Problem

Foursquare request and delayed retry callbacks outlive the visible AR scene.
An in-flight response can therefore add nodes and map annotations after
`viewWillDisappear`, while an older retry timer can clear the guard for a newer
lookup after the scene becomes visible again.

## Design

Model venue lookup as idle, loading, or loaded. Give each loading attempt a
unique generation token, accept callbacks only for the current generation,
and invalidate only in-flight work when the scene disappears. Preserve the
loaded state so returning to a completed scene does not duplicate venue nodes.

## Verification Completed

- RED: `make check` rejected the absent production state source.
- Added a standalone Swift state-machine harness for duplicate starts,
  successful completion, retry release, cancellation, and stale-generation
  rejection.
- `ViewController` retains/cancels the Alamofire request and guards every
  response/retry callback with the production state object.
- Four hostile contract mutations are rejected: cancellation removal, stale
  response acceptance removal, generation increment removal, and widening
  cancellation to the cooldown phase.
- Codex review rejected the current-Swift `&+=` spelling; the state now uses
  Swift 4-compatible `latestGeneration = latestGeneration &+ 1`.
- A second Codex review found that scene departure could clear a scheduled
  retry cooldown. The state now distinguishes loading from cooling down, and
  cancellation affects only loading.
- Local `make check` passes static validation; `swiftc` and Xcode are unavailable
  on this host, so executable Swift and project parsing remain hosted gates.
- `git diff --check` passes.
- No credentials, live Foursquare request, camera, AR session, or location data
  were used.
