import Foundation
import Networking

public enum AuthEndpoint {
    case login(provider: String, accessToken: String)
    case refresh(refreshToken: String)
    case logout
    case withdraw
}

extension AuthEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case let .login(provider, _):
            "/api/v1/auth/\(provider)"
        case .refresh:
            "/api/v1/auth/refresh"
        case .logout:
            "/api/v1/auth/logout"
        case .withdraw:
            "/api/v1/auth/withdraw"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .login, .refresh, .logout:
            .post
        case .withdraw:
            .delete
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        switch self {
        case let .login(_, accessToken):
            let request = LoginRequest(accessToken: accessToken)
            return try? encoder.encode(request)

        case let .refresh(refreshToken):
            let request = RefreshRequest(refreshToken: refreshToken)
            return try? encoder.encode(request)

        case .logout, .withdraw:
            return nil
        }
    }
}
