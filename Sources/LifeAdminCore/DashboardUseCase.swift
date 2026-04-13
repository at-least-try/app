import Foundation

public struct DashboardResult: Equatable, Sendable {
    public var overdue: [CycleSnapshot]
    public var soon: [CycleSnapshot]
    public var upcoming: [CycleSnapshot]
    public var later: [CycleSnapshot]
    public var actions: [EvaluatedAction]

    public var totalCycles: Int {
        overdue.count + soon.count + upcoming.count + later.count
    }
}

public struct DashboardUseCase {
    private let repository: CycleRepository

    public init(repository: CycleRepository) {
        self.repository = repository
    }

    public func load(
        ownerUid: String,
        rules: [PolicyRule],
        now: Date = .now,
        soonThresholdDays: Int = 30
    ) async throws -> DashboardResult {
        let cycles = try await repository.list(ownerUid: ownerUid)
        let snapshots = DashboardPlanner.snapshot(
            cycles: cycles,
            now: now,
            soonThresholdDays: soonThresholdDays
        )
        let actions = PolicyEngine.evaluate(cycles: cycles, rules: rules, now: now)

        return DashboardResult(
            overdue: snapshots.filter { $0.bucket == .overdue },
            soon: snapshots.filter { $0.bucket == .soon },
            upcoming: snapshots.filter { $0.bucket == .upcoming },
            later: snapshots.filter { $0.bucket == .later },
            actions: actions
        )
    }
}
