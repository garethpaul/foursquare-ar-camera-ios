#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-ar-camera-ios-credential-baseline.md"
MASK_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-ar-mask-asset-guard.md"
TAP_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-ar-tap-interaction-guard.md"
LOCATION_AUTH_PLAN="$ROOT_DIR/docs/plans/2026-06-09-location-authorization-start-guard.md"
INFO_LABEL_PLAN="$ROOT_DIR/docs/plans/2026-06-09-info-label-text-guard.md"
REACHABILITY_INIT_PLAN="$ROOT_DIR/docs/plans/2026-06-09-reachability-init-guard.md"
MAKE_GATES_PLAN="$ROOT_DIR/docs/plans/2026-06-09-make-gate-aliases.md"
FSQ_VIEW_NIB_PLAN="$ROOT_DIR/docs/plans/2026-06-09-fsq-view-nib-outlet-guard.md"
LOCATION_MANAGER_OPTIONAL_PLAN="$ROOT_DIR/docs/plans/2026-06-09-location-manager-optional-guard.md"
MAP_ANNOTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-09-map-annotation-optional-guard.md"
VENUE_LOOKUP_RETRY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-lookup-retry-guard.md"
LEGACY_SDK_PLAN="$ROOT_DIR/docs/plans/2026-06-10-legacy-sdk-modernization-boundary.md"

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
  "FoursquareARCamera/Source/Helpers/LocationManager.swift" \
  "FoursquareARCamera/Source/Reachability.swift" \
  "FoursquareARCamera/Source/Views/FSQView.swift" \
  "docs/plans/2026-06-09-location-manager-optional-guard.md" \
  "docs/plans/2026-06-09-map-annotation-optional-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-lookup-retry-guard.md" \
  "docs/plans/2026-06-10-legacy-sdk-modernization-boundary.md" \
  "docs/plans/2026-06-09-fsq-view-nib-outlet-guard.md" \
  "docs/plans/2026-06-09-location-authorization-start-guard.md" \
  "docs/plans/2026-06-09-info-label-text-guard.md" \
  "docs/plans/2026-06-09-make-gate-aliases.md" \
  "docs/plans/2026-06-09-reachability-init-guard.md" \
  "docs/plans/2026-06-09-foursquare-ar-tap-interaction-guard.md" \
  "docs/plans/2026-06-09-foursquare-ar-mask-asset-guard.md" \
  "docs/plans/2026-06-08-foursquare-ar-camera-ios-credential-baseline.md"; do
  require_file "$path"
done

makefile="$ROOT_DIR/Makefile"
if ! grep -Eq '^\.PHONY: .*build.*check.*lint.*test|^\.PHONY: .*build.*lint.*test.*check' "$makefile" ||
  ! grep -Fq "lint test build: check" "$makefile"; then
  printf '%s\n' "Makefile must expose lint, test, build, and check gate targets." >&2
  exit 1
fi

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

if grep -Fq "Reachability()!" "$view" ||
  ! grep -Fq "if let reach = Reachability()" "$view" ||
  ! grep -Fq "Reachability could not be created" "$view"; then
  printf '%s\n' "ViewController must not force-unwrap Reachability initialization." >&2
  exit 1
fi

if ! grep -Fq "private let venueLookupRetryDelay: TimeInterval = 30.0" "$view" ||
  ! grep -Fq "private func allowVenueLookupRetryAfterDelay(reason: String)" "$view" ||
  ! grep -Fq "DispatchQueue.main.asyncAfter(timeInterval: venueLookupRetryDelay)" "$view" ||
  ! grep -Fq "var validVenueCount = 0" "$view" ||
  ! grep -Fq "validVenueCount += 1" "$view" ||
  ! grep -Fq "if validVenueCount == 0" "$view" ||
  ! grep -Fq "No valid Foursquare venues were returned." "$view" ||
  grep -Fq "self.loaded = false" "$view"; then
  printf '%s\n' "Foursquare venue lookup failures must release the loaded gate through a bounded retry delay." >&2
  exit 1
fi

if grep -Fq "geometry!.firstMaterial!" "$view" ||
  grep -Fq "hitResults[0]" "$view" ||
  ! grep -Fq "private var hasVenueTapGesture = false" "$view" ||
  ! grep -Fq "private func ensureVenueTapGesture()" "$view" ||
  ! grep -Fq "guard let material = result.node.geometry?.firstMaterial" "$view" ||
  ! grep -Fq "Skipping AR node highlight because material is unavailable" "$view"; then
  printf '%s\n' "AR venue tap handling must avoid duplicate gestures and unsafe material force unwraps." >&2
  exit 1
