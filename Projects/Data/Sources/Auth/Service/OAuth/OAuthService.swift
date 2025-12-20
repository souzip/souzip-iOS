import Domain

public protocol OAuthService {
    func login() async throws -> String
}

public enum OAuthPlatform: String, Hashable {
    case kakao
    case google
    case apple

    // SDK용
    public var sdkName: String {
        switch self {
        case .kakao: "Kakao"
        case .google: "Google"
        case .apple: "Apple"
        }
    }

    // API 경로
    public var apiPath: String {
        rawValue
    }
}
