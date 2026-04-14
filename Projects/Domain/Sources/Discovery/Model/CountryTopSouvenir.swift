public struct CountryTopSouvenir: Equatable {
    public let countryCode: String
    public let countryNameKr: String
    public let souvenirCount: Int
    public let souvenirs: [CatalogSouvenir]

    public init(
        countryCode: String,
        countryNameKr: String,
        souvenirCount: Int,
        souvenirs: [CatalogSouvenir]
    ) {
        self.countryCode = countryCode
        self.countryNameKr = countryNameKr
        self.souvenirCount = souvenirCount
        self.souvenirs = souvenirs
    }
}
