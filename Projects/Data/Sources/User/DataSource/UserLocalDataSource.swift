import Foundation
import UserDefaults
import Utils

public protocol UserLocalDataSource {
    func saveUserId(_ userId: String)
    func saveUserNickname(_ nickname: String)
    func saveNeedsOnboarding(_ needs: Bool)

    func getUserId() -> String
    func getUserNickname() -> String
    func getNeedsOnboarding() -> Bool

    func getUser() -> UserDTO?
    func deleteUser()
}

public final class DefaultUserLocalDataSource: UserLocalDataSource {
    private let storage: UserDefaultsStorage

    public init(storage: UserDefaultsStorage) {
        self.storage = storage
    }

    // MARK: - Save

    public func saveUserId(_ userId: String) {
        storage.set(userId, for: UserDefaultsKeys.userId)
    }

    public func saveUserNickname(_ nickname: String) {
        storage.set(nickname, for: UserDefaultsKeys.userNickname)
    }

    public func saveNeedsOnboarding(_ needs: Bool) {
        storage.set(needs, for: UserDefaultsKeys.needsOnboarding)
    }

    // MARK: - Get

    public func getUserId() -> String {
        storage.get(UserDefaultsKeys.userId)
    }

    public func getUserNickname() -> String {
        storage.get(UserDefaultsKeys.userNickname)
    }

    public func getNeedsOnboarding() -> Bool {
        storage.get(UserDefaultsKeys.needsOnboarding)
    }

    public func getUser() -> UserDTO? {
        let userId = getUserId()
        let nickname = getUserNickname()
        let needsOnboarding = getNeedsOnboarding()

        guard !userId.isEmpty else { return nil }

        return UserDTO(
            userId: userId,
            nickname: nickname,
            needsOnboarding: needsOnboarding
        )
    }

    // MARK: - Delete

    public func deleteUser() {
        storage.remove(UserDefaultsKeys.userId)
        storage.remove(UserDefaultsKeys.userNickname)
        storage.remove(UserDefaultsKeys.needsOnboarding)
    }
}
