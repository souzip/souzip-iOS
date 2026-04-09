import Foundation
import Networking

public enum CountryEndpoint {
    case locationAddress(latitude: Double, longitude: Double)
    case searchLocations(keyword: String)
}

extension CountryEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .locationAddress:
            "/api/location/address"
        case .searchLocations:
            "/api/location/search"
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
        case let .locationAddress(latitude, longitude):
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