fi

if grep -R -n 'print(' "$ROOT_DIR/FoursquareARCamera"; then
  printf '%s\n' "Swift source must not use print for app/runtime diagnostics." >&2
  exit 1
fi

fsq_view="$ROOT_DIR/FoursquareARCamera/Source/Views/FSQView.swift"
if grep -Fq "view.frame = CGRect" "$fsq_view" ||
  ! grep -Fq "guard let loadedView = view" "$fsq_view" ||
  ! grep -Fq "Skipping FSQView setup because nib outlet is unavailable" "$fsq_view"; then
  printf '%s\n' "FSQView nib setup must guard the loaded outlet before adding subviews." >&2
  exit 1
fi

if grep -Fq "infoLabel.text!.append" "$view" ||
  ! grep -Fq "var infoLabelLines = [String]()" "$view" ||
  ! grep -Fq 'infoLabel.text = infoLabelLines.joined(separator: "\n")' "$view"; then
  printf '%s\n' "Debug info label updates must not force-unwrap optional label text." >&2
  exit 1
fi

if grep -Fq "self.userAnnotation!" "$view" ||
  grep -Fq "self.locationEstimateAnnotation!" "$view" ||
  grep -Fq "bestLocationEstimate!" "$view" ||
  ! grep -Fq "let userAnnotation: MKPointAnnotation" "$view" ||
  ! grep -Fq "self.mapView.addAnnotation(userAnnotation)" "$view" ||
  ! grep -Fq "let locationEstimateAnnotation: MKPointAnnotation" "$view" ||
  ! grep -Fq "self.mapView.addAnnotation(locationEstimateAnnotation)" "$view" ||
  ! grep -Fq "if let locationEstimateAnnotation = self.locationEstimateAnnotation" "$view"; then
  printf '%s\n' "Map annotation updates must avoid force-unwrapping optional annotations." >&2
  exit 1
fi

location_manager="$ROOT_DIR/FoursquareARCamera/Source/Helpers/LocationManager.swift"
if ! grep -Fq "private func isAuthorizedForLocationUpdates" "$location_manager" ||
  ! grep -Fq "requestWhenInUseAuthorization()" "$location_manager" ||
  ! grep -Fq "didChangeAuthorization" "$location_manager" ||
  ! grep -Fq "manager.startUpdatingLocation()" "$location_manager"; then
  printf '%s\n' "Location updates must be gated on Core Location authorization." >&2
  exit 1
fi

if grep -Fq "self.locationManager!" "$location_manager" ||
  grep -Fq "self.heading!" "$location_manager" ||
  ! grep -Fq "let manager = CLLocationManager()" "$location_manager" ||
  ! grep -Fq "self.locationManager = manager" "$location_manager" ||
  ! grep -Fq "let headingValue: CLLocationDirection" "$location_manager" ||
  ! grep -Fq "heading: headingValue" "$location_manager"; then
  printf '%s\n' "Location manager setup and heading forwarding must avoid force unwraps." >&2
  exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - "$location_manager" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
init_start = source.index("override init()")
request_start = source.index("func requestAuthorization")
init_body = source[init_start:request_start]

request_index = init_body.index("requestWhenInUseAuthorization()")
start_index = init_body.index("startUpdatingLocation()")
if request_index > start_index:
    raise SystemExit("Location authorization must be requested before updates start.")
PY
else
  printf '%s\n' "Skipping LocationManager order check: python3 is not installed."
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
  ! grep -Fq "make lint" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "venue mask asset is not force-unwrapped" "$ROOT_DIR/README.md" ||
  ! grep -Fq "venue tap interaction guard" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Core Location authorization" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FSQView nib outlet" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Map annotation updates avoid force-unwrapping optional" "$ROOT_DIR/README.md" ||
  ! grep -Fq "annotations while tracking the user and debug location estimate" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Foursquare venue lookup retries use a bounded cooldown" "$ROOT_DIR/README.md" ||
  ! grep -Fq "location-authorization-start-guard" "$ROOT_DIR/README.md" ||
  ! grep -Fq "MAPBOX_ACCESS_TOKEN" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_ID" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document workspace usage, verification, and local credentials." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make lint" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "MAPBOX_ACCESS_TOKEN" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Venue rendering keeps working" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Venue tap handling installs one gesture recognizer" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Location and heading updates start only after" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Location manager setup avoids force-unwrapping" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "FSQView nib setup guards" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Map annotation updates avoid force-unwrapping optional annotations" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Foursquare venue lookup retries use a bounded cooldown" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Debug info label updates avoid force-unwrapping optional label text" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "detailed location" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe current credential and location guardrails." >&2
  exit 1
