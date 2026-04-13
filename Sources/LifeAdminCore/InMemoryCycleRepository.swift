import Foundation

public actor InMemoryCycleRepository: CycleRepository {
    private var cyclesByOwner: [String: [String: Cycle]] = [:]

    public init() {}

    public func list(ownerUid: String) async throws -> [Cycle] {
        let items = cyclesByOwner[ownerUid, default: [:]].values
        return items.sorted { $0.nextDueDate < $1.nextDueDate }
    }

    public func upsert(_ cycle: Cycle) async throws {
        var ownerCycles = cyclesByOwner[cycle.ownerUid, default: [:]]
        ownerCycles[cycle.id] = cycle
        cyclesByOwner[cycle.ownerUid] = ownerCycles
    }

    public func delete(cycleId: String, ownerUid: String) async throws {
        guard var ownerCycles = cyclesByOwner[ownerUid] else {
            throw RepositoryError.cycleNotFound
        }
        guard ownerCycles.removeValue(forKey: cycleId) != nil else {
            throw RepositoryError.cycleNotFound
        }
        cyclesByOwner[ownerUid] = ownerCycles
    }
}
