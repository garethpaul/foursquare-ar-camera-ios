# Foursquare Venue Coordinate Validation

status: completed

## Context

Venue response fields were type-checked but still allowed non-finite numbers,
impossible latitude/longitude, and negative distance values into AR and map
objects.

## Work Completed

- Required finite latitude and longitude values.
- Bounded latitude to -90 through 90 and longitude to -180 through 180.
- Required a finite nonnegative distance before converting to feet.
- Extended the static baseline and privacy documentation.

## Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
