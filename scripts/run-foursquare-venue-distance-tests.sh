#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/foursquare-venue-distance-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

"$SWIFTC" \
    "$ROOT/FoursquareARCamera/Source/FoursquareVenueDistancePolicy.swift" \
    "$ROOT/Tests/FoursquareVenueDistancePolicyTests/main.swift" \
    -o "$BUILD_DIR/foursquare-venue-distance-tests"

"$BUILD_DIR/foursquare-venue-distance-tests"
