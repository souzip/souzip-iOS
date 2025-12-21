import Foundation
import UserDefaults
import Utils

public protocol UserLocalDataSource {
    func saveUser(_ user: LoginUserResponse)
    func getUser() -> LoginUserResponse?
    func deleteUser()

    func saveNeedsOnboarding(_ value: Bool)
    func getNeedsOnboarding() -> Bool
}

public final class DefaultUserLocalDataSource: UserLocalDataSource {
    private let storage: UserDefaultsStorage

    public init(storage: UserDefaultsStorage) {
        self.storage = storage
    }

    public func saveUser(_ user: LoginUserResponse) {
        try? storage.setEncodable(user, for: UserDefaultsKeys.cachedUser)
    }

    public func getUser() -> LoginUserResponse? {
        try? storage.getDecodable(from: UserDefaultsKeys.cachedUser)
    }

    public func deleteUser() {
        storage.remove(UserDefaultsKeys.cachedUser)
    }

    public func saveNeedsOnboarding(_ value: Bool) {
        storage.set(value, for: UserDefaultsKeys.needsOnboarding)
    }

    public func getNeedsOnboarding() -> Bool {
        storage.get(UserDefaultsKeys.needsOnboarding)
    }
}
