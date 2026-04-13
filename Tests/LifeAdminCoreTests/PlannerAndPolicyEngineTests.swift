import XCTest
@testable import LifeAdminCore

final class PlannerAndPolicyEngineTests: XCTestCase {
    func testDashboardPlannerAssignsBuckets() {
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let cycles: [Cycle] = [
            .init(
                id: "overdue",
                title: "Overdue Item",
                type: .document,
                nextDueDate: now.addingTimeInterval(-86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: "u1"
            ),
            .init(
                id: "soon",
                title: "Soon Item",
                type: .tax,
                nextDueDate: now.addingTimeInterval(3 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: "u1"
            ),
            .init(
                id: "later",
                title: "Later Item",
                type: .custom,
                nextDueDate: now.addingTimeInterval(120 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: "u1"
            )
        ]

        let snapshots = DashboardPlanner.snapshot(cycles: cycles, now: now, soonThresholdDays: 30)
        XCTAssertEqual(snapshots.first(where: { $0.cycle.id == "overdue" })?.bucket, .overdue)
        XCTAssertEqual(snapshots.first(where: { $0.cycle.id == "soon" })?.bucket, .soon)
        XCTAssertEqual(snapshots.first(where: { $0.cycle.id == "later" })?.bucket, .later)
    }

    func testPolicyEngineDueInDaysAndOverdueActions() {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let cycles: [Cycle] = [
            .init(
                id: "due7",
                title: "Passport",
                type: .document,
                nextDueDate: now.addingTimeInterval(7 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 10),
                ownerUid: "u1"
            ),
            .init(
                id: "late",
                title: "Vehicle Registration",
                type: .document,
                nextDueDate: now.addingTimeInterval(-2 * 86_400),
                recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
                ownerUid: "u1"
            )
        ]

        let rules: [PolicyRule] = [
            .init(
                id: "r1",
                name: "7 day reminder",
                enabled: true,
                triggerType: .dueInDays,
                triggerConfig: ["days": "7"],
                actionType: .pushNotify,
                actionConfig: [:],
                priority: 10
            ),
            .init(
                id: "r2",
                name: "Overdue escalation",
                enabled: true,
                triggerType: .overdue,
                triggerConfig: [:],
                actionType: .escalate,
                actionConfig: ["channel": "in_app"],
                priority: 100
            )
        ]

        let actions = PolicyEngine.evaluate(cycles: cycles, rules: rules, now: now)
        XCTAssertEqual(actions.count, 2)

        XCTAssertTrue(actions.contains { $0.ruleId == "r1" && $0.cycleId == "due7" })
        XCTAssertTrue(actions.contains { $0.ruleId == "r2" && $0.cycleId == "late" })
    }
}
