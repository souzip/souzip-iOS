public protocol OAuthService {
    func login() async throws -> String
}

public enum OAuthPlatform: String, Codable {
    case kakao
    case google
    case apple

    // API 경로
    public var apiPath: String {
        rawValue
    }
}
