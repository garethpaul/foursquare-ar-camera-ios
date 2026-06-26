---
title: Historical Mapbox Alert Evidence
type: security-operations
status: completed
date: 2026-06-26
---

# Historical Mapbox Alert Evidence

## Context

GitHub secret scanning reports one publicly leaked Mapbox secret-access-token
location in repository history. The flagged blob is not the blob currently
tracked at `FoursquareARCamera/Info.plist`; current source uses the
`$(MAPBOX_ACCESS_TOKEN)` build-setting placeholder and the baseline rejects
known public Mapbox token prefixes.

The alert's provider validity remains unknown. Repository cleanup and static
guards cannot establish that the historical credential was revoked or rotated
in the Mapbox account.

## Decision

- Keep the alert open until credential-owner revocation or rotation evidence is
  available.
- Do not retrieve, print, test, or reuse the historical token value.
- Do not resolve the alert as revoked based only on its absence from the current
  branch.
- Keep the current placeholder and tracked-token guards enforced.

## Verification Completed

- Compared the alert's historical blob identity with the current default-branch
  `Info.plist` blob without reading or printing the secret value; they differ.
- Confirmed GitHub reports the alert as open, publicly leaked, and with unknown
  validity.
- Confirmed the baseline requires `$(MAPBOX_ACCESS_TOKEN)` and rejects the
  checked-in public Mapbox token prefix.
- `make lint`, `make test`, `make build`, `make check`, and an absolute-Make
  invocation passed; one isolated guidance-removal mutation was rejected.
- Shell syntax, Python compilation, and `git diff --check` passed. Executable
  Swift policy tests and Xcode project listing skipped because `swiftc` and
  `xcodebuild` are unavailable; hosted macOS remains required.

## Blocker

Credential-owner revocation or rotation evidence is required before resolving
the alert. That provider-side action is outside repository verification.
