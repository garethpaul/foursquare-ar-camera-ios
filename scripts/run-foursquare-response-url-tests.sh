#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/foursquare-response-url-tests.XXXXXX")

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
    "$ROOT/FoursquareARCamera/Source/FoursquareResponseURLPolicy.swift" \
    "$ROOT/Tests/FoursquareResponseURLPolicyTests/main.swift" \
    -o "$BUILD_DIR/foursquare-response-url-tests"

"$BUILD_DIR/foursquare-response-url-tests"
