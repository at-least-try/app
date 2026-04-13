import Foundation

public struct EvaluatedAction: Equatable, Sendable {
    public var ruleId: String
    public var cycleId: String
    public var actionType: RuleActionType
    public var reason: String
}

public struct PolicyEngine {
    public static func evaluate(
        cycles: [Cycle],
        rules: [PolicyRule],
        now: Date = .now,
        calendar: Calendar = .current
    ) -> [EvaluatedAction] {
        let sortedRules = rules
            .filter(\.enabled)
            .sorted { $0.priority > $1.priority }

        var actions: [EvaluatedAction] = []

        for rule in sortedRules {
            for cycle in cycles where matches(rule: rule, cycle: cycle, now: now, calendar: calendar) {
                actions.append(
                    EvaluatedAction(
                        ruleId: rule.id,
                        cycleId: cycle.id,
                        actionType: rule.actionType,
                        reason: reason(rule: rule, cycle: cycle, now: now, calendar: calendar)
                    )
                )
            }
        }

        return actions
    }

    private static func matches(
        rule: PolicyRule,
        cycle: Cycle,
        now: Date,
        calendar: Calendar
    ) -> Bool {
        switch rule.triggerType {
        case .dueInDays:
            guard let expected = rule.triggerConfig["days"], let threshold = Int(expected) else {
                return false
            }
            let days = daysBetween(start: now, end: cycle.nextDueDate, calendar: calendar)
            return days == threshold

        case .overdue:
            return cycle.nextDueDate < now

        case .statusChanged:
            guard let statusValue = rule.triggerConfig["status"],
                  let status = CycleStatus(rawValue: statusValue) else {
                return false
            }
            return cycle.status == status
        }
    }

    private static func reason(
        rule: PolicyRule,
        cycle: Cycle,
        now: Date,
        calendar: Calendar
    ) -> String {
        switch rule.triggerType {
        case .dueInDays:
            return "\(cycle.title) matches due-in-days trigger"
        case .overdue:
            let days = abs(daysBetween(start: cycle.nextDueDate, end: now, calendar: calendar))
            return "\(cycle.title) is overdue by \(days) day(s)"
        case .statusChanged:
            return "\(cycle.title) matches status trigger"
        }
    }

    private static func daysBetween(start: Date, end: Date, calendar: Calendar) -> Int {
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        return calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 0
    }
}
