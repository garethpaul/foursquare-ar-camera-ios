import Foundation

private var failureCount = 0

private func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        failureCount += 1
        print("FAIL: \(message)")
    }
}

let state = FoursquareReachabilityPresentationState()
let first = state.beginVisibleScene()
expect(state.accepts(generation: first), "current visible generation is accepted")

state.endVisibleScene()
expect(!state.accepts(generation: first), "disappeared generation is rejected")

let second = state.beginVisibleScene()
expect(second != first, "replacement scene receives a new generation")
expect(!state.accepts(generation: first), "superseded generation stays rejected")
expect(state.accepts(generation: second), "replacement generation is accepted")

let third = state.beginVisibleScene()
expect(third != second, "repeated appearance supersedes an earlier probe")
expect(!state.accepts(generation: second), "earlier visible probe is rejected")
expect(state.accepts(generation: third), "latest visible probe is accepted")

if failureCount > 0 {
    exit(1)
}

print("FoursquareReachabilityPresentationState behavioral tests passed")
