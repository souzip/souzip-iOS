public struct DiscoverySouvenirResponse: Decodable {
    public let id: Int
    public let name: String
    public let category: String
    public let countryCode: String
    public let thumbnailUrl: String
}

public struct DiscoveryCountryStatResponse: Decodable {
    public let countryCode: String
    public let countryNameKr: String
    public let souvenirCount: Int
}

public struct AIRecommendationResponse: Decodable {
    public let souvenirs: [DiscoverySouvenirResponse]
}
