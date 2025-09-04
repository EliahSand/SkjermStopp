import Foundation

#if canImport(DeviceActivity)
import DeviceActivity
import FamilyControls
#endif

/// Usage provider backed by Apple's Screen Time APIs.
struct ScreenTimeUsageProvider: UsageProvider {
    func fetchTodayUsage() async throws -> TimeInterval {
#if canImport(DeviceActivity)
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        let schedule = DeviceActivitySchedule(intervalStart: start, intervalEnd: end, repeats: false)
        let center = DeviceActivityCenter()
        let report = try await center.report(using: DeviceActivityReport.Name("daily"), during: schedule)
        return report.totalActivityDuration
#else
        throw NSError(domain: "ScreenTimeUnavailable", code: 0)
#endif
    }
}
