import Foundation
import LifeAdminCore

#if canImport(SwiftUI)
import SwiftUI

@MainActor
final class DesktopDashboardModel: ObservableObject {
    @Published var result: DashboardResult?
    @Published var error: String?

    private let repository = InMemoryCycleRepository()
    private let owner = "desktop-preview"

    func load() async {
        do {
            try await seedIfNeeded()
            let rules: [PolicyRule] = [
                .init(
                    id: "overdue",
                    name: "Escalate overdue",
                    enabled: true,
                    triggerType: .overdue,
                    triggerConfig: [:],
                    actionType: .escalate,
                    actionConfig: ["channel": "in_app"],
                    priority: 100
                )
            ]

            let useCase = DashboardUseCase(repository: repository)
            result = try await useCase.load(ownerUid: owner, rules: rules)
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func seedIfNeeded() async throws {
        let existing = try await repository.list(ownerUid: owner)
        guard existing.isEmpty else { return }

        let cycles: [Cycle] = [
            .init(
                id: "passport",
                title: "Passport Renewal",
                type: .document,
                criticality: .high,
                nextDueDate: .now.addingTimeInterval(12 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 10),
                ownerUid: owner
            ),
            .init(
                id: "tax",
                title: "Tax Filing",
                type: .tax,
                criticality: .urgent,
                nextDueDate: .now.addingTimeInterval(-3 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: owner
            ),
            .init(
                id: "insurance",
                title: "Insurance Renewal",
                type: .document,
                criticality: .medium,
                nextDueDate: .now.addingTimeInterval(42 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: owner
            )
        ]

        for cycle in cycles {
            try await repository.upsert(cycle)
        }
    }
}

struct DesktopDashboardView: View {
    @StateObject private var model = DesktopDashboardModel()

    var body: some View {
        NavigationSplitView {
            List {
                Label("Dashboard", systemImage: "rectangle.grid.2x2")
                Label("Cycles", systemImage: "repeat")
                Label("Policy Engine", systemImage: "bolt")
                Label("Settings", systemImage: "gear")
            }
            .navigationTitle("Life Admin")
        } detail: {
            VStack(alignment: .leading, spacing: 12) {
                Text("Life Admin Desktop")
                    .font(.largeTitle.bold())
                Text("Simulation shell for desktop MVP")
                    .foregroundStyle(.secondary)

                if let error = model.error {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                }

                if let result = model.result {
                    Text("Overdue: \(result.overdue.count) · Soon: \(result.soon.count) · Upcoming: \(result.upcoming.count)")
                        .font(.headline)

                    GroupBox("Triggered Actions") {
                        if result.actions.isEmpty {
                            Text("No actions")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(Array(result.actions.enumerated()), id: \.offset) { _, action in
                                Text("• \(action.reason)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                } else {
                    ProgressView("Loading...")
                }

                Spacer()
            }
            .padding(20)
            .task {
                await model.load()
            }
        }
    }
}

@main
struct LifeAdminDesktopApp: App {
    var body: some Scene {
        WindowGroup {
            DesktopDashboardView()
                .frame(minWidth: 980, minHeight: 640)
        }
    }
}

#else

@main
struct LifeAdminDesktopFallback {
    static func main() async {
        let owner = "desktop-fallback"
        let repository = InMemoryCycleRepository()
        let useCase = DashboardUseCase(repository: repository)

        let cycle = Cycle(
            id: "fallback-cycle",
            title: "Fallback Cycle",
            type: .custom,
            nextDueDate: .now,
            recurrenceRule: .init(intervalUnit: .month, intervalValue: 1),
            ownerUid: owner
        )
        try? await repository.upsert(cycle)

        let result = try? await useCase.load(ownerUid: owner, rules: [])
        print("LifeAdminDesktop fallback mode. Cycles loaded: \(result?.totalCycles ?? 0)")
    }
}

#endif
