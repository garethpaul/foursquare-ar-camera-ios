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
VENUE_COORDINATE_PLAN="$ROOT_DIR/docs/plans/2026-06-10-foursquare-venue-coordinate-validation.md"
LEGACY_SDK_PLAN="$ROOT_DIR/docs/plans/2026-06-10-legacy-sdk-modernization-boundary.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-12-hosted-project-validation.md"
POD_TARGET_PLAN="$ROOT_DIR/docs/plans/2026-06-12-cocoapods-target-alignment.md"
COCOALUMBERJACK_PIN_PLAN="$ROOT_DIR/docs/plans/2026-06-13-cocoalumberjack-commit-pin.md"
RESPONSE_STATUS_PLAN="$ROOT_DIR/docs/plans/2026-06-13-foursquare-response-status-validation.md"
RESPONSE_CONTENT_TYPE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-foursquare-response-content-type-validation.md"
RESPONSE_FINAL_URL_PLAN="$ROOT_DIR/docs/plans/2026-06-14-foursquare-response-final-url-validation.md"
RESPONSE_URL_TEST_PLAN="$ROOT_DIR/docs/plans/2026-06-16-executable-foursquare-response-url-tests.md"
RESPONSE_REDIRECT_PLAN="$ROOT_DIR/docs/plans/2026-06-15-foursquare-redirect-refusal.md"
VENUE_TIMEOUT_PLAN="$ROOT_DIR/docs/plans/2026-06-15-foursquare-venue-request-timeouts.md"
VENUE_TIMEOUT_CHECK="$ROOT_DIR/scripts/check-venue-request-timeouts.py"
VENUE_TEXT_PLAN="$ROOT_DIR/docs/plans/2026-06-18-foursquare-venue-name-boundary.md"
RUNNER_SIGNAL_PLAN="$ROOT_DIR/docs/plans/2026-06-18-foursquare-swift-runner-signal-cleanup.md"
LOCATION_LIFECYCLE_PLAN="$ROOT_DIR/docs/plans/2026-06-25-visible-core-location-lifecycle.md"
REACHABILITY_STATUS_PLAN="$ROOT_DIR/docs/plans/2026-06-13-reachability-exact-204.md"
LOCATION_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-location-independent-make.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".github/workflows/check.yml" \
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
  "FoursquareARCamera/Source/FoursquareResponseURLPolicy.swift" \
  "FoursquareARCamera/Source/FoursquareVenueDistancePolicy.swift" \
  "FoursquareARCamera/Source/FoursquareVenueTextPolicy.swift" \
  "FoursquareARCamera/Source/Helpers/LocationManager.swift" \
  "FoursquareARCamera/Source/Reachability.swift" \
  "FoursquareARCamera/Source/Views/FSQView.swift" \
  "docs/plans/2026-06-09-location-manager-optional-guard.md" \
  "docs/plans/2026-06-09-map-annotation-optional-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-lookup-retry-guard.md" \
  "docs/plans/2026-06-10-foursquare-venue-coordinate-validation.md" \
  "docs/plans/2026-06-10-legacy-sdk-modernization-boundary.md" \
  "docs/plans/2026-06-12-hosted-project-validation.md" \
  "docs/plans/2026-06-12-cocoapods-target-alignment.md" \
  "docs/plans/2026-06-13-cocoalumberjack-commit-pin.md" \
  "docs/plans/2026-06-13-foursquare-response-status-validation.md" \
  "docs/plans/2026-06-13-foursquare-response-content-type-validation.md" \
  "docs/plans/2026-06-14-foursquare-response-final-url-validation.md" \
  "docs/plans/2026-06-16-executable-foursquare-response-url-tests.md" \
  "docs/plans/2026-06-17-foursquare-venue-distance-boundary.md" \
  "docs/plans/2026-06-18-foursquare-venue-name-boundary.md" \
  "docs/plans/2026-06-18-foursquare-swift-runner-signal-cleanup.md" \
  "docs/plans/2026-06-25-visible-core-location-lifecycle.md" \
  "docs/plans/2026-06-15-foursquare-redirect-refusal.md" \
  "docs/plans/2026-06-15-foursquare-venue-request-timeouts.md" \
  "scripts/check-venue-request-timeouts.py" \
  "scripts/run-foursquare-response-url-tests.sh" \
  "scripts/run-foursquare-venue-distance-tests.sh" \
  "scripts/run-foursquare-venue-text-tests.sh" \
  "Tests/FoursquareResponseURLPolicyTests/main.swift" \
  "Tests/FoursquareVenueDistancePolicyTests/main.swift" \
  "Tests/FoursquareVenueTextPolicyTests/main.swift" \
  "docs/plans/2026-06-13-reachability-exact-204.md" \
  "docs/plans/2026-06-13-location-independent-make.md" \
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

for location_lifecycle_evidence in \
  'status: completed' \
  'All four Make gates passed' \
  'hostile mutations were rejected' \
  'xcodebuild was unavailable'; do
  if ! grep -Fq "$location_lifecycle_evidence" "$LOCATION_LIFECYCLE_PLAN"; then
    printf '%s\n' "Core Location lifecycle plan must keep completed evidence: $location_lifecycle_evidence" >&2
    exit 1
  fi
done

if ! grep -Fqi 'visible AR scene' "$ROOT_DIR/README.md" ||
  ! grep -Fqi 'visible AR scene' "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fqi 'visible AR scene' "$ROOT_DIR/VISION.md" ||
  ! grep -Fqi 'visible AR scene' "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq 'stopUpdatingLocationAndHeading()' "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Repository guidance must document visible-scene Core Location ownership." >&2
  exit 1
fi

