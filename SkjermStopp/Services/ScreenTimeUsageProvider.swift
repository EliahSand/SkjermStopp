import Foundation
import _DeviceActivity_SwiftUI


#if canImport(DeviceActivity)
import DeviceActivity
import FamilyControls
#endif

/// Usage provider backed by Apple's Screen Time APIs.
struct ScreenTimeUsageProvider: UsageProvider {
    func fetchTodayUsage() async throws -> TimeInterval {
#if canImport(DeviceActivity)
        // start of today 00:00
        let startComponent = DateComponents(hour: 0, minute: 0)
        let endComponent = Calendar.current.dateComponents([.hour, .minute], from: Date())
        
        let center = DeviceActivityCenter()
        let report: DeviceActivityReport = try await center.activity(
                    for: DeviceActivityEvent.Name("daily"),
                    from: startComponent,
                    to: endComponent
                )

                let totalActivity: TimeInterval = report.categories.values.reduce(0) { partial, data in
                    partial + data.totalActivityDuration
                }

            return totalActivity
        
        var totalDuration: TimeInterval = 0

                for appReport in report.pplications.values {
                    totalDuration += appReport.totalActivityDuration
                }

                for categoryReport in report.categories.values {
                    totalDuration += categoryReport.totalActivityDuration
                }

            return totalDuration
        
        /*
        gammel versjon
        let schedule = DeviceActivitySchedule(intervalStart: startComponent,
                                                intervalEnd: endComponent,
                                                repeats: false)
        
        let center = DeviceActivityCenter()
        let report: DeviceActivityReport = try await center.activityReport(
                    for: DeviceActivityEvent.Name("daily"),
                    from: startComponent,
                    to: endComponent
                )
        return report.totalActivityDuration
        */
#else
        throw NSError(domain: "ScreenTimeUnavailable", code: 0)
#endif
    }
}
