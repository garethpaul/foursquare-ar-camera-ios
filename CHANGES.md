# Changes

## 2026-06-09

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
