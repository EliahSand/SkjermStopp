import SwiftUI

/// Settings screen for notification toggle and info.
struct SettingsView: View {
    @EnvironmentObject var settings: FocusSettings
    @EnvironmentObject var viewModel: DashboardViewModel

    var body: some View {
        Form {
            Toggle("Send notification when I exceed the limit", isOn: $settings.notificationsEnabled)
            HStack {
                Text("Data source")
                Spacer()
                Text(viewModel.usingMock ? "Mock" : "Screen Time")
                    .foregroundColor(.secondary)
            }
            Button("Re-request Screen Time access") {
                Task { await viewModel.recheckAuthorization() }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(FocusSettings())
        .environmentObject(DashboardViewModel(settings: FocusSettings()))
}
