import Foundation

enum FoursquareResponseURLPolicy {
    static func accepts(_ url: URL?) -> Bool {
        guard let url = url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }

        return components.scheme == "https" &&
            components.host == "api.foursquare.com" &&
            components.user == nil &&
            components.password == nil &&
            components.port == nil &&
            components.percentEncodedPath == "/v2/venues/search" &&
            components.fragment == nil
    }
}
