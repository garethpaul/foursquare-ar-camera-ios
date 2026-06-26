import Foundation

final class FoursquareReachabilityPresentationState {
    private var visibleGeneration: UInt?
    private var latestGeneration: UInt = 0

    func beginVisibleScene() -> UInt {
        latestGeneration = latestGeneration &+ 1
        visibleGeneration = latestGeneration
        return latestGeneration
    }

    func endVisibleScene() {
        visibleGeneration = nil
    }

    func accepts(generation: UInt) -> Bool {
        return visibleGeneration == generation
    }
}
