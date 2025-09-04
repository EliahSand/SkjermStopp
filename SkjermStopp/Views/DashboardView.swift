import SwiftUI

/// Main dashboard showing usage and limit status.
struct DashboardView: View {
    @EnvironmentObject var settings: FocusSettings
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var showingLimit = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.usingMock {
                    Text("Using mock usage data (no Screen Time entitlement).")
                        .font(.footnote)
                        .foregroundColor(.orange)
                }

                Button(action: { showingLimit = true }) {
                    Text("Today's limit: \(format(viewModel.limit))")
                }

                Text("Usage so far: \(format(viewModel.todayUsage))")
                    .font(.largeTitle)
                    .bold()

                VStack {
                    ProgressView(value: viewModel.todayUsage, total: viewModel.limit)
                        .onLongPressGesture {
#if DEBUG
                            viewModel.simulateOveruse()
#endif
                        }
                    Text("\(Int((viewModel.todayUsage / max(viewModel.limit, 1)) * 100))%")
                        .font(.caption)
                }

                statusChip

                Button("Refresh usage now") {
                    Task { await viewModel.refresh() }
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .navigationTitle("SkjermStopp")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingLimit) {
                SetLimitSheet(limitSeconds: Int(viewModel.limit)) { seconds in
                    viewModel.setLimit(seconds)
                }
            }
            .refreshable { await viewModel.refresh() }
            .onAppear { Task { await viewModel.refresh() } }
        }
    }

    private var statusChip: some View {
        Text(viewModel.status == .onTrack ? "On track" : "Failed today")
            .padding(8)
            .background(viewModel.status == .onTrack ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            .foregroundColor(viewModel.status == .onTrack ? .green : .red)
            .cornerRadius(8)
    }

    private func format(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "00:00"
    }
}

#Preview {
    DashboardView()
        .environmentObject(FocusSettings())
        .environmentObject(DashboardViewModel(settings: FocusSettings()))
}