python3 - "$ROOT_DIR/Makefile" <<'PY'
import sys
from pathlib import Path

makefile = Path(sys.argv[1]).read_text()
fail_fast_contract = (
    'SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-foursquare-response-url-tests.sh" && \\',
    'SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-foursquare-venue-distance-tests.sh" && \\',
    'SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-foursquare-venue-text-tests.sh"; \\',
)

if any(fragment not in makefile for fragment in fail_fast_contract):
    raise SystemExit(
        "Make check must stop immediately when any executable Foursquare policy runner fails."
    )
PY

python3 - \
  "$ROOT_DIR/scripts/run-foursquare-response-url-tests.sh" \
  "$ROOT_DIR/scripts/run-foursquare-venue-distance-tests.sh" \
  "$ROOT_DIR/scripts/run-foursquare-venue-text-tests.sh" <<'PY'
import re
import sys
from pathlib import Path

handler = re.compile(
    r'''handle_signal\(\) \{\s*'''
    r'''status=\$1\s*'''
    r'''trap - 0 1 2 15\s*'''
    r'''cleanup\s*'''
    r'''exit "\$status"\s*'''
    r'''\}'''
)

for runner_path in map(Path, sys.argv[1:]):
    runner = runner_path.read_text(encoding="utf-8")
    if not handler.search(runner):
        raise SystemExit(
            f"{runner_path.name} signals must clean temporary output before exiting."
        )
    for signal, status in ((1, 129), (2, 130), (15, 143)):
        binding = f"trap 'handle_signal {status}' {signal}"
        if runner.count(binding) != 1:
            raise SystemExit(
                f"{runner_path.name} must retain signal binding: {binding}"
            )
PY

for runner_signal_plan_contract in \
  "status: completed" \
  "response-URL, venue-distance, and venue-text runners" \
  "leave runner-specific temporary directories behind" \
  "## Verification Completed" \
  "ae7cd17b9db57728f2aa4714be130582e03f71e6" \
  'Push run `27747566549` and pull-request run `27747567053` completed' \
  "status 42" \
  "historical Mapbox secret-scanning alert remains"; do
  if ! grep -Fq "$runner_signal_plan_contract" "$RUNNER_SIGNAL_PLAN"; then
    printf '%s\n' "Foursquare runner signal-cleanup plan must retain evidence: $runner_signal_plan_contract" >&2
    exit 1
  fi
done

python3 "$VENUE_TIMEOUT_CHECK" "$ROOT_DIR/FoursquareARCamera/ViewController.swift"

for venue_timeout_doc in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "Foursquare venue networking uses a 15-second request timeout and a 30-second resource timeout." "$ROOT_DIR/$venue_timeout_doc"; then
    printf '%s\n' "$venue_timeout_doc must document bounded Foursquare venue timeouts." >&2
    exit 1
  fi
done

for venue_timeout_plan_contract in \
  "status: completed" \
  "## Status: Completed" \
  "## Work Completed" \
  "## Verification Completed" \
  "hostile mutations were rejected"; do
  if ! grep -Fq "$venue_timeout_plan_contract" "$VENUE_TIMEOUT_PLAN"; then
    printf '%s\n' "Venue timeout plan must record completed evidence: $venue_timeout_plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq 'override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq '"$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must protect the loaded Makefile root from overrides." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "from /tmp" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "absolute Makefile path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Made static verification independent" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Location-independent Make plan and guidance must record completed external verification." >&2
  exit 1
fi

makefile="$ROOT_DIR/Makefile"
if ! grep -Eq '^\.PHONY: .*build.*check.*lint.*test|^\.PHONY: .*build.*lint.*test.*check' "$makefile" ||
  ! grep -Fq "lint test build: check" "$makefile"; then
  printf '%s\n' "Makefile must expose lint, test, build, and check gate targets." >&2
  exit 1
fi

pod_target_count=$(grep -Ec "^[[:space:]]*target 'FoursquareARCamera' do[[:space:]]*$" "$ROOT_DIR/Podfile" || true)
project_target_count=$(grep -Fc 'name = FoursquareARCamera;' "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj" || true)

if [ "$pod_target_count" -ne 1 ] ||
  [ "$project_target_count" -ne 1 ] ||
  grep -Fq "target 'PlacesARCamera'" "$ROOT_DIR/Podfile" ||
  ! grep -Fq "Pods-FoursquareARCamera.debug.xcconfig" "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj" ||
  ! grep -Fq "Pods-FoursquareARCamera.release.xcconfig" "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj"; then
  printf '%s\n' "Podfile and generated CocoaPods references must align with the FoursquareARCamera native target." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)\.DS_Store$|^mapbox_access_token$'; then
  printf '%s\n' "Local Finder artifacts and token placeholder files must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | awk '
  {
    folded = tolower($0)
    if (seen[folded] != "" && seen[folded] != $0) {
      print seen[folded] " <-> " $0
    } else {
      seen[folded] = $0
    }
  }
' | grep -q .; then
  printf '%s\n' "Tracked paths must not collide on case-insensitive filesystems." >&2
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
  ! grep -Fq 'self.foursquareSessionManager.request("https://api.foursquare.com/v2/venues/search", parameters: parameters)' "$view" ||
  grep -Fq 'Alamofire.request("https://api.foursquare.com/v2/venues/search", parameters: parameters)' "$view" ||
  grep -Eq 'let client_(id|secret) = ""|client_secret=|client_id=' "$view" ||
  grep -Eq '\["(name|location)"\].*\!|\["categories"\]\[0\]' "$view" ||
  grep -Eq 'DDLogDebug\(.*(coordinate|currentLocation|translated location|best location estimate|altitude)' "$view"; then
  printf '%s\n' "ViewController must use local credentials and avoid detailed location logging." >&2
  exit 1
