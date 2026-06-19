import Foundation

private var failureCount = 0

private func expect(_ meters: Double, feet expected: Int?, _ message: String) {
    let actual = FoursquareVenueDistancePolicy.feet(fromMeters: meters)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(String(describing: expected)), got \(String(describing: actual))")
    }
}

expect(0, feet: 0, "zero")
expect(1, feet: 3, "one meter truncates to integer feet")
expect(200, feet: 656, "ordinary venue radius")

let maximumMeters = FoursquareVenueDistancePolicy.maximumConvertibleMeters
if FoursquareVenueDistancePolicy.feet(fromMeters: maximumMeters) == nil {
    failureCount += 1
    print("FAIL: maximum convertible distance must be accepted")
}

expect(maximumMeters.nextUp, feet: nil, "distance above conversion boundary")
expect(-1, feet: nil, "negative distance")
expect(Double.nan, feet: nil, "NaN distance")
expect(Double.infinity, feet: nil, "positive infinity")
expect(-Double.infinity, feet: nil, "negative infinity")

if failureCount > 0 {
    exit(1)
}

print("FoursquareVenueDistancePolicy behavioral tests passed")
