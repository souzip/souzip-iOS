import Foundation
import UserDefaults
import Utils

public protocol UserLocalDataSource {
    func saveUser(_ user: LoginUserResponse) throws
    func getUser() throws -> LoginUserResponse?
    func deleteUser()
}

public final class DefaultUserLocalDataSource: UserLocalDataSource {
    private let storage: UserDefaultsStorage

    public init(storage: UserDefaultsStorage) {
        self.storage = storage
    }

    public func saveUser(_ user: LoginUserResponse) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        storage.set(data, for: UserDefaultsKeys.cachedUser)
    }

    public func getUser() -> LoginUserResponse? {
        let data: Data? = storage.get(UserDefaultsKeys.cachedUser)
        guard let data else { return nil }
        return try? JSONDecoder().decode(LoginUserResponse.self, from: data)
    }

    public func deleteUser() {
        storage.remove(UserDefaultsKeys.cachedUser)
    }
}
