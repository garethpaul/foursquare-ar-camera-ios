import Foundation

private var failureCount = 0

private func expect(_ urlString: String?, accepted expected: Bool, _ message: String) {
    let url: URL?
    if let urlString = urlString {
        url = URL(string: urlString)
    } else {
        url = nil
    }
    let actual = FoursquareResponseURLPolicy.accepts(url)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect("https://api.foursquare.com/v2/venues/search", accepted: true, "exact endpoint")
expect("https://api.foursquare.com/v2/venues/search?ll=1,2", accepted: true, "query parameters")
expect(nil, accepted: false, "missing URL")
expect("http://api.foursquare.com/v2/venues/search", accepted: false, "non-HTTPS scheme")
expect("https://www.foursquare.com/v2/venues/search", accepted: false, "wrong host")
expect("https://api.foursquare.com.example/v2/venues/search", accepted: false, "host suffix")
expect("https://user@api.foursquare.com/v2/venues/search", accepted: false, "userinfo")
expect("https://user:password@api.foursquare.com/v2/venues/search", accepted: false, "password")
expect("https://api.foursquare.com:443/v2/venues/search", accepted: false, "explicit port")
expect("https://api.foursquare.com/v2/venues/search/", accepted: false, "trailing slash")
expect("https://api.foursquare.com/v2/venues/%73earch", accepted: false, "encoded path")
expect("https://api.foursquare.com/v2/venues/search#fragment", accepted: false, "fragment")

if failureCount > 0 {
    exit(1)
}

print("FoursquareResponseURLPolicy behavioral tests passed")
