import SwiftUI

@main
struct FocusLimitApp: App {
    @StateObject private var settings: FocusSettings
    @StateObject private var viewModel: DashboardViewModel

    init() {
        let settings = FocusSettings()
        _settings = StateObject(wrappedValue: settings)
        _viewModel = StateObject(wrappedValue: DashboardViewModel(settings: settings))
    }

    var body: some Scene {
        WindowGroup {
            if settings.onboardingCompleted {
                DashboardView()
                    .environmentObject(settings)
                    .environmentObject(viewModel)
            } else {
                OnboardingView()
                    .environmentObject(settings)
                    .environmentObject(viewModel)
            }
        }
    }
}
