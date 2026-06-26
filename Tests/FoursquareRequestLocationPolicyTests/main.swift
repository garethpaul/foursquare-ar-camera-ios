import Foundation

private var failureCount = 0

private func expect(
    latitude: Double,
    longitude: Double,
    accepted expected: Bool,
    _ message: String
) {
    let actual = FoursquareRequestLocationPolicy.accepts(
        latitude: latitude,
        longitude: longitude
    )
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect(latitude: 37.7749, longitude: -122.4194, accepted: true, "ordinary coordinate")
expect(latitude: -90, longitude: -180, accepted: true, "minimum boundaries")
expect(latitude: 90, longitude: 180, accepted: true, "maximum boundaries")
expect(latitude: 90.000_001, longitude: 0, accepted: false, "latitude above range")
expect(latitude: -90.000_001, longitude: 0, accepted: false, "latitude below range")
expect(latitude: 0, longitude: 180.000_001, accepted: false, "longitude above range")
expect(latitude: 0, longitude: -180.000_001, accepted: false, "longitude below range")
expect(latitude: Double.nan, longitude: 0, accepted: false, "NaN latitude")
expect(latitude: 0, longitude: Double.nan, accepted: false, "NaN longitude")
expect(latitude: Double.infinity, longitude: 0, accepted: false, "infinite latitude")
expect(latitude: 0, longitude: -Double.infinity, accepted: false, "infinite longitude")

if failureCount > 0 {
    exit(1)
}

print("FoursquareRequestLocationPolicy behavioral tests passed")
