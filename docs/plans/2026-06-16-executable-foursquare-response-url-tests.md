---
title: Execute the Foursquare final-response URL policy
status: completed
date: 2026-06-16
---

# Execute the Foursquare final-response URL policy

## Goal

Compile and execute the same deterministic final-response URL predicate used by
the app, without requiring CocoaPods, credentials, a live request, or a device.

## Requirements

- Keep one Foundation-only policy in app production source and the Xcode app
  target.
- Delegate the Alamofire final-response validator to that policy without
  changing status, media, retry, redirect, credential, or parsing behavior.
- Compile the production policy with a standalone Swift harness from every Make
  gate when `swiftc` is available.
- Accept the exact HTTPS endpoint with or without query parameters and reject a
  missing URL, wrong scheme or host, host suffixes, userinfo, passwords,
  explicit ports, path drift, encoded-path drift, and fragments.
- Preserve explicit platform limitations: Linux static validation does not
  establish Xcode compilation, device behavior, or live Foursquare behavior.

## Work Completed

- Extracted `FoursquareResponseURLPolicy` from the compiled view-controller
  request chain and added it to the Xcode app target.
- Added a standalone Swift harness and bounded temporary-build runner.
- Wired the runner into all Make aliases before the maintained static baseline.
- Extended static contracts for production delegation, app-target membership,
  executable wiring, endpoint cases, documentation, and completed evidence.

## Verification Completed

- all four Make gates passed from the repository root.
- The absolute Makefile path passed from an external directory.
- The production policy mutation failed after weakening an endpoint constraint.
- The app delegation mutation failed after bypassing the production policy.
- The Xcode target membership mutation failed after removing the policy source.
- The accepted endpoint mutation failed after removing a permitted case.
- The hostile endpoint mutation failed after removing a rejected case.
- The plan evidence mutation failed after removing completed verification text.
- Shell syntax, project parsing, diff checks, intended-file artifact checks, and
  secret-pattern scans passed.
- `swiftc` and Xcode are unavailable on this Linux host, so local gates verify
  deterministic source wiring and defer execution to the hosted macOS runner.
- The hosted pull-request check is recorded against the exact pushed head in
  the external engineering tracker.
