import Foundation
import Combine

/// Stores user preferences backed by UserDefaults.
final class FocusSettings: ObservableObject {
    @Published var dailyLimitSeconds: Int {
        didSet { save() }
    }
    @Published var notificationsEnabled: Bool {
        didSet { save() }
    }
    @Published var onboardingCompleted: Bool {
        didSet { save() }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let limit = defaults.integer(forKey: Keys.dailyLimit)
        self.dailyLimitSeconds = limit == 0 ? 7200 : limit
        self.notificationsEnabled = defaults.bool(forKey: Keys.notificationsEnabled)
        self.onboardingCompleted = defaults.bool(forKey: Keys.onboardingCompleted)
    }

    private func save() {
        defaults.set(dailyLimitSeconds, forKey: Keys.dailyLimit)
        defaults.set(notificationsEnabled, forKey: Keys.notificationsEnabled)
        defaults.set(onboardingCompleted, forKey: Keys.onboardingCompleted)
    }

    private enum Keys {
        static let dailyLimit = "dailyLimitSeconds"
        static let notificationsEnabled = "notificationsEnabled"
        static let onboardingCompleted = "onboardingCompleted"
    }
}
