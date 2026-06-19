#!/usr/bin/env python3
from pathlib import Path
import sys


source = Path(sys.argv[1]).read_text(encoding="utf-8")
start = source.find("private let foursquareSessionManager: SessionManager = {")
end = source.find("\n    var adjustNorthByTappingSidesOfScreen", start)
if start == -1 or end == -1:
    raise SystemExit("Dedicated Foursquare SessionManager initializer is missing.")

initializer = source[start:end]
contracts = (
    "let configuration = URLSessionConfiguration.default",
    "configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders",
    "configuration.timeoutIntervalForRequest = 15.0",
    "configuration.timeoutIntervalForResource = 30.0",
    "let manager = SessionManager(configuration: configuration)",
    "manager.delegate.taskWillPerformHTTPRedirection = { _, _, _, _ in nil }",
    "return manager",
)
for contract in contracts:
    if initializer.count(contract) != 1:
        raise SystemExit(f"Venue session initializer must contain one {contract!r}.")
if not all(initializer.index(a) < initializer.index(b) for a, b in zip(contracts, contracts[1:])):
    raise SystemExit("Venue timeout and redirect policy must precede manager publication.")

print("Foursquare venue timeout checks passed.")
