import Foundation
import Logger
import Security
import Utils

public protocol KeychainStorage: Sendable {
    func save(_ value: some Codable, forKey key: KeychainKey) async throws
    func get<T: Codable>(forKey key: KeychainKey) async throws -> T?
    func delete(forKey key: KeychainKey) async throws
    func deleteAll() async throws
}

public actor DefaultKeychainStorage: KeychainStorage {
    private let service: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(service: String) {
        self.service = service
    }

    public func save(_ value: some Codable, forKey key: KeychainKey) async throws {
        let data: Data
        do {
            data = try encoder.encode(value)
        } catch {
            Logger.shared.keychainError(
                message: KeychainError.encodingFailed.errorDescription,
                key: key.rawValue
            )
            throw KeychainError.encodingFailed
        }

        // 동일 키 덮어쓰기 전에 삭제 (없어도 OK)
        try await delete(forKey: key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            Logger.shared.keychainError(
                message: KeychainError.saveFailed(status: status).errorDescription,
                key: key.rawValue
            )
            throw KeychainError.saveFailed(status: status)
        }
    }

    public func get<T: Codable>(forKey key: KeychainKey) async throws -> T {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            break

        case errSecItemNotFound:
            Logger.shared.keychainError(
                message: KeychainError.itemNotFound.errorDescription,
                key: key.rawValue
            )
            throw KeychainError.itemNotFound

        default:
            Logger.shared.keychainError(
                message: KeychainError.loadFailed(status: status).errorDescription,
                key: key.rawValue
            )
            throw KeychainError.loadFailed(status: status)
        }

        guard let data = result as? Data else {
            Logger.shared.keychainError(
                message: KeychainError.decodingFailed.errorDescription,
                key: key.rawValue
            )
            throw KeychainError.decodingFailed
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            Logger.shared.keychainError(
                message: KeychainError.decodingFailed.errorDescription,
                key: key.rawValue
            )
            throw KeychainError.decodingFailed
        }
    }

    public func delete(forKey key: KeychainKey) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            Logger.shared.keychainError(
                message: KeychainError.deleteFailed(status: status).errorDescription,
                key: key.rawValue
            )
            throw KeychainError.deleteFailed(status: status)
        }
    }

    public func deleteAll() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            Logger.shared.keychainError(
                message: KeychainError.deleteFailed(status: status).errorDescription,
                key: "service=\(service)"
            )
            throw KeychainError.deleteFailed(status: status)
        }
    }
}
