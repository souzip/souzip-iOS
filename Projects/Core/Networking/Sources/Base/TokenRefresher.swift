public protocol TokenRefresher {
    func getAccessToken() throws -> String?
    func refreshToken() async throws
    func clearTokens() throws
}
