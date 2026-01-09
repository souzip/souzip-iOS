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
            "/api/auth/login/\(provider)"
        case .refresh:
            "/api/auth/refresh"
        case .logout:
            "/api/auth/logout"
        case .withdraw:
            "/api/users/me"
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
        switch self {
        case let .login(_, accessToken):
            let request = LoginRequest(accessToken: accessToken)
            return try? JSONEncoder().encode(request)

        case let .refresh(refreshToken):
            let request = RefreshRequest(refreshToken: refreshToken)
            return try? JSONEncoder().encode(request)

        case .logout, .withdraw:
            return nil
        }
    }
}
