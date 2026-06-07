import Foundation
import Utils

public actor DeviceIdStore: DeviceIdProviding {
    private let keychain: KeychainStorage
    private var cachedDeviceId: String?

    public init(keychain: KeychainStorage) {
        self.keychain = keychain
    }

    public func deviceId() async throws -> String {
        if let cachedDeviceId {
            return cachedDeviceId
        }

        do {
            if let stored: String = try await keychain.get(forKey: KeychainKey.deviceId) {
                cachedDeviceId = stored
                return stored
            }
        } catch KeychainError.itemNotFound {
            // 저장된 ID가 없을 때만 새 ID를 발급합니다.
        } catch {
            throw error
        }

        let newDeviceId = UUID().uuidString
        try await keychain.save(newDeviceId, forKey: KeychainKey.deviceId)
        cachedDeviceId = newDeviceId
        return newDeviceId
    }
}
