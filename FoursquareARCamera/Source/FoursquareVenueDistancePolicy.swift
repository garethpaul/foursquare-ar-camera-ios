import Foundation

enum FoursquareVenueDistancePolicy {
    private static let feetPerMeter = 3.28084
    static let maximumConvertibleMeters =
        (Double(Int.max).nextDown / feetPerMeter).nextDown

    static func feet(fromMeters distance: Double) -> Int? {
        guard distance.isFinite,
            distance >= 0,
            distance <= maximumConvertibleMeters else {
            return nil
        }

        return Int(distance * feetPerMeter)
    }
}
