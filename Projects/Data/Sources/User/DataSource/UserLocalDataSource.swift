import Foundation
import UserDefaults
import Utils

public protocol UserLocalDataSource {
    func saveUser(_ user: LoginUserResponse)
    func getUser() -> LoginUserResponse?
    func deleteUser()
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
}
