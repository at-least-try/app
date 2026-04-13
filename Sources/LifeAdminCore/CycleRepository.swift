import Foundation

public protocol CycleRepository: Sendable {
    func list(ownerUid: String) async throws -> [Cycle]
    func upsert(_ cycle: Cycle) async throws
    func delete(cycleId: String, ownerUid: String) async throws
}

public enum RepositoryError: Error, Equatable {
    case cycleNotFound
    case ownerMismatch
}
