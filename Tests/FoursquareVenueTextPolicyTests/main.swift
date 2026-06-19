import Foundation

private var failureCount = 0

private func expectVenueName(_ value: String, _ expected: String?, _ message: String) {
    let actual = FoursquareVenueTextPolicy.venueName(value)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(String(describing: expected)), got \(String(describing: actual))")
    }
}

private func expectCategoryName(_ value: String?, _ expected: String, _ message: String) {
    let actual = FoursquareVenueTextPolicy.categoryName(value)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expectVenueName("Corner Cafe", "Corner Cafe", "ordinary venue name")
expectVenueName("  Corner Cafe\n", "Corner Cafe", "trimmed venue name")
expectVenueName("", nil, "empty venue name")
expectVenueName(" \t\n", nil, "whitespace-only venue name")
expectVenueName("\u{200B}\u{FEFF}", nil, "invisible-only venue name")
expectVenueName("\u{2060}", nil, "format-only venue name")
expectVenueName("\u{034F}", nil, "mark-only venue name")
expectVenueName(" \u{200B}Corner Cafe\u{FEFF}\n", "Corner Cafe", "invisible-boundary venue name")
expectVenueName("Café 東京", "Café 東京", "Unicode-safe venue name")
expectVenueName("Cafe\u{301}", "Cafe\u{301}", "decomposed Unicode venue name")

expectCategoryName("Coffee Shop", "Coffee Shop", "ordinary category name")
expectCategoryName("  Coffee Shop\n", "Coffee Shop", "trimmed category name")
expectCategoryName("Café 東京", "Café 東京", "Unicode-safe category name")
expectCategoryName("Cafe\u{301}", "Cafe\u{301}", "decomposed Unicode category name")
expectCategoryName(nil, "Venue", "missing category fallback")
expectCategoryName("", "Venue", "empty category fallback")
expectCategoryName(" \t\n", "Venue", "whitespace-only category fallback")
expectCategoryName("\u{200B}\u{FEFF}", "Venue", "invisible-only category fallback")
expectCategoryName("\u{2060}", "Venue", "format-only category fallback")
expectCategoryName("\u{034F}", "Venue", "mark-only category fallback")
expectCategoryName(" \u{200B}Coffee Shop\u{FEFF}\n", "Coffee Shop", "invisible-boundary category name")

if failureCount > 0 {
    exit(1)
}

print("FoursquareVenueTextPolicy behavioral tests passed")
