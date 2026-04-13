import Foundation

public enum CycleType: String, Codable, CaseIterable, Sendable {
    case document
    case tax
    case subscription
    case medicalBill = "medical_bill"
    case relationship
    case custom
}

public enum CycleStatus: String, Codable, Sendable {
    case active
    case paused
    case completed
}

public enum Criticality: String, Codable, Sendable {
    case low
    case medium
    case high
    case urgent
}

public enum IntervalUnit: String, Codable, Sendable {
    case day
    case week
    case month
    case year
}

public struct RecurrenceRule: Codable, Equatable, Sendable {
    public var intervalUnit: IntervalUnit
    public var intervalValue: Int

    public init(intervalUnit: IntervalUnit, intervalValue: Int) {
        self.intervalUnit = intervalUnit
        self.intervalValue = max(1, intervalValue)
    }

    public func nextDate(from date: Date, calendar: Calendar = .current) -> Date? {
        let component: Calendar.Component
        switch intervalUnit {
        case .day: component = .day
        case .week: component = .weekOfYear
        case .month: component = .month
        case .year: component = .year
        }
        return calendar.date(byAdding: component, value: intervalValue, to: date)
    }
}

public struct Cycle: Identifiable, Codable, Equatable, Sendable {
    public var id: String
    public var title: String
    public var type: CycleType
    public var status: CycleStatus
    public var criticality: Criticality
    public var nextDueDate: Date
    public var recurrenceRule: RecurrenceRule
    public var leadTimesDays: [Int]
    public var ownerUid: String
    public var notes: String?
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: String,
        title: String,
        type: CycleType,
        status: CycleStatus = .active,
        criticality: Criticality = .medium,
        nextDueDate: Date,
        recurrenceRule: RecurrenceRule,
        leadTimesDays: [Int] = [30, 7, 1],
        ownerUid: String,
        notes: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.type = type
        self.status = status
        self.criticality = criticality
        self.nextDueDate = nextDueDate
        self.recurrenceRule = recurrenceRule
        self.leadTimesDays = leadTimesDays
            .filter { $0 >= 0 }
            .uniqued()
            .sorted(by: >)
        self.ownerUid = ownerUid
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public mutating func markCompleted(now: Date = .now) {
        status = .completed
        updatedAt = now
    }

    public mutating func rollForward(now: Date = .now, calendar: Calendar = .current) {
        guard let nextDate = recurrenceRule.nextDate(from: nextDueDate, calendar: calendar) else {
            return
        }
        nextDueDate = nextDate
        status = .active
        updatedAt = now
    }
}

public enum RuleTriggerType: String, Codable, Sendable {
    case dueInDays = "due_in_days"
    case overdue
    case statusChanged = "status_changed"
}

public enum RuleActionType: String, Codable, Sendable {
    case pushNotify = "push_notify"
    case createIntegrationTask = "create_integration_task"
    case escalate
}

public struct PolicyRule: Identifiable, Codable, Equatable, Sendable {
    public var id: String
    public var name: String
    public var enabled: Bool
    public var triggerType: RuleTriggerType
    public var triggerConfig: [String: String]
    public var actionType: RuleActionType
    public var actionConfig: [String: String]
    public var priority: Int
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: String,
        name: String,
        enabled: Bool,
        triggerType: RuleTriggerType,
        triggerConfig: [String: String],
        actionType: RuleActionType,
        actionConfig: [String: String],
        priority: Int,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.enabled = enabled
        self.triggerType = triggerType
        self.triggerConfig = triggerConfig
        self.actionType = actionType
        self.actionConfig = actionConfig
        self.priority = max(0, priority)
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        Array(Set(self))
    }
}
