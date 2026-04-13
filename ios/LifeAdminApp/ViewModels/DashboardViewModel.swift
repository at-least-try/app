#if canImport(SwiftUI)
import Foundation
import LifeAdminCore

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var overdue: [CycleSnapshot] = []
    @Published var soon: [CycleSnapshot] = []
    @Published var upcoming: [CycleSnapshot] = []
    @Published var later: [CycleSnapshot] = []
    @Published var actions: [EvaluatedAction] = []

    private let ownerUid: String
    private let rules: [PolicyRule]
    private let useCase: DashboardUseCase

    init(ownerUid: String, rules: [PolicyRule], useCase: DashboardUseCase) {
        self.ownerUid = ownerUid
        self.rules = rules
        self.useCase = useCase
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await useCase.load(ownerUid: ownerUid, rules: rules)
            overdue = result.overdue
            soon = result.soon
            upcoming = result.upcoming
            later = result.later
            actions = result.actions
        } catch {
            errorMessage = "Failed to load dashboard: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

extension DashboardViewModel {
    static var preview: DashboardViewModel {
        let owner = "preview-user"
        let repository = InMemoryCycleRepository()
        let useCase = DashboardUseCase(repository: repository)

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

        let model = DashboardViewModel(ownerUid: owner, rules: rules, useCase: useCase)

        Task {
            let seedCycles: [Cycle] = [
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
                    nextDueDate: .now.addingTimeInterval(-2 * 86_400),
                    recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                    ownerUid: owner
                )
            ]

            for cycle in seedCycles {
                try? await repository.upsert(cycle)
            }

            await model.load()
        }

        return model
    }
}
#endif
