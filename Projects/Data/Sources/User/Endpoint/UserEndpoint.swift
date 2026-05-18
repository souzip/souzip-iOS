import Foundation
import Networking

public enum UserEndpoint {
    case getUserProfile
    case getUserSouvenirs(page: Int, size: Int)
    case getUserWishlists(page: Int, size: Int)
}

extension UserEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .getUserProfile:
            "/api/users/me"
        case .getUserSouvenirs:
            "/api/users/me/souvenirs"
        case .getUserWishlists:
            "/api/users/me/wishlists"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getUserProfile, .getUserSouvenirs, .getUserWishlists:
            .get
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var parameters: [String: Any]? {
        switch self {
        case .getUserProfile:
            nil

        case let .getUserSouvenirs(page, size):
            [
                "page": page,
                "size": size,
            ]

        case let .getUserWishlists(page, size):
            [
                "page": page,
                "size": size,
            ]
        }
    }

    public var body: Data? {
        nil
    }
}