fi

python3 - "$view" "$ROOT_DIR/FoursquareARCamera/Source/FoursquareResponseURLPolicy.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
policy = Path(sys.argv[2]).read_text()
lookup = source.split("func getFoursquareLocations", 1)[-1].split("\n    @objc", 1)[0]
manager_contract = (
    "private let foursquareSessionManager: SessionManager = {",
    "let configuration = URLSessionConfiguration.default",
    "configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders",
    "let manager = SessionManager(configuration: configuration)",
    "manager.delegate.taskWillPerformHTTPRedirection = { _, _, _, _ in nil }",
    "return manager",
)
if any(source.count(fragment) != 1 for fragment in manager_contract):
    raise SystemExit("Foursquare venue lookup must use one dedicated redirect-refusing Alamofire session manager.")
request = 'self.foursquareSessionManager.request("https://api.foursquare.com/v2/venues/search", parameters: parameters)'
status_validator = ".validate(statusCode: 200..<300)"
final_url_validator = ".validate { _, response, _ in"
content_type_validator = '.validate(contentType: ["application/json"])'
response = ".responseJSON { response in"
failure = 'self.allowVenueLookupRetryAfterDelay(reason: "Foursquare venue lookup failed.")'
contract = (request, status_validator, final_url_validator, content_type_validator, response)
positions = [lookup.find(fragment) for fragment in contract]

if any(lookup.count(fragment) != 1 for fragment in contract):
    raise SystemExit("Foursquare venue lookup must keep one request, status validator, final URL validator, JSON media validator, and response handler.")
if -1 in positions or positions != sorted(positions) or len(set(positions)) != len(positions):
    raise SystemExit("Foursquare status, final URL, and JSON media validation must run before response handling.")
final_url_contract = (
    "FoursquareResponseURLPolicy.accepts(response.url)",
    'NSError(domain: "FoursquareResponseValidation", code: 1, userInfo: nil)',
)
policy_contract = (
    "static func accepts(_ url: URL?) -> Bool",
    'components.scheme == "https"',
    'components.host == "api.foursquare.com"',
    "components.user == nil",
    "components.password == nil",
    "components.port == nil",
    'components.percentEncodedPath == "/v2/venues/search"',
    "components.fragment == nil",
)
if any(lookup.count(fragment) != 1 for fragment in final_url_contract):
    raise SystemExit("Foursquare final response validation must delegate once to the executable endpoint policy.")
if any(policy.count(fragment) != 1 for fragment in policy_contract):
    raise SystemExit("Foursquare final response URL validation must preserve the exact HTTPS endpoint boundary.")
if lookup.count("case .failure:") != 1 or lookup.count(failure) != 1:
    raise SystemExit("Rejected Foursquare responses must retain the bounded generic failure retry.")
PY

python3 - "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/Makefile" \
  "$ROOT_DIR/scripts/run-foursquare-response-url-tests.sh" \
  "$ROOT_DIR/Tests/FoursquareResponseURLPolicyTests/main.swift" <<'PY'
import sys
from pathlib import Path

project, makefile, runner, tests = (Path(path).read_text() for path in sys.argv[1:])
if project.count("FoursquareResponseURLPolicy.swift in Sources") != 2:
    raise SystemExit("The executable Foursquare response URL policy must belong to the app target once.")
if project.count("/* FoursquareResponseURLPolicy.swift */") != 3:
    raise SystemExit("The Foursquare response URL policy project reference must remain complete and unique.")
if makefile.count('scripts/run-foursquare-response-url-tests.sh') != 1:
    raise SystemExit("Every Make gate must invoke the executable Foursquare response URL tests once.")
runner_contract = (
    "FoursquareARCamera/Source/FoursquareResponseURLPolicy.swift",
    "Tests/FoursquareResponseURLPolicyTests/main.swift",
    'mktemp -d "${TMPDIR:-/tmp}/foursquare-response-url-tests.XXXXXX"',
    "trap cleanup 0",
)
if any(runner.count(fragment) != 1 for fragment in runner_contract):
    raise SystemExit("The Foursquare response URL test runner must compile production policy with bounded cleanup.")
test_contract = (
    'accepted: true, "exact endpoint"',
    'accepted: true, "query parameters"',
    'accepted: false, "missing URL"',
    'accepted: false, "non-HTTPS scheme"',
    'accepted: false, "wrong host"',
    'accepted: false, "host suffix"',
    'accepted: false, "userinfo"',
    'accepted: false, "password"',
    'accepted: false, "explicit port"',
    'accepted: false, "trailing slash"',
    'accepted: false, "encoded path"',
    'accepted: false, "fragment"',
)
if any(tests.count(fragment) != 1 for fragment in test_contract):
    raise SystemExit("Executable response URL tests must preserve every accepted and hostile endpoint case.")
PY

if ! grep -Fq "refuses redirects before sending venue query credentials" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Credential-bearing Foursquare venue requests must refuse redirects" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Venue lookup refuses redirects before credentials can be forwarded" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Refused redirects for credential-bearing Foursquare venue requests" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "refuse redirects before forwarding credential-bearing query parameters" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Repository guidance must document Foursquare redirect refusal." >&2
  exit 1
fi

if ! grep -Fq "api.foursquare.com endpoint and exact path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "response URL at the HTTPS" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "exact final HTTPS endpoint" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "exact final HTTPS Foursquare API endpoint" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "exact final HTTPS Foursquare API endpoint" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Repository guidance must document Foursquare final response URL validation." >&2
  exit 1
fi

