public protocol UserRepository {
    func getUserProfile() async throws -> UserProfile
    func getUserSouvenirs() async throws -> [SouvenirThumbnail]
    func getLocalUser() -> LoginUser?
    func saveLocalUser(userId: String, nickname: String, needsOnboarding: Bool)
    func deleteLocalUser()
}
