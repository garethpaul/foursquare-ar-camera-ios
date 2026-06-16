#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/foursquare-response-url-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

"$SWIFTC" \
    "$ROOT/FoursquareARCamera/Source/FoursquareResponseURLPolicy.swift" \
    "$ROOT/Tests/FoursquareResponseURLPolicyTests/main.swift" \
    -o "$BUILD_DIR/foursquare-response-url-tests"

"$BUILD_DIR/foursquare-response-url-tests"
