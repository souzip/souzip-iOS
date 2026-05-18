import Foundation
import Networking

public enum WishlistEndpoint {
    case addToWishlist(souvenirId: Int)
    case removeFromWishlist(souvenirId: Int)
}

extension WishlistEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case let .addToWishlist(id), let .removeFromWishlist(id):
            "/api/wishlists/\(id)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .addToWishlist:
            .post
        case .removeFromWishlist:
            .delete
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .addToWishlist:
            ["Content-Type": "application/x-www-form-urlencoded"]
        case .removeFromWishlist:
            ["Content-Type": "application/json"]
        }
    }
}