if ! grep -Fq "application/json" "$ROOT_DIR/README.md" ||
  ! grep -Fq "media type before JSON response parsing" "$ROOT_DIR/README.md" ||
  ! grep -Fq '`application/json`' "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "response media type" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "exact JSON response media type" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "exact application/json response media type" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "exact JSON response media type" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Repository guidance must document Foursquare JSON media validation." >&2
  exit 1
fi

if ! grep -Fq "venueLatitude.isFinite" "$view" ||
  ! grep -Fq "(-90.0...90.0).contains(venueLatitude)" "$view" ||
  ! grep -Fq "venueLongitude.isFinite" "$view" ||
  ! grep -Fq "(-180.0...180.0).contains(venueLongitude)" "$view" ||
  ! grep -Fq "distance.isFinite" "$view" ||
  ! grep -Fq "distance >= 0" "$view"; then
  printf '%s\n' "Foursquare venue coordinates and distance must be finite and in range." >&2
  exit 1
fi

if grep -Fq 'UIImage(named: "fsqMask")!' "$view" ||
  ! grep -Fq 'if let mask = UIImage(named: "fsqMask")' "$view" ||
  ! grep -Fq "Rendering Foursquare venue without the fsqMask asset" "$view"; then
  printf '%s\n' "Foursquare venue rendering must not force-unwrap the mask asset." >&2
  exit 1
fi

if grep -Fq "Reachability()!" "$view" ||
  grep -Fq "import ReachabilitySwift" "$view" ||
  grep -Fq "currentReachabilityString" "$view" ||
  ! grep -Fq "DispatchQueue.global(qos: .utility).async" "$view" ||
  ! grep -Fq "if !Reachability.isConnectedToNetwork()" "$view" ||
  ! grep -Fq "guard let strongSelf = self" "$view"; then
  printf '%s\n' "ViewController must use the maintained exact-status Reachability probe." >&2
  exit 1
fi

python3 - "$ROOT_DIR/FoursquareARCamera/Source/Reachability.swift" "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
project = Path(sys.argv[2]).read_text()
helper = source.split("private class func isSuccessfulProbeStatus", 1)[-1].split(
    "class func isConnectedToNetwork", 1
)[0]
probe = source.split("class func isConnectedToNetwork", 1)[-1]
if project.count("Reachability.swift in Sources") != 2 or project.count("/* Reachability.swift */") != 3:
    raise SystemExit("Reachability.swift must remain a member of the app target.")
if helper.count("return statusCode == 204") != 1:
    raise SystemExit("Reachability must accept only the expected HTTP 204 probe status.")
if probe.count("isSuccessfulProbeStatus(httpResponse.statusCode)") != 1:
    raise SystemExit("Reachability must route the probe response through the exact-status helper.")
redirect_contract = (
    "private final class RedirectRefusingDelegate: NSObject, URLSessionTaskDelegate",
    "willPerformHTTPRedirection",
    "completionHandler(nil)",
    "let redirectRefusingDelegate = RedirectRefusingDelegate()",
    "let session = URLSession(",
    "configuration: configuration",
    "delegate: redirectRefusingDelegate",
    "delegateQueue: nil",
)
if any(source.count(fragment) != 1 for fragment in redirect_contract) or "URLSession.shared" in source:
    raise SystemExit("Reachability probe must use a redirect-refusing URLSession before accepting HTTP 204.")
timeout_contract = (
    "if semaphore.wait(timeout: .now() + 10) == .timedOut {",
    "task.cancel()",
    "session.invalidateAndCancel()",
    "task.cancel()\n            session.invalidateAndCancel()\n            return false\n        }\n\n        session.finishTasksAndInvalidate()\n        return isConnected",
)
if any(probe.count(fragment) != 1 for fragment in timeout_contract):
    raise SystemExit("Reachability probe timeout must cancel the URLSession task before returning.")
for widened in ("200..<300", "200..<400", "statusCode == 200"):
    if widened in source:
        raise SystemExit("Reachability must not widen the exact HTTP 204 success boundary.")
PY

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

scene_location_view="$ROOT_DIR/FoursquareARCamera/Source/Views/SceneLocationView.swift"
for location_lifecycle_contract in \
  'private var updatesRequested = false' \
  'func startUpdatingLocationAndHeading()' \
  'updatesRequested = true' \
  'func stopUpdatingLocationAndHeading()' \
  'updatesRequested = false' \
  'manager.stopUpdatingLocation()' \
  'manager.stopUpdatingHeading()'; do
  if ! grep -Fq "$location_lifecycle_contract" "$location_manager"; then
    printf '%s\n' "LocationManager must keep visibility-owned update contract: $location_lifecycle_contract" >&2
    exit 1
  fi
done

if grep -Fq 'manager.startUpdatingLocation()' "$location_manager" &&
  ! grep -Fq 'if updatesRequested && isAuthorizedForLocationUpdates(status)' "$location_manager"; then
  printf '%s\n' "Authorization callbacks must not restart Core Location after the AR view pauses." >&2
  exit 1
fi

for scene_lifecycle_contract in \
  'locationManager.startUpdatingLocationAndHeading()' \
  'locationManager.stopUpdatingLocationAndHeading()'; do
  if ! grep -Fq "$scene_lifecycle_contract" "$scene_location_view"; then
    printf '%s\n' "SceneLocationView must own Core Location lifecycle: $scene_lifecycle_contract" >&2
    exit 1
  fi
done

if command -v python3 >/dev/null 2>&1; then
  python3 - "$location_manager" "$scene_location_view" <<'PY'
import re
import sys
from pathlib import Path

def strip_comments(source):
    source = re.sub(r"/\*.*?\*/", "", source, flags=re.DOTALL)
    return "\n".join(line.split("//", 1)[0] for line in source.splitlines())

