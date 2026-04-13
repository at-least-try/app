import Foundation

public enum AuthProvider: String, Codable, Sendable {
    case anonymous
    case google
    case emailPassword = "password"
}

public struct AuthSession: Equatable, Sendable {
    public var uid: String
    public var isAnonymous: Bool
    public var linkedProviders: Set<AuthProvider>

    public init(uid: String, isAnonymous: Bool = true, linkedProviders: Set<AuthProvider> = [.anonymous]) {
        self.uid = uid
        self.isAnonymous = isAnonymous
        self.linkedProviders = linkedProviders
    }

    public mutating func link(provider: AuthProvider) {
        linkedProviders.insert(provider)
        if provider != .anonymous {
            isAnonymous = false
        }
    }
}
