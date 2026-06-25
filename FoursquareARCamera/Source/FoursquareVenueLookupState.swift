import Foundation

final class FoursquareVenueLookupState {
    private enum Phase {
        case idle
        case loading(UInt)
        case coolingDown(UInt)
        case loaded
    }

    private var phase = Phase.idle
    private var latestGeneration: UInt = 0

    func beginIfIdle() -> UInt? {
        guard case .idle = phase else {
            return nil
        }

        latestGeneration = latestGeneration &+ 1
        phase = .loading(latestGeneration)
        return latestGeneration
    }

    func accepts(generation: UInt) -> Bool {
        guard case let .loading(currentGeneration) = phase else {
            return false
        }

        return currentGeneration == generation
    }

    func markLoaded(generation: UInt) -> Bool {
        guard accepts(generation: generation) else {
            return false
        }

        phase = .loaded
        return true
    }

    func allowRetry(generation: UInt) -> Bool {
        guard case let .coolingDown(currentGeneration) = phase,
            currentGeneration == generation else {
            return false
        }

        phase = .idle
        return true
    }

    func beginRetryCooldown(generation: UInt) -> Bool {
        guard accepts(generation: generation) else {
            return false
        }

        phase = .coolingDown(generation)
        return true
    }

    func cancelInFlight() -> Bool {
        guard case .loading(_) = phase else {
            return false
        }

        phase = .idle
        return true
    }
}