def section(source, start, end):
    start_index = source.find(start)
    if start_index == -1:
        raise SystemExit("Core Location lifecycle contract missing: " + start)
    end_index = source.find(end, start_index)
    if end_index == -1:
        raise SystemExit("Core Location lifecycle contract missing: " + end)
    return source[start_index:end_index]

def required_index(source, contract):
    index = source.find(contract)
    if index == -1:
        raise SystemExit("Core Location lifecycle contract missing: " + contract)
    return index

manager_source = strip_comments(Path(sys.argv[1]).read_text())
scene_source = strip_comments(Path(sys.argv[2]).read_text())

init_body = section(manager_source, "override init()", "func startUpdatingLocationAndHeading()")
if "requestWhenInUseAuthorization()" not in init_body:
    raise SystemExit("Location authorization must be requested during manager setup.")
if ".startUpdatingLocation()" in init_body or ".startUpdatingHeading()" in init_body:
    raise SystemExit("LocationManager initialization must not start hardware updates before the AR view runs.")

start_body = section(manager_source, "func startUpdatingLocationAndHeading()", "func stopUpdatingLocationAndHeading()")
start_contracts = [
    "updatesRequested = true",
    "guard isAuthorizedForLocationUpdates(status) else {",
    "requestAuthorization()",
    "locationManager?.startUpdatingHeading()",
    "locationManager?.startUpdatingLocation()",
]
if not all(contract in start_body for contract in start_contracts):
    raise SystemExit("LocationManager start must request authorized location and heading delivery.")

stop_body = section(manager_source, "func stopUpdatingLocationAndHeading()", "func requestAuthorization()")
stop_contracts = [
    "updatesRequested = false",
    "locationManager?.stopUpdatingLocation()",
    "locationManager?.stopUpdatingHeading()",
]
if not all(contract in stop_body for contract in stop_contracts):
    raise SystemExit("LocationManager stop must disable location and heading delivery.")

authorization_body = section(manager_source, "didChangeAuthorization", "didUpdateLocations")
guard_index = required_index(authorization_body, "if updatesRequested && isAuthorizedForLocationUpdates(status)")
location_start_index = required_index(authorization_body, "manager.startUpdatingLocation()")
heading_start_index = required_index(authorization_body, "manager.startUpdatingHeading()")
if guard_index > min(location_start_index, heading_start_index):
    raise SystemExit("Authorization callbacks must gate update restart on active AR ownership.")

run_body = section(scene_source, "public func run()", "public func pause()")
if required_index(run_body, "locationManager.startUpdatingLocationAndHeading()") > required_index(run_body, "session.run(configuration)"):
    raise SystemExit("SceneLocationView must acquire Core Location before starting the AR session.")

pause_body = section(scene_source, "public func pause()", "updateLocationData()")
stop_index = required_index(pause_body, "locationManager.stopUpdatingLocationAndHeading()")
pause_index = required_index(pause_body, "session.pause()")
timer_index = required_index(pause_body, "updateEstimatesTimer?.invalidate()")
if not stop_index < pause_index < timer_index:
    raise SystemExit("SceneLocationView must stop Core Location before pausing AR and invalidating its timer.")
PY
else
  printf '%s\n' "Skipping LocationManager lifecycle order check: python3 is not installed."
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
  ! grep -Fq "tracking the user and debug location estimate" "$ROOT_DIR/README.md" ||
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
  ! grep -Fq "CocoaLumberjack no longer resolves a mutable branch" "$ROOT_DIR/README.md" ||
  ! grep -Fq "legacy-sdk-modernization-boundary" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the legacy SDK and dependency boundary." >&2
  exit 1
fi

podfile_checksum=$(shasum -a 1 "$ROOT_DIR/Podfile" | awk '{print $1}')
python3 - "$ROOT_DIR/Podfile" "$ROOT_DIR/Podfile.lock" "$podfile_checksum" <<'PY'
import sys
from pathlib import Path

podfile = Path(sys.argv[1]).read_text()
lockfile = Path(sys.argv[2]).read_text()
podfile_checksum = sys.argv[3]
commit = "f4294a13470d43260569d62aac6e1009fbef491a"

if podfile.count(":commit => '{}'".format(commit)) != 1:
    raise SystemExit("Podfile must contain one exact CocoaLumberjack commit selector.")
if ":branch" in podfile or "branch `master`" in lockfile or ":branch:" in lockfile:
    raise SystemExit("CocoaLumberjack dependency metadata must not use a mutable branch selector.")
if lockfile.count(commit) != 3:
    raise SystemExit("Podfile.lock must align dependency, external source, and checkout metadata to one commit.")

required_lock_contracts = (
    "- Alamofire (4.5.1)",
    "- AlamofireSwiftyJSON (1.0.0):",
    "- CocoaLumberjack/Default (3.2.1)",
    "- CocoaLumberjack/Swift (3.2.1):",
    "- Mapbox-iOS-SDK (3.6.4)",
    "- SwiftyJSON (3.1.4)",
    "Alamofire: 2d95912bf4c34f164fdfc335872e8c312acaea4a",
    "AlamofireSwiftyJSON: 78908b766483a28aa5cc90fd191a687467042973",
    "CocoaLumberjack: 520616f8e72226ca2c729b43981b66bc483745ce",
    "Mapbox-iOS-SDK: 47847dd44285477e0dfffd0130f65c8a52823ada",
    "SwiftyJSON: c2842d878f95482ffceec5709abc3d05680c0220",
    "COCOAPODS: 1.3.1",
)
if any(lockfile.count(item) != 1 for item in required_lock_contracts):
    raise SystemExit("Legacy resolved pod versions, checksums, and CocoaPods metadata must not drift.")
