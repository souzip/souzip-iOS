import Foundation
import Networking

public enum UserEndpoint {
    case getUserProfile
    case getUserSouvenirs(page: Int, size: Int)
}

extension UserEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .getUserProfile:
            "/api/users/me"
        case .getUserSouvenirs:
            "/api/users/me/souvenirs"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getUserProfile, .getUserSouvenirs:
            .get
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var queryParameters: [String: String]? {
        switch self {
        case .getUserProfile:
            nil
        case let .getUserSouvenirs(page, size):
            [
                "page": "\(page)",
                "size": "\(size)",
            ]
        }
    }

    public var body: Data? {
        nil
    }
}
