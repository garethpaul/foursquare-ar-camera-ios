.PHONY: build check lint test

SWIFTC ?= swiftc
ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

lint test build: check

check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-foursquare-response-url-tests.sh" && \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-foursquare-venue-distance-tests.sh" && \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-foursquare-venue-text-tests.sh"; \
	else \
		echo "swiftc unavailable; executable Foursquare policy tests skipped"; \
	fi
	@"$(ROOT)/scripts/check-baseline.sh"
