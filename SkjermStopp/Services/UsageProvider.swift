import Foundation

/// Abstraction over data sources that provide today's device usage.
protocol UsageProvider {
    /// Returns today's total device usage duration in seconds from midnight to now.
    func fetchTodayUsage() async throws -> TimeInterval
}
