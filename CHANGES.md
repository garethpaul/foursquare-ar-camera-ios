# Changes

## 2026-06-08

- Moved Mapbox and Foursquare credentials to local build settings.
- Removed tracked `.DS_Store` files and the empty `mapbox_access_token`
  placeholder.
- Removed detailed location debug logs from the venue lookup flow.
- Hardened venue response parsing and reachability checks.
- Replaced app/runtime `print` diagnostics with logger-backed calls.
- Guarded Foursquare venue rendering when the mask asset is missing.
- Added `make check` and `scripts/check-baseline.sh` for static credential,
  privacy, and project-shape verification.
