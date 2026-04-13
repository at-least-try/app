import Foundation

public enum DueBucket: String, Equatable, Sendable {
    case overdue
    case soon
    case upcoming
    case later
}

public struct CycleSnapshot: Equatable, Sendable {
    public var cycle: Cycle
    public var bucket: DueBucket
    public var daysUntilDue: Int
}

public struct DashboardPlanner {
    public static func snapshot(
        cycles: [Cycle],
        now: Date = .now,
        soonThresholdDays: Int = 30,
        calendar: Calendar = .current
    ) -> [CycleSnapshot] {
        cycles
            .map { cycle in
                let days = daysBetween(start: now, end: cycle.nextDueDate, calendar: calendar)
                let bucket: DueBucket
                if days < 0 {
                    bucket = .overdue
                } else if days <= soonThresholdDays {
                    bucket = .soon
                } else if days <= 90 {
                    bucket = .upcoming
                } else {
                    bucket = .later
                }
                return CycleSnapshot(cycle: cycle, bucket: bucket, daysUntilDue: days)
            }
            .sorted { $0.cycle.nextDueDate < $1.cycle.nextDueDate }
    }

    private static func daysBetween(start: Date, end: Date, calendar: Calendar) -> Int {
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        return calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 0
    }
}