if lockfile.count(f"PODFILE CHECKSUM: {podfile_checksum}") != 1:
    raise SystemExit("Podfile.lock checksum must match the checked-in Podfile contents.")
PY

if ! grep -Fq "PODFILE CHECKSUM" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Podfile checksum must match" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Keep the Podfile checksum aligned" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "mutable CocoaLumberjack \`master\` selector" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Repository guidance must document the immutable pod source and checksum integrity boundary." >&2
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

if ! awk '
  /^on:$/ { on_count++ }
  /^  pull_request:$/ { pull_request_count++ }
  /^  push:$/ { push_count++ }
  /^  workflow_dispatch:$/ { workflow_dispatch_count++ }
  /^permissions:$/ { permissions_count++; permissions_state = 1; next }
  permissions_state == 1 && /^[[:space:]]*(#.*)?$/ { next }
  permissions_state == 1 {
    if ($0 == "  contents: read") {
      contents_read_count++
    } else {
      invalid = 1
    }
    permissions_state = 0
    next
  }
  /^concurrency:$/ { concurrency_count++ }
  /^  group: check-\$\{\{ github\.workflow \}\}-\$\{\{ github\.ref \}\}$/ { group_count++ }
  /^  cancel-in-progress: true$/ { cancellation_count++ }
  /^jobs:$/ { jobs_count++; jobs_state = 1 }
  jobs_state == 1 && /^  [A-Za-z0-9_-]+:$/ { job_count++; if ($0 == "  check:") check_job_count++ }
  /^    runs-on:/ { runner_count++; if ($0 == "    runs-on: macos-15") macos_runner_count++ }
  /^    timeout-minutes:/ { timeout_count++; if ($0 == "    timeout-minutes: 10") bounded_timeout_count++ }
  /^[[:space:]]*(-[[:space:]]+)?uses:/ { uses_count++ }
  /^[[:space:]]*(-[[:space:]]+)?uses:[[:space:]]*actions\/checkout@/ {
    checkout_count++
    if ($0 == "        uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10 # v6.0.3") {
      checkout_state = 1
    } else {
      invalid = 1
    }
    next
  }
  /^[[:space:]]*persist-credentials[[:space:]]*:/ { credential_count++ }
  /^        with:[[:space:]]*(#.*)?$/ { with_count++ }
  checkout_state == 1 && /^[[:space:]]*(#.*)?$/ { next }
  checkout_state == 1 {
    if ($0 == "        with:") {
      checkout_state = 2
    } else {
      invalid = 1
      checkout_state = 0
    }
    next
  }
  checkout_state == 2 && /^[[:space:]]*(#.*)?$/ { next }
  checkout_state == 2 {
    if ($0 == "          persist-credentials: false") {
      credential_contract_count++
    } else {
      invalid = 1
    }
    checkout_state = 0
  }
  /^[[:space:]]*(-[[:space:]]+)?run:/ { run_count++; if ($0 == "        run: make check") make_check_count++ }
  /(^|[[:space:]])(write-all|[A-Za-z-]+:[[:space:]]*write)([[:space:]]|$)/ { invalid = 1 }
  END {
    if (on_count != 1 || pull_request_count != 1 || push_count != 1 ||
        workflow_dispatch_count != 1 || permissions_count != 1 ||
        contents_read_count != 1 || concurrency_count != 1 || group_count != 1 ||
        cancellation_count != 1 || jobs_count != 1 || job_count != 1 ||
        check_job_count != 1 || runner_count != 1 || macos_runner_count != 1 ||
        timeout_count != 1 || bounded_timeout_count != 1 || uses_count != 1 || checkout_count != 1 ||
        with_count != 1 || credential_count != 1 || credential_contract_count != 1 ||
        run_count != 1 || make_check_count != 1 || invalid != 0) {
      exit 1
    }
  }
' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must keep one bounded, least-privilege macOS validation job." >&2
  exit 1
fi

if ! grep -Fq "GitHub Actions" "$ROOT_DIR/README.md" ||
  ! grep -Fq "without persisted checkout credentials" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/plans/2026-06-12-hosted-project-validation.md" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "no persisted checkout credentials" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project docs must record the hosted project validation baseline." >&2
  exit 1
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

if ! grep -Fq "status: completed" "$VENUE_COORDINATE_PLAN"; then
  printf '%s\n' "Foursquare venue coordinate plan must be marked completed." >&2
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

if ! grep -Fq "status: completed" "$CI_PLAN" ||
  ! grep -Fq "make check" "$CI_PLAN" ||
  ! grep -Fq "macos-15" "$CI_PLAN" ||
  ! grep -Fq "persisted checkout credentials" "$CI_PLAN"; then
  printf '%s\n' "Hosted project validation plan must record the completed security and verification contract." >&2
  exit 1
fi

python3 - "$POD_TARGET_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "All four Make gates",
    "push run `27392510844`",
    "pull-request run `27392514499`",
    "push run `27392528885`",
    "CodeQL run `27402320459`",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "CocoaPods target alignment plan must remain completed with actual verification recorded."
    )
PY

python3 - "$COCOALUMBERJACK_PIN_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "branch mutation failed",
    "commit drift mutation failed",
    "resolved graph mutation failed",
    "hosted pull-request check",
)

if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "CocoaLumberjack commit pin plan must remain completed with actual verification recorded."
    )
PY

python3 - "$RESPONSE_STATUS_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "validator removal mutation failed",
    "status range mutation failed",
    "validation ordering mutation failed",
    "duplicate request mutation failed",
    "failure retry mutation failed",
    "hosted pull-request check",
)

if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Foursquare response status plan must remain completed with actual verification recorded."
    )
PY

