import Foundation
import Keychain
import Utils

public protocol AuthLocalDataSource {
    func saveAccessToken(_ token: String) async throws
    func saveRefreshToken(_ token: String) async throws
    func getAccessToken() async throws -> String
    func getRefreshToken() async throws -> String
    func deleteAccessToken() async throws
    func deleteRefreshToken() async throws
    func deleteAllTokens() async throws
}

public final class DefaultAuthLocalDataSource: AuthLocalDataSource {
    private let storage: KeychainStorage

    public init(storage: KeychainStorage) {
        self.storage = storage
    }

    public func saveAccessToken(_ token: String) async throws {
        try await storage.save(token, forKey: KeychainKey.accessToken)
    }

    public func saveRefreshToken(_ token: String) async throws {
        try await storage.save(token, forKey: KeychainKey.refreshToken)
    }

    public func getAccessToken() async throws -> String {
        guard let token: String = try await storage.get(forKey: KeychainKey.accessToken) else {
            throw KeychainError.loadFailed(status: errSecItemNotFound)
        }
        return token
    }

    public func getRefreshToken() async throws -> String {
        guard let token: String = try await storage.get(forKey: KeychainKey.refreshToken) else {
            throw KeychainError.loadFailed(status: errSecItemNotFound)
        }
        return token
    }

    public func deleteAccessToken() async throws {
        try await storage.delete(forKey: KeychainKey.accessToken)
    }

    public func deleteRefreshToken() async throws {
        try await storage.delete(forKey: KeychainKey.refreshToken)
    }

    public func deleteAllTokens() async throws {
        try? await deleteAccessToken()
        try? await deleteRefreshToken()
    }
}
