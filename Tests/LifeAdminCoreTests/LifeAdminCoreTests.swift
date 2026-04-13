import XCTest
@testable import LifeAdminCore

final class LifeAdminCoreTests: XCTestCase {
    func testRecurrenceRuleClampsIntervalToMinimumOne() {
        let rule = RecurrenceRule(intervalUnit: .month, intervalValue: 0)
        XCTAssertEqual(rule.intervalValue, 1)
    }

    func testCycleLeadTimesAreNormalizedAndSortedDescending() {
        let cycle = Cycle(
            id: "c1",
            title: " Passport Renewal ",
            type: .document,
            nextDueDate: .now,
            recurrenceRule: .init(intervalUnit: .year, intervalValue: 10),
            leadTimesDays: [7, -2, 30, 7, 1],
            ownerUid: "u1"
        )

        XCTAssertEqual(cycle.title, "Passport Renewal")
        XCTAssertEqual(cycle.leadTimesDays, [30, 7, 1])
    }

    func testCycleRollForwardUpdatesDueDateAndStatus() {
        var cycle = Cycle(
            id: "c2",
            title: "Tax Filing",
            type: .tax,
            status: .completed,
            nextDueDate: .now,
            recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
            ownerUid: "u1"
        )

        let previous = cycle.nextDueDate
        cycle.rollForward()

        XCTAssertGreaterThan(cycle.nextDueDate, previous)
        XCTAssertEqual(cycle.status, .active)
    }

    func testInMemoryRepositoryUpsertListDeleteFlow() async throws {
        let repository = InMemoryCycleRepository()
        let cycle = Cycle(
            id: "c3",
            title: "Car Registration",
            type: .document,
            nextDueDate: .now,
            recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
            ownerUid: "u2"
        )

        try await repository.upsert(cycle)
        let list = try await repository.list(ownerUid: "u2")
        XCTAssertEqual(list.count, 1)

        try await repository.delete(cycleId: "c3", ownerUid: "u2")
        let empty = try await repository.list(ownerUid: "u2")
        XCTAssertTrue(empty.isEmpty)
    }

    func testAuthSessionLinkingTurnsOffAnonymousFlag() {
        var session = AuthSession(uid: "anon-1")
        XCTAssertTrue(session.isAnonymous)

        session.link(provider: .google)

        XCTAssertFalse(session.isAnonymous)
        XCTAssertTrue(session.linkedProviders.contains(.anonymous))
        XCTAssertTrue(session.linkedProviders.contains(.google))
    }
}