python3 - "$RESPONSE_CONTENT_TYPE_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "validator removal mutation failed",
    "media allowlist mutation failed",
    "validation ordering mutation failed",
    "duplicate handler mutation failed",
    "failure retry mutation failed",
    "plan evidence mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Foursquare response content-type plan must remain completed with actual verification recorded."
    )
PY

python3 - "$RESPONSE_FINAL_URL_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "validator removal mutation failed",
    "scheme mutation failed",
    "host mutation failed",
    "path mutation failed",
    "port mutation failed",
    "validation ordering mutation failed",
    "failure retry mutation failed",
    "plan evidence mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Foursquare response final URL plan must remain completed with actual verification recorded."
    )
PY

python3 - "$RESPONSE_URL_TEST_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "all four Make gates passed",
    "absolute Makefile path passed",
    "production policy mutation failed",
    "app delegation mutation failed",
    "Xcode target membership mutation failed",
    "accepted endpoint mutation failed",
    "hostile endpoint mutation failed",
    "plan evidence mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Executable Foursquare response URL test plan must remain completed with actual verification recorded."
    )
PY

python3 - \
  "$ROOT_DIR/FoursquareARCamera/ViewController.swift" \
  "$ROOT_DIR/FoursquareARCamera/Source/FoursquareVenueDistancePolicy.swift" \
  "$ROOT_DIR/Tests/FoursquareVenueDistancePolicyTests/main.swift" \
  "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/Makefile" \
  "$ROOT_DIR/docs/plans/2026-06-17-foursquare-venue-distance-boundary.md" <<'PY'
import sys
from pathlib import Path

view = Path(sys.argv[1]).read_text()
policy = Path(sys.argv[2]).read_text()
tests = Path(sys.argv[3]).read_text()
project = Path(sys.argv[4]).read_text()
makefile = Path(sys.argv[5]).read_text()
plan = " ".join(Path(sys.argv[6]).read_text().split())

required_policy = (
    "Double(Int.max).nextDown",
    "maximumConvertibleMeters",
    "distance.isFinite",
    "distance >= 0",
    "distance <= maximumConvertibleMeters",
    "return Int(distance * feetPerMeter)",
)
required_tests = (
    'expect(0, feet: 0, "zero")',
    'expect(200, feet: 656, "ordinary venue radius")',
    "maximumMeters.nextUp",
    "Double.nan",
    "Double.infinity",
    "-Double.infinity",
)
required_plan = (
    "status: completed",
    "Repository-root and external-directory `make check` passed",
    "Eight isolated mutations were rejected",
    "Both exact-head push and pull-request checks passed",
    "`0b540e158042063e06b4a7a822aee7d2b53497c3`",
    "Push run `27673872489`",
    "pull-request run `27673883985`",
    "no live Foursquare request was made",
    "historical Mapbox secret-scanning alert remains an external rotation or revocation boundary",
)

if any(item not in policy for item in required_policy):
    raise SystemExit("Venue distance conversion must remain finite, nonnegative, and Int-bounded.")
if "FoursquareVenueDistancePolicy.feet(" not in view or "let distanceFeet" not in view:
    raise SystemExit("Venue rendering must delegate distance conversion to the production policy.")
if any(item not in tests for item in required_tests):
    raise SystemExit("Executable venue distance boundary cases must remain registered.")
if project.count("FoursquareVenueDistancePolicy.swift in Sources") != 2 or project.count("/* FoursquareVenueDistancePolicy.swift */") != 3:
    raise SystemExit("Venue distance policy must remain a member of the app target.")
if "run-foursquare-venue-distance-tests.sh" not in makefile:
    raise SystemExit("The canonical Make gate must execute the venue distance policy harness.")
if any(item not in plan for item in required_plan):
    raise SystemExit("Venue distance plan must record completed verification and external secret boundary.")
PY

if ! grep -Fq 'integer-foot conversion is bounded' "$ROOT_DIR/README.md" || \
  ! grep -Fq 'integer conversion must remain bounded' "$ROOT_DIR/SECURITY.md" || \
  ! grep -Fq 'Bound venue distance conversion before integer rendering' "$ROOT_DIR/VISION.md" || \
  ! grep -Fq 'Bound venue distance conversion before integer rendering' "$ROOT_DIR/CHANGES.md" || \
  ! grep -Fq 'Keep venue distance-to-feet conversion within Int bounds' "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve the venue distance conversion boundary." >&2
  exit 1
fi

python3 - \
  "$ROOT_DIR/FoursquareARCamera/ViewController.swift" \
  "$ROOT_DIR/FoursquareARCamera/Source/FoursquareVenueTextPolicy.swift" \
  "$ROOT_DIR/Tests/FoursquareVenueTextPolicyTests/main.swift" \
  "$ROOT_DIR/FoursquareARCamera.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/Makefile" \
  "$ROOT_DIR/scripts/run-foursquare-venue-text-tests.sh" \
  "$VENUE_TEXT_PLAN" <<'PY'
import re
import sys
from pathlib import Path

view = Path(sys.argv[1]).read_text()
policy = Path(sys.argv[2]).read_text()
tests = Path(sys.argv[3]).read_text()
project = Path(sys.argv[4]).read_text()
makefile = Path(sys.argv[5]).read_text()
runner = Path(sys.argv[6]).read_text()
plan = Path(sys.argv[7]).read_text()
frontmatter = plan.split("---", 2)[1]

