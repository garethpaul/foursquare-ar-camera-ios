# Foursquare AR Mask Asset Guard

date: 2026-06-09
status: completed

## Context

Venue rendering force-unwrapped `UIImage(named: "fsqMask")`. If the asset
catalog was incomplete or the image failed to load, the venue lookup success path
could crash while building AR annotations.

## Completed Scope

- Guarded the optional `fsqMask` image before applying the venue mask.
- Kept venue annotation rendering available with the unmasked image when the
  mask asset is unavailable.
- Added static baseline checks for the mask guard and warning log.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
