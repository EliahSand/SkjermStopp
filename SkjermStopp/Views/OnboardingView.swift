import SwiftUI

/// First-launch onboarding requesting permissions.
struct OnboardingView: View {
    @EnvironmentObject var settings: FocusSettings
    @EnvironmentObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Set a daily phone time limit. We'll read Screen Time and warn if you go over.")
                .multilineTextAlignment(.center)
            Button("Continue") {
                Task {
                    await viewModel.recheckAuthorization()
                    await viewModel.requestNotificationPermission()
                    settings.onboardingCompleted = true
                }
            }
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
        .environmentObject(FocusSettings())
        .environmentObject(DashboardViewModel(settings: FocusSettings()))
}
