public struct SearchLocationsResponse: Decodable {
    public let content: [SearchedLocationResponse]
    public let pagination: SearchPaginationResponse
}

public struct SearchedLocationResponse: Decodable {
    public let id: Int
    public let type: String
    public let name: String
    public let nameEn: String
    public let nameKr: String

    public let countryName: String?
    public let countryNameEn: String?
    public let countryNameKr: String?

    public let score: Double
    public let highlight: HighlightResponse

    public let latitude: Double
    public let longitude: Double
}

public struct HighlightResponse: Decodable {
    public let raw: [String: [String]]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        raw = (try? container.decode([String: [String]].self)) ?? [:]
    }
}

public struct SearchPaginationResponse: Decodable {
    public let currentPage: Int
    public let totalPages: Int
    public let totalItems: Int
    public let pageSize: Int
    public let first: Bool
    public let last: Bool
    public let hasNext: Bool
    public let hasPrevious: Bool
}
