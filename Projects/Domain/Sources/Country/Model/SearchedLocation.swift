public struct SearchedLocation {
    public let id: Int
    public let type: LocationType
    public let name: String
    public let nameEn: String
    public let nameKr: String

    public let countryName: String?
    public let countryNameEn: String?
    public let countryNameKr: String?

    public let score: Double
    public let highlight: [String: [String]]

    public let coordinate: Coordinate

    public init(
        id: Int,
        type: LocationType,
        name: String,
        nameEn: String,
        nameKr: String,
        countryName: String?,
        countryNameEn: String?,
        countryNameKr: String?,
        score: Double,
        highlight: [String: [String]],
        coordinate: Coordinate
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.nameEn = nameEn
        self.nameKr = nameKr
        self.countryName = countryName
        self.countryNameEn = countryNameEn
        self.countryNameKr = countryNameKr
        self.score = score
        self.highlight = highlight
        self.coordinate = coordinate
    }
}

public enum LocationType: String {
    case country
    case city
}
