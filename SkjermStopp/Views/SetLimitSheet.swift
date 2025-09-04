import SwiftUI

/// Sheet allowing the user to choose a new daily limit.
struct SetLimitSheet: View {
    @State private var hours: Int
    @State private var minutes: Int
    let onSave: (Int) -> Void
    @Environment(\.dismiss) private var dismiss

    init(limitSeconds: Int, onSave: @escaping (Int) -> Void) {
        _hours = State(initialValue: limitSeconds / 3600)
        _minutes = State(initialValue: (limitSeconds % 3600) / 60)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24) { Text("\($0) h").tag($0) }
                }
                .pickerStyle(.wheel)

                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) { Text("\($0) m").tag($0) }
                }
                .pickerStyle(.wheel)
            }
            .navigationTitle("Set Limit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(hours * 3600 + minutes * 60)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SetLimitSheet(limitSeconds: 3600) { _ in }
}
