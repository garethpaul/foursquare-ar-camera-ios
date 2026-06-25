import Foundation

private var failureCount = 0

private func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        failureCount += 1
        print("FAIL: \(message)")
    }
}

let completed = FoursquareVenueLookupState()
let completedGeneration = completed.beginIfIdle()
expect(completedGeneration != nil, "idle lookup begins")
expect(completed.beginIfIdle() == nil, "duplicate lookup is rejected while loading")
expect(completed.markLoaded(generation: completedGeneration!), "current lookup can complete")
expect(completed.beginIfIdle() == nil, "completed lookup remains loaded")
expect(!completed.cancelInFlight(), "completed lookup is not invalidated on disappearance")

let retried = FoursquareVenueLookupState()
let firstGeneration = retried.beginIfIdle()!
expect(retried.beginRetryCooldown(generation: firstGeneration), "current failure begins retry cooldown")
expect(!retried.cancelInFlight(), "retry cooldown survives scene disappearance")
expect(retried.beginIfIdle() == nil, "retry cooldown blocks an immediate replacement lookup")
expect(retried.allowRetry(generation: firstGeneration), "current failure permits retry")
let secondGeneration = retried.beginIfIdle()!
expect(secondGeneration != firstGeneration, "retry receives a new generation")
expect(!retried.allowRetry(generation: firstGeneration), "stale retry cannot release newer lookup")
expect(retried.accepts(generation: secondGeneration), "newer lookup remains current")

let cancelled = FoursquareVenueLookupState()
let cancelledGeneration = cancelled.beginIfIdle()!
expect(cancelled.cancelInFlight(), "in-flight lookup is cancelled on disappearance")
let replacementGeneration = cancelled.beginIfIdle()!
expect(replacementGeneration != cancelledGeneration, "replacement lookup receives a new generation")
expect(!cancelled.markLoaded(generation: cancelledGeneration), "stale response cannot complete replacement lookup")
expect(cancelled.markLoaded(generation: replacementGeneration), "replacement response can complete")

if failureCount > 0 {
    exit(1)
}

print("FoursquareVenueLookupState behavioral tests passed")
