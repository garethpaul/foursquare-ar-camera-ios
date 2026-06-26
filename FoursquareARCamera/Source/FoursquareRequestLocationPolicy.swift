import Foundation

enum FoursquareRequestLocationPolicy {
    static func accepts(latitude: Double, longitude: Double) -> Bool {
        return latitude.isFinite &&
            longitude.isFinite &&
            (-90.0...90.0).contains(latitude) &&
            (-180.0...180.0).contains(longitude)
    }
}
