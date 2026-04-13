import XCTest
@testable import LifeAdminCore

final class DashboardUseCaseTests: XCTestCase {
    func testLoadGroupsCyclesAndProducesActions() async throws {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let owner = "u-dashboard"
        let repository = InMemoryCycleRepository()
        let useCase = DashboardUseCase(repository: repository)

        let cycles: [Cycle] = [
            .init(
                id: "late",
                title: "Late Subscription",
                type: .subscription,
                nextDueDate: now.addingTimeInterval(-86_400),
                recurrenceRule: .init(intervalUnit: .month, intervalValue: 1),
                ownerUid: owner
            ),
            .init(
                id: "soon",
                title: "Soon Tax",
                type: .tax,
                nextDueDate: now.addingTimeInterval(3 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: owner
            ),
            .init(
                id: "upcoming",
                title: "Car Registration",
                type: .document,
                nextDueDate: now.addingTimeInterval(60 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: owner
            )
        ]

        for cycle in cycles {
            try await repository.upsert(cycle)
        }

        let rules: [PolicyRule] = [
            .init(
                id: "r-overdue",
                name: "Escalate Overdue",
                enabled: true,
                triggerType: .overdue,
                triggerConfig: [:],
                actionType: .escalate,
                actionConfig: ["channel": "in_app"],
                priority: 100
            )
        ]

        let result = try await useCase.load(ownerUid: owner, rules: rules, now: now)

        XCTAssertEqual(result.overdue.map(\.cycle.id), ["late"])
        XCTAssertEqual(result.soon.map(\.cycle.id), ["soon"])
        XCTAssertEqual(result.upcoming.map(\.cycle.id), ["upcoming"])
        XCTAssertTrue(result.later.isEmpty)
        XCTAssertEqual(result.totalCycles, 3)
        XCTAssertEqual(result.actions.count, 1)
        XCTAssertEqual(result.actions.first?.cycleId, "late")
    }
}
