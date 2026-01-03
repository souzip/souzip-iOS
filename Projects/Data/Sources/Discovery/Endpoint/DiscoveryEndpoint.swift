import Foundation
import Networking

public enum DiscoveryEndpoint {
    // Public
    case top10ByCountry(countryCode: String)
    case top10ByCategory(categoryName: String)
    case top3CountryStats

    // AI (Authed)
    case aiPreferenceCategory
    case aiPreferenceUpload
}

extension DiscoveryEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case let .top10ByCountry(countryCode):
            "/api/discovery/general/country/\(countryCode)"

        case let .top10ByCategory(categoryName):
            "/api/discovery/general/category/\(categoryName)"

        case .top3CountryStats:
            "/api/discovery/general/stats"

        case .aiPreferenceCategory:
            "/api/discovery/ai/preference-category"

        case .aiPreferenceUpload:
            "/api/discovery/ai/preference-upload"
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var parameters: [String: Any]? {
        nil
    }
}
