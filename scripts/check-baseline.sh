#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-ar-camera-ios-credential-baseline.md"
MASK_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-ar-mask-asset-guard.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "Podfile" \
  "Podfile.lock" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "FoursquareARCamera.xcworkspace/contents.xcworkspacedata" \
  "FoursquareARCamera.xcodeproj/project.pbxproj" \
  "FoursquareARCamera/Info.plist" \
  "FoursquareARCamera/ViewController.swift" \
  "FoursquareARCamera/Source/Reachability.swift" \
  "docs/plans/2026-06-09-foursquare-ar-mask-asset-guard.md" \
  "docs/plans/2026-06-08-foursquare-ar-camera-ios-credential-baseline.md"; do
  require_file "$path"
done

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)\.DS_Store$|^mapbox_access_token$'; then
  printf '%s\n' "Local Finder artifacts and token placeholder files must not be tracked." >&2
  exit 1
fi

if ! grep -Fq '$(MAPBOX_ACCESS_TOKEN)' "$ROOT_DIR/FoursquareARCamera/Info.plist" ||
  ! grep -Fq '$(FOURSQUARE_CLIENT_ID)' "$ROOT_DIR/FoursquareARCamera/Info.plist" ||
  ! grep -Fq '$(FOURSQUARE_CLIENT_SECRET)' "$ROOT_DIR/FoursquareARCamera/Info.plist" ||
  grep -Fq "pk.eyJ" "$ROOT_DIR/FoursquareARCamera/Info.plist"; then
  printf '%s\n' "Info.plist must use local build settings for Mapbox and Foursquare credentials." >&2
  exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - "$ROOT_DIR/FoursquareARCamera/Info.plist" <<'PY'
import sys
import xml.etree.ElementTree as ET

ET.parse(sys.argv[1])
PY
else
  printf '%s\n' "Skipping Info.plist XML parse: python3 is not installed."
fi

view="$ROOT_DIR/FoursquareARCamera/ViewController.swift"
if ! grep -Fq 'configuredValue("FoursquareClientID")' "$view" ||
  ! grep -Fq 'configuredValue("FoursquareClientSecret")' "$view" ||
  ! grep -Fq "Skipping malformed Foursquare venue response" "$view" ||
  ! grep -Fq 'Alamofire.request("https://api.foursquare.com/v2/venues/search", parameters: parameters)' "$view" ||
  grep -Eq 'let client_(id|secret) = ""|client_secret=|client_id=' "$view" ||
  grep -Eq '\["(name|location)"\].*\!|\["categories"\]\[0\]' "$view" ||
  grep -Eq 'DDLogDebug\(.*(coordinate|currentLocation|translated location|best location estimate|altitude)' "$view"; then
  printf '%s\n' "ViewController must use local credentials and avoid detailed location logging." >&2
  exit 1
fi

if grep -Fq 'UIImage(named: "fsqMask")!' "$view" ||
  ! grep -Fq 'if let mask = UIImage(named: "fsqMask")' "$view" ||
  ! grep -Fq "Rendering Foursquare venue without the fsqMask asset" "$view"; then
  printf '%s\n' "Foursquare venue rendering must not force-unwrap the mask asset." >&2
  exit 1
fi

if grep -R -n 'print(' "$ROOT_DIR/FoursquareARCamera"; then
  printf '%s\n' "Swift source must not use print for app/runtime diagnostics." >&2
  exit 1
fi

reachability="$ROOT_DIR/FoursquareARCamera/Source/Reachability.swift"
if grep -Fq "http://google.com/" "$reachability" ||
  grep -Fq "NSURLConnection.sendSynchronousRequest" "$reachability" ||
  ! grep -Fq "https://www.google.com/generate_204" "$reachability"; then
  printf '%s\n' "Reachability check must use HTTPS without deprecated synchronous URL loading." >&2
  exit 1
fi

if grep -Eq 'URL\(url:|NSMutableURLRequest\(URL|sendSynchronousRequest' "$ROOT_DIR/FoursquareARCamera/Source/Reachability.swift"; then
  printf '%s\n' "Reachability helper must not use legacy Swift 2 URL/request APIs." >&2
  exit 1
fi

if ! grep -Fq "FoursquareARCamera.xcworkspace" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "venue mask asset is not force-unwrapped" "$ROOT_DIR/README.md" ||
  ! grep -Fq "MAPBOX_ACCESS_TOKEN" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_ID" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document workspace usage, verification, and local credentials." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "MAPBOX_ACCESS_TOKEN" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Venue rendering keeps working" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "detailed location" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe current credential and location guardrails." >&2
  exit 1
fi

if ! grep -Fq "*.xcconfig" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq ".env" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq ".DS_Store" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq "mapbox_access_token" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' "Local credential and machine artifacts must stay ignored." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -workspace "$ROOT_DIR/FoursquareARCamera.xcworkspace"
else
  printf '%s\n' "Skipping xcodebuild workspace listing: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MASK_PLAN"; then
  printf '%s\n' "Mask asset guard plan must be marked completed." >&2
  exit 1
fi

printf '%s\n' "foursquare-ar-camera-ios credential baseline checks passed."
