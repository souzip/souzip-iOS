import Foundation
import Networking

public enum DiscoveryEndpoint {
    // Public
    case top10CountrySouvenirs
    case top10ByCategory(categoryName: String)

    // Authed
    case aiPreferenceCategory
    case aiPreferenceUpload
}

extension DiscoveryEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .top10CountrySouvenirs:
            "/api/countries/souvenirs"

        case let .top10ByCategory(categoryName):
            "/api/discovery/general/category/\(categoryName)"

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
