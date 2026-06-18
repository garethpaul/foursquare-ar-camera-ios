---
title: Foursquare Venue Name Boundary
type: bugfix
status: completed
date: 2026-06-18
execution: code
---

# Foursquare Venue Name Boundary

## Context

The venue parser requires the Foursquare `name` field to decode as a string,
but it accepts empty and whitespace-only values and publishes them directly to
the AR venue card. The optional category label has the same whitespace issue:
an empty decoded value bypasses the existing `"Venue"` fallback. Malformed
payloads can therefore create blank UI labels even though coordinates and
distance values already fail closed.

## Prioritized Engineering Tasks

1. **P0: Reject blank required venue names.** Normalize surrounding whitespace
   and skip a venue before rendering when the normalized name is empty.
2. **P1: Preserve a useful category fallback.** Normalize optional category
   labels and use the existing `"Venue"` fallback for missing or blank values.
3. **P1: Execute the production policy.** Compile the same Foundation-only
   source used by the app in a standalone hosted Swift harness.
4. **P2: Keep the boundary durable.** Add mutation-sensitive static contracts,
   synchronized guidance, and exact validation evidence.

## Requirements

- Add a Foundation-only production policy that returns a trimmed nonempty venue
  name or rejects the venue.
- Normalize an optional category label and retain `"Venue"` when the value is
  missing, empty, or whitespace-only.
- Use the policy in `FoursquareARCamera/ViewController.swift` before creating
  `FSQView`, map annotations, or AR nodes.
- Preserve valid Unicode venue/category text and trim only surrounding
  whitespace and newlines.
- Execute focused behavior cases against production source when `swiftc` is
  available, while retaining truthful Linux skips and hosted macOS authority.
- Preserve all existing credential, request, redirect, status, response URL,
  media type, coordinate, distance, retry, and logging boundaries.
- Add mutation-sensitive baseline contracts and update maintained guidance.

## Scope Boundaries

- Do not invent a Foursquare business-name length limit or character allowlist.
- Do not change venue ordering, the five-result limit, category selection,
  coordinates, distance conversion, AR layout, or image rendering.
- Do not make a live Foursquare request or require API credentials.
- Do not expose, retrieve, copy, resolve, or close historical secret-scanning
  alert data.
- Do not update CocoaPods, Swift language settings, signing, or deployment
  targets as part of this payload-integrity fix.
- Do not merge or close this stacked pull request or its predecessors without
  explicit authorization.

## Implementation Units

### U1. Production text normalization policy

**Execution note:** Test-first against the standalone production-source harness.

Files:

- `FoursquareARCamera/Source/FoursquareVenueTextPolicy.swift`
- `FoursquareARCamera/ViewController.swift`
- `FoursquareARCamera.xcodeproj/project.pbxproj`

Add a small Foundation-only policy for required venue names and optional
category labels. Apply it before UI/model publication so blank names follow the
existing malformed-venue skip path and blank categories use the existing
fallback.

### U2. Executable and static regressions

Files:

- `Tests/FoursquareVenueTextPolicyTests/main.swift`
- `scripts/run-foursquare-venue-text-tests.sh`
- `scripts/check-baseline.sh`
- `Makefile`

Cover ordinary, surrounding-whitespace, newline, empty, whitespace-only,
missing-category, blank-category, fallback, and Unicode cases using the actual
production policy. Preserve source wiring, Xcode target membership, executable
mode, Make integration, and execution through the existing hosted workflow's
canonical `make check` entrypoint.

### U3. Guidance and evidence

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `AGENTS.md`
- `docs/plans/2026-06-18-foursquare-venue-name-boundary.md`

Document the normalized text boundary, the malformed venue behavior, exact
commands actually run, platform skips, and exact-head hosted evidence. Preserve
the external Mapbox rotation boundary without reading or recording a secret.

## Test Scenarios

- Accept an ordinary venue name unchanged.
- Trim surrounding spaces and newlines from a valid venue name.
- Reject empty and whitespace-only venue names.
- Preserve valid non-ASCII venue text.
- Preserve a valid category label after trimming.
- Return `"Venue"` for nil, empty, and whitespace-only category labels.
- Prove `ViewController` delegates text decisions before constructing `FSQView`.
- Reject mutations that bypass normalization, remove required cases, omit Xcode
  target membership, remove Make/runner wiring, or reopen completed evidence.

## Verification

- Run the focused standalone Swift policy harness when `swiftc` is available.
- Run shell syntax checks plus repository-root and external-directory
  `make check`.
- Run isolated mutation cases for production delegation, required-name
  rejection, category fallback, Unicode preservation, target membership,
  runner/Make wiring, maintained guidance, and plan completion evidence.
- Audit the exact diff, project references, executable modes, generated
  artifacts, whitespace, conflict markers, and credential-shaped additions.
- Require one bounded exact-head PR/check and security-alert snapshot after push.

## Risks

- The app targets legacy Swift 4.0 while the standalone hosted compiler is
  modern; the policy must use syntax supported by both environments.
- Trimming changes presentation for names with intentional edge whitespace, but
  such whitespace is not meaningful venue identity and currently produces
  malformed labels.
- Linux cannot execute Swift or parse the Xcode project; hosted macOS remains
  authoritative for those gates.

## Verification Completed

The production policy trims required venue names, rejects empty and
whitespace-only names, preserves valid Unicode, trims category labels, and
uses the existing `Venue` fallback for missing or blank categories. The app
delegates both decisions before constructing `FSQView`, and the policy is a
member of the application target.

Repository-root and external-directory `make check` passed on Linux. The gate
truthfully skipped executable Swift tests and Xcode project parsing because
`swiftc` and `xcodebuild` are unavailable. A fake compiler exercised runner
success, compiler exit-7 propagation, and temporary-build cleanup.

Thirteen isolated mutations were rejected across both production normalization
paths, required blank-name and Unicode cases, app delegation for names and
categories, category Unicode preservation, Xcode target membership, Make and
runner wiring, executable mode, maintained guidance, and completed plan status.

Shell syntax, exact-diff whitespace, executable mode, generated-artifact, and
credential-shaped addition checks passed. No live Foursquare request was made.
The historical Mapbox secret-scanning alert remains an external rotation or
revocation boundary; no secret value was retrieved, copied, or recorded.

Hosted macOS evidence will be recorded in a follow-up exact-head evidence commit
after both canonical events complete.
