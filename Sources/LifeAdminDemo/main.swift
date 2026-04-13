import Foundation
import LifeAdminCore

let now = Date()
let owner = "demo-user"
let repository = InMemoryCycleRepository()
let useCase = DashboardUseCase(repository: repository)

let cycles: [Cycle] = [
    .init(
        id: "passport",
        title: "Passport Renewal",
        type: .document,
        criticality: .high,
        nextDueDate: now.addingTimeInterval(12 * 86_400),
        recurrenceRule: .init(intervalUnit: .year, intervalValue: 10),
        ownerUid: owner
    ),
    .init(
        id: "tax",
        title: "Tax Filing",
        type: .tax,
        criticality: .urgent,
        nextDueDate: now.addingTimeInterval(2 * 86_400),
        recurrenceRule: .init(intervalUnit: .year, intervalValue: 1),
        ownerUid: owner
    ),
    .init(
        id: "streaming",
        title: "Streaming Subscription",
        type: .subscription,
        criticality: .medium,
        nextDueDate: now.addingTimeInterval(-1 * 86_400),
        recurrenceRule: .init(intervalUnit: .month, intervalValue: 1),
        ownerUid: owner
    )
]

let rules: [PolicyRule] = [
    .init(
        id: "due_7",
        name: "7 day heads up",
        enabled: true,
        triggerType: .dueInDays,
        triggerConfig: ["days": "7"],
        actionType: .pushNotify,
        actionConfig: ["channel": "push"],
        priority: 5
    ),
    .init(
        id: "overdue_escalate",
        name: "Escalate overdue",
        enabled: true,
        triggerType: .overdue,
        triggerConfig: [:],
        actionType: .escalate,
        actionConfig: ["channel": "in_app"],
        priority: 100
    )
]

for cycle in cycles {
    try await repository.upsert(cycle)
}

print("=== LIFE ADMIN MVP DEMO ===")
print("Now: \(now)")

let result = try await useCase.load(ownerUid: owner, rules: rules, now: now)

print("\n[1] Dashboard Buckets")
for item in result.overdue + result.soon + result.upcoming + result.later {
    print("- \(item.cycle.title): \(item.bucket.rawValue.uppercased()) (\(item.daysUntilDue)d)")
}

print("\n[2] Policy Engine Actions")
if result.actions.isEmpty {
    print("- No actions triggered")
} else {
    for action in result.actions {
        print("- Rule=\(action.ruleId) Cycle=\(action.cycleId) Action=\(action.actionType.rawValue) Reason=\(action.reason)")
    }
}

print("\n[3] Next Milestone")
print("- Core use case is ready to feed SwiftUI Dashboard view models.")
