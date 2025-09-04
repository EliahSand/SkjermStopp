import Foundation

/// Mock provider that simulates usage increasing over time.
final class MockUsageProvider: UsageProvider {
    private var total: TimeInterval = 0
    private var lastFetch = Date()

    func fetchTodayUsage() async throws -> TimeInterval {
        let now = Date()
        total += now.timeIntervalSince(lastFetch)
        lastFetch = now
        return total
    }

#if DEBUG
    /// Adds 30 minutes for manual testing.
    func addDebugUsage() {
        total += 1800
    }
#endif
}
