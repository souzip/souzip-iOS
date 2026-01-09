// MARK: - Login

public struct LoginResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let user: LoginUserResponse
    public let needsOnboarding: Bool
}

public struct LoginUserResponse: Decodable, Encodable {
    public let userId: String
    public let nickname: String
}

// MARK: - Refresh

public struct RefreshResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
