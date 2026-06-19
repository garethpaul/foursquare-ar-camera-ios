import Foundation

enum FoursquareVenueTextPolicy {
    static let fallbackCategoryName = "Venue"

    private static let labelBoundaryCharacters: CharacterSet = {
        var characters = CharacterSet.whitespacesAndNewlines
        characters.insert(charactersIn: "\u{200B}\u{200C}\u{200D}\u{2060}\u{FEFF}")
        return characters
    }()

    private static let invisibleLabelCharacters: CharacterSet = {
        var characters = labelBoundaryCharacters
        characters.formUnion(CharacterSet.nonBaseCharacters)
        return characters
    }()

    private static func containsVisibleContent(_ value: String) -> Bool {
        return value.unicodeScalars.contains { scalar in
            !invisibleLabelCharacters.contains(scalar) &&
                !CharacterSet.controlCharacters.contains(scalar)
        }
    }

    static func venueName(_ value: String) -> String? {
        let normalized = value.trimmingCharacters(in: labelBoundaryCharacters)
        return containsVisibleContent(normalized) ? normalized : nil
    }

    static func categoryName(_ value: String?) -> String {
        guard let value = value else {
            return fallbackCategoryName
        }

        let normalized = value.trimmingCharacters(in: labelBoundaryCharacters)
        return containsVisibleContent(normalized) ? normalized : fallbackCategoryName
    }
}
