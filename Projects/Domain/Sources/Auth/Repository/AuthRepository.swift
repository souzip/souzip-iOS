public protocol AuthRepository {
    func login(provider: AuthProvider) async throws -> LoginUser
    func logout() async throws
    func withdraw() async throws
    func checkLoginStatus() async -> Bool
    func refreshToken() async throws -> LoginUser
    func loadRecentLoginProvider() -> AuthProvider?
    func deleteAllTokens() async
}
