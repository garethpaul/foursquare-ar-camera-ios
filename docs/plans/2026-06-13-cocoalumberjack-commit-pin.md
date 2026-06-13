---
title: CocoaLumberjack Commit Pin
type: security
status: completed
date: 2026-06-13
---

# CocoaLumberjack Commit Pin

## Summary

Replace the mutable CocoaLumberjack `master` source selector with the exact
Swift 4 commit already recorded in the checked-in lockfile.

## Priority

1. Remove mutable dependency source resolution from the Podfile.
2. Keep Podfile and lockfile source metadata aligned to one reviewed commit.
3. Preserve the existing legacy pod graph and toolchain limitations.

## Requirements

- R1. The CocoaLumberjack Podfile declaration must use commit
  `f4294a13470d43260569d62aac6e1009fbef491a` and no branch selector.
- R2. The lockfile dependency and external-source entries must record the same
  commit, with no `master` branch metadata.
- R3. The existing checkout option must remain at the same exact commit.
- R4. Alamofire, AlamofireSwiftyJSON, Mapbox, SwiftyJSON, CocoaLumberjack 3.2.1,
  spec checksums, and CocoaPods 1.3.1 metadata must remain unchanged.
- R5. Static contracts must reject branch selectors, commit drift, duplicate
  commit selectors, and lockfile graph drift.
- R6. Documentation must state that the pin removes moving-branch resolution
  but does not modernize or authenticate the legacy dependency graph.
- R7. The Podfile checksum limitation must be explicit because CocoaPods 1.3.1
  regeneration is unavailable on this host.

## Non-Goals

- Running `pod install`, regenerating the workspace, or claiming dependency
  installation without an era-compatible CocoaPods/Xcode environment.
- Upgrading CocoaLumberjack, Mapbox, Alamofire, SwiftyJSON, iOS, or Swift.
- Resolving the historical Mapbox secret-scanning alert or rewriting history.
- Changing AR, camera, location, venue lookup, logging, or UI behavior.

## Implementation Units

### 1. Pod Source Pin

Files: `Podfile`, `Podfile.lock`

- Replace the branch selector with the exact existing checkout commit.
- Align dependency and external-source metadata without changing resolved pods.

### 2. Static Contracts

Files: `scripts/check-baseline.sh`

- Require three aligned commit references and zero mutable branch selectors.
- Preserve exact pod versions, checksums, CocoaPods version, and checksum caveat.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

- Record the reproducibility improvement and remaining legacy limitations.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Reintroduce `master`, drift one lockfile commit, and change a resolved pod
  version; the static gate must reject each mutation.
- Run shell syntax, plist/workspace parsing, `git diff --check`, and intended-file
  secret scans.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.

## Work Completed

- Replaced the CocoaLumberjack `master` selector with commit
  `f4294a13470d43260569d62aac6e1009fbef491a` in the Podfile.
- Aligned the dependency and external-source lockfile metadata to the same
  commit while preserving the resolved versions, spec checksums, checkout
  option, Podfile checksum, and CocoaPods 1.3.1 record.
- Added static source, graph, documentation, and completed-plan contracts.
- Documented that the historical Podfile checksum requires regeneration with
  CocoaPods 1.3.1 before claiming a fresh dependency installation.

## Verification Completed

- A pristine copied tree passed `make check` with the completed-plan evidence
  supplied in the copy.
- The branch mutation failed after restoring `:branch => 'master'`.
- The commit drift mutation failed after changing the external-source commit.
- The resolved graph mutation failed after changing Mapbox 3.6.4 to 3.6.5.
- The hosted pull-request check is a post-push evidence step; its bounded
  exact-head result is recorded after the implementation commit is pushed.
