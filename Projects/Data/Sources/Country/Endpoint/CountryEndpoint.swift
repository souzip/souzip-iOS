import Foundation
import Networking

public enum CountryEndpoint {
    case geocodingAddress(latitude: Double, longitude: Double)
    case searchLocations(keyword: String)
}

extension CountryEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .geocodingAddress:
            "/api/geocoding/address"
        case .searchLocations:
            "/api/search/locations"
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var parameters: [String: Any]? {
        switch self {
        case let .geocodingAddress(latitude, longitude):
            [
                "latitude": latitude,
                "longitude": longitude,
            ]

        case let .searchLocations(keyword):
            [
                "keyword": keyword,
            ]
        }
    }
}
