public protocol TokenRefresher {
    func getAccessToken() async throws -> String?
    func refreshToken() async throws
    func clearTokens() async throws
}
