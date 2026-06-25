#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/foursquare-venue-lookup-state-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}

handle_signal() {
    status=$1
    trap - 0 1 2 15
    cleanup
    exit "$status"
}

trap cleanup 0
trap 'handle_signal 129' 1
trap 'handle_signal 130' 2
trap 'handle_signal 143' 15

"$SWIFTC" \
    "$ROOT/FoursquareARCamera/Source/FoursquareVenueLookupState.swift" \
    "$ROOT/Tests/FoursquareVenueLookupStateTests/main.swift" \
    -o "$BUILD_DIR/foursquare-venue-lookup-state-tests"

"$BUILD_DIR/foursquare-venue-lookup-state-tests"
