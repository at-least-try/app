#if canImport(SwiftUI)
import SwiftUI
import LifeAdminCore

struct DashboardScreen: View {
    @StateObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            List {
                if let error = viewModel.errorMessage {
                    Section("Error") {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }

                if viewModel.isLoading {
                    Section {
                        ProgressView("Loading dashboard...")
                    }
                }

                dashboardSection(title: "Overdue", items: viewModel.overdue, tint: .red)
                dashboardSection(title: "Due Soon", items: viewModel.soon, tint: .orange)
                dashboardSection(title: "Upcoming", items: viewModel.upcoming, tint: .blue)
                dashboardSection(title: "Later", items: viewModel.later, tint: .green)

                Section("Triggered Actions") {
                    if viewModel.actions.isEmpty {
                        Text("No triggered actions")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(viewModel.actions.enumerated()), id: \.offset) { _, action in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(action.actionType.rawValue)
                                    .font(.headline)
                                Text(action.reason)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Life Admin")
            .task {
                await viewModel.load()
            }
        }
    }

    @ViewBuilder
    private func dashboardSection(title: String, items: [CycleSnapshot], tint: Color) -> some View {
        Section(title) {
            if items.isEmpty {
                Text("No items")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(items, id: \.cycle.id) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.cycle.title)
                                .font(.body.weight(.semibold))
                            Text("\(item.daysUntilDue) day(s)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.cycle.criticality.rawValue.capitalized)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(tint.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }
}
#endif
