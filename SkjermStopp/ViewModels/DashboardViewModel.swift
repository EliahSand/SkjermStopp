import Foundation
import Combine
#if canImport(FamilyControls)
import FamilyControls
#endif

/// View model driving the dashboard UI.
final class DashboardViewModel: ObservableObject {
    enum Status {
        case onTrack
        case failed
    }

    @Published var todayUsage: TimeInterval = 0
    @Published var limit: TimeInterval
    @Published var status: Status = .onTrack
    @Published var usingMock: Bool = true

    private var provider: UsageProvider
    private let settings: FocusSettings
    private let notificationService = NotificationService()
    private var midnightTimer: Timer?

    init(settings: FocusSettings) {
        self.settings = settings
        self.limit = TimeInterval(settings.dailyLimitSeconds)
        self.provider = MockUsageProvider()
        scheduleMidnightReset()
    }

    @MainActor
    private func updateStatus(for usage: TimeInterval) {
        let newStatus: Status = usage > limit ? .failed : .onTrack
        if newStatus == .failed && status != .failed && settings.notificationsEnabled {
            notificationService.scheduleLimitExceededNotification()
        }
        status = newStatus
    }

    func refresh() async {
        do {
            let usage = try await provider.fetchTodayUsage()
            await MainActor.run {
                self.todayUsage = usage
                self.limit = TimeInterval(self.settings.dailyLimitSeconds)
                updateStatus(for: usage)
            }
        } catch {
            // Ignore errors; keep existing state
        }
    }

    func setLimit(_ seconds: Int) {
        settings.dailyLimitSeconds = seconds
        limit = TimeInterval(seconds)
        Task { await refresh() }
    }

    func recheckAuthorization() async {
#if canImport(FamilyControls)
        do {
            let center = AuthorizationCenter.shared
            try await center.requestAuthorization(for: .individual)
            provider = ScreenTimeUsageProvider()
            usingMock = false
        } catch {
            provider = MockUsageProvider()
            usingMock = true
        }
#else
        provider = MockUsageProvider()
        usingMock = true
#endif
        await refresh()
    }

    func requestNotificationPermission() async {
        await notificationService.requestAuthorization()
    }

    private func scheduleMidnightReset() {
        midnightTimer?.invalidate()
        let interval = Date().nextMidnight.timeIntervalSinceNow
        midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { await self?.refresh() }
            self?.scheduleMidnightReset()
        }
    }

#if DEBUG
    func simulateOveruse() {
        if let mock = provider as? MockUsageProvider {
            mock.addDebugUsage()
        }
        Task { await refresh() }
    }
#endif
}
