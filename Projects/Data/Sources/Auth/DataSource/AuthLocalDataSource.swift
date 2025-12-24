import Foundation
import Keychain
import UserDefaults
import Utils

public protocol AuthLocalDataSource {
    func saveAccessToken(_ token: String) async throws
    func saveRefreshToken(_ token: String) async throws
    func getAccessToken() async throws -> String
    func getRefreshToken() async throws -> String
    func deleteAccessToken() async
    func deleteRefreshToken() async
    func deleteAllTokens() async

    func saveOAuthPlatform(_ platform: OAuthPlatform)
    func getOAuthPlatform() -> OAuthPlatform?
}

public final class DefaultAuthLocalDataSource: AuthLocalDataSource {
    private let keycahinStorage: KeychainStorage
    private let userDefaultsStorage: UserDefaultsStorage

    public init(
        keychainStorage: KeychainStorage,
        userDefaultsStorage: UserDefaultsStorage
    ) {
        keycahinStorage = keychainStorage
        self.userDefaultsStorage = userDefaultsStorage
    }

    // MARK: - Token

    public func saveAccessToken(_ token: String) async throws {
        try await keycahinStorage.save(token, forKey: KeychainKey.accessToken)
    }

    public func saveRefreshToken(_ token: String) async throws {
        try await keycahinStorage.save(token, forKey: KeychainKey.refreshToken)
    }

    public func getAccessToken() async throws -> String {
        guard let token: String = try await keycahinStorage.get(forKey: KeychainKey.accessToken) else {
            throw KeychainError.loadFailed(status: errSecItemNotFound)
        }
        return token
    }

    public func getRefreshToken() async throws -> String {
        guard let token: String = try await keycahinStorage.get(forKey: KeychainKey.refreshToken) else {
            throw KeychainError.loadFailed(status: errSecItemNotFound)
        }
        return token
    }

    public func deleteAccessToken() async {
        try? await keycahinStorage.delete(forKey: KeychainKey.accessToken)
    }

    public func deleteRefreshToken() async {
        try? await keycahinStorage.delete(forKey: KeychainKey.refreshToken)
    }

    public func deleteAllTokens() async {
        await deleteAccessToken()
        await deleteRefreshToken()
    }

    // MARK: - SNS Platform

    public func saveOAuthPlatform(_ platform: OAuthPlatform) {
        try? userDefaultsStorage.setEncodable(platform, for: AuthDefaultsKeys.recentLoginPlatform)
    }

    public func getOAuthPlatform() -> OAuthPlatform? {
        try? userDefaultsStorage.getDecodable(from: AuthDefaultsKeys.recentLoginPlatform)
    }
}