required_policy = (
    "labelBoundaryCharacters",
    "invisibleLabelCharacters",
    "CharacterSet.nonBaseCharacters",
    "containsVisibleContent",
    "trimmingCharacters(in: labelBoundaryCharacters)",
    'static let fallbackCategoryName = "Venue"',
    "return containsVisibleContent(normalized) ? normalized : nil",
    "return containsVisibleContent(normalized) ? normalized : fallbackCategoryName",
)
required_tests = (
    'expectVenueName("  Corner Cafe\\n", "Corner Cafe", "trimmed venue name")',
    'expectVenueName("", nil, "empty venue name")',
    'expectVenueName(" \\t\\n", nil, "whitespace-only venue name")',
    'expectVenueName("\\u{200B}\\u{FEFF}", nil, "invisible-only venue name")',
    'expectVenueName("\\u{2060}", nil, "format-only venue name")',
    'expectVenueName("\\u{034F}", nil, "mark-only venue name")',
    'expectVenueName(" \\u{200B}Corner Cafe\\u{FEFF}\\n", "Corner Cafe", "invisible-boundary venue name")',
    'expectVenueName("Café 東京", "Café 東京", "Unicode-safe venue name")',
    'expectVenueName("Cafe\\u{301}", "Cafe\\u{301}", "decomposed Unicode venue name")',
    'expectCategoryName("Café 東京", "Café 東京", "Unicode-safe category name")',
    'expectCategoryName("Cafe\\u{301}", "Cafe\\u{301}", "decomposed Unicode category name")',
    'expectCategoryName(nil, "Venue", "missing category fallback")',
    'expectCategoryName(" \\t\\n", "Venue", "whitespace-only category fallback")',
    'expectCategoryName("\\u{200B}\\u{FEFF}", "Venue", "invisible-only category fallback")',
    'expectCategoryName("\\u{2060}", "Venue", "format-only category fallback")',
    'expectCategoryName("\\u{034F}", "Venue", "mark-only category fallback")',
    'expectCategoryName(" \\u{200B}Coffee Shop\\u{FEFF}\\n", "Coffee Shop", "invisible-boundary category name")',
)
required_plan = (
    "## Verification Completed",
    "Repository-root and external-directory `make check` passed",
    "isolated mutations were rejected",
    "No live Foursquare request was made",
    "historical Mapbox secret-scanning alert remains",
)

if policy.count("trimmingCharacters(in: labelBoundaryCharacters)") != 2 or any(
    item not in policy for item in required_policy
):
    raise SystemExit("Venue text policy must trim required names and preserve the category fallback.")
if any(item not in tests for item in required_tests):
    raise SystemExit("Executable venue text normalization cases must remain registered.")
name_policy = view.find("FoursquareVenueTextPolicy.venueName(rawName)")
category_policy = view.find("FoursquareVenueTextPolicy.categoryName(")
view_creation = view.find("let fsview = FSQView")
if min(name_policy, category_policy, view_creation) < 0 or not (
    name_policy < view_creation and category_policy < view_creation
):
    raise SystemExit("Venue text decisions must occur before FSQView construction.")
if project.count("FoursquareVenueTextPolicy.swift in Sources") != 2 or project.count("/* FoursquareVenueTextPolicy.swift */") != 3:
    raise SystemExit("Venue text policy must remain a member of the app target.")
if makefile.count("run-foursquare-venue-text-tests.sh") != 1:
    raise SystemExit("The canonical Make gate must execute the venue text policy harness.")
runner_contract = (
    "FoursquareARCamera/Source/FoursquareVenueTextPolicy.swift",
    "Tests/FoursquareVenueTextPolicyTests/main.swift",
    'mktemp -d "${TMPDIR:-/tmp}/foursquare-venue-text-tests.XXXXXX"',
    "trap cleanup 0",
)
if any(runner.count(item) != 1 for item in runner_contract):
    raise SystemExit("The venue text runner must compile production policy with bounded cleanup.")
if re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE) != ["status: completed"] or any(
    item not in plan for item in required_plan
):
    raise SystemExit("Venue text plan must record completed verification and external secret boundary.")
PY

if [ ! -x "$ROOT_DIR/scripts/run-foursquare-venue-text-tests.sh" ]; then
  printf '%s\n' "The venue text test runner must remain executable." >&2
  exit 1
fi

if ! grep -Fq 'blank or invisible-only venue' "$ROOT_DIR/README.md" || \
  ! grep -Fq 'blank or invisible-only venue names before' "$ROOT_DIR/SECURITY.md" || \
  ! grep -Fq 'Normalize venue text before rendering' "$ROOT_DIR/VISION.md" || \
  ! grep -Fq 'Normalize venue text before rendering' "$ROOT_DIR/CHANGES.md" || \
  ! grep -Fq 'Reject blank venue names before creating AR or map UI' "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve the venue text normalization boundary." >&2
  exit 1
fi

python3 - "$RESPONSE_REDIRECT_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "manager removal mutation failed",
    "redirect policy mutation failed",
    "global request helper mutation failed",
    "duplicate request mutation failed",
    "final URL validator mutation failed",
    "failure retry mutation failed",
    "plan evidence mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Foursquare redirect refusal plan must remain completed with actual verification recorded."
    )
PY

python3 - "$REACHABILITY_STATUS_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
required = (
    "five hostile mutations were rejected",
    "all four Make gates passed",
    "xcodebuild was unavailable",
    "No live connectivity probe",
)
if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit("Reachability exact-status plan must record completed local verification.")
PY

if ! grep -Fq "succeeds only for its expected HTTP 204" "$ROOT_DIR/README.md" ||
  ! grep -Fq "HTTP 204 response; redirects" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "accepts only its expected HTTP 204 response" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "return exactly HTTP 204" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "limited to exact HTTP 204 success" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project docs must preserve the exact reachability status boundary." >&2
  exit 1
fi

printf '%s\n' "foursquare-ar-camera-ios credential baseline checks passed."
