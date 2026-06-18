import Foundation

enum FoursquareVenueTextPolicy {
    static let fallbackCategoryName = "Venue"

    static func venueName(_ value: String) -> String? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? nil : normalized
    }

    static func categoryName(_ value: String?) -> String {
        guard let value = value else {
            return fallbackCategoryName
        }

        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? fallbackCategoryName : normalized
    }
}