fi

if ! grep -Fq "Core Location updates should stay gated on authorization" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the Core Location authorization boundary." >&2
  exit 1
fi

if ! grep -Fq "Location manager setup should avoid force-unwrapping" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the location manager optional boundary." >&2
  exit 1
fi

if ! grep -Fq "Debug label updates should not force-unwrap optional text" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the debug label force-unwrap boundary." >&2
  exit 1
fi

if ! grep -Fq "FSQView nib setup should guard missing outlets" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the FSQView nib outlet boundary." >&2
  exit 1
fi

if ! grep -Fq "Map annotation updates should avoid force-unwrapping optional annotation state" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the map annotation optional boundary." >&2
  exit 1
fi

if ! grep -Fq "Foursquare venue lookup retries should stay bounded" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the venue lookup retry boundary." >&2
  exit 1
fi

if ! grep -Fq "Swift 4.0 and iOS 11" "$ROOT_DIR/README.md" ||
  ! grep -Fq "CocoaLumberjack master branch" "$ROOT_DIR/README.md" ||
  ! grep -Fq "legacy-sdk-modernization-boundary" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the legacy SDK and dependency boundary." >&2
  exit 1
fi

if ! grep -Fq ":branch => 'master'" "$ROOT_DIR/Podfile" ||
  ! grep -Fq "COCOAPODS: 1.3.1" "$ROOT_DIR/Podfile.lock"; then
  printf '%s\n' "Legacy modernization boundary must track the mutable pod source and lockfile tool version." >&2
  exit 1
fi

if ! grep -Fq "Swift 4.0 and iOS 11" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Pin CocoaPods dependencies" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the legacy SDK modernization sequence." >&2
  exit 1
fi

if ! grep -Fq "Legacy Swift, CocoaPods, Mapbox, ARKit, Core Location, or Foursquare API modernization" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document legacy SDK modernization review boundaries." >&2
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
  xcodebuild -list -project "$ROOT_DIR/FoursquareARCamera.xcodeproj" >/dev/null
else
  printf '%s\n' "Skipping xcodebuild project listing: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MASK_PLAN"; then
  printf '%s\n' "Mask asset guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TAP_PLAN"; then
  printf '%s\n' "Venue tap interaction plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_AUTH_PLAN"; then
  printf '%s\n' "Location authorization start plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$INFO_LABEL_PLAN"; then
  printf '%s\n' "Info label text guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$REACHABILITY_INIT_PLAN"; then
  printf '%s\n' "Reachability initialization guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MAKE_GATES_PLAN"; then
  printf '%s\n' "Make gate alias plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$FSQ_VIEW_NIB_PLAN"; then
  printf '%s\n' "FSQView nib outlet guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_MANAGER_OPTIONAL_PLAN"; then
  printf '%s\n' "Location manager optional guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MAP_ANNOTATION_PLAN"; then
  printf '%s\n' "Map annotation optional guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$VENUE_LOOKUP_RETRY_PLAN"; then
  printf '%s\n' "Venue lookup retry guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$LOCATION_MANAGER_OPTIONAL_PLAN"; then
  printf '%s\n' "Location manager optional guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$MAP_ANNOTATION_PLAN"; then
  printf '%s\n' "Map annotation optional guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$VENUE_LOOKUP_RETRY_PLAN"; then
  printf '%s\n' "Venue lookup retry guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LEGACY_SDK_PLAN" ||
  ! grep -Fq "SWIFT_VERSION = 4.0" "$LEGACY_SDK_PLAN" ||
  ! grep -Fq "IPHONEOS_DEPLOYMENT_TARGET = 11.0" "$LEGACY_SDK_PLAN" ||
  ! grep -Fq "CocoaPods 1.3.1" "$LEGACY_SDK_PLAN" ||
  ! grep -Fq "make check" "$LEGACY_SDK_PLAN"; then
  printf '%s\n' "Legacy SDK modernization plan must record the current boundary and verification." >&2
  exit 1
fi

printf '%s\n' "foursquare-ar-camera-ios credential baseline checks passed."
