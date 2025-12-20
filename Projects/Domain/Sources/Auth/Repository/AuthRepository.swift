public protocol AuthRepository {
    func login(provider: AuthProvider) async throws -> LoginResult
    func logout() async throws
    func withdraw() async throws
    func checkLoginStatus() async -> Bool
    func refreshToken() async throws -> LoginResult
    func loadRecentLoginProvider() -> AuthProvider?
}
