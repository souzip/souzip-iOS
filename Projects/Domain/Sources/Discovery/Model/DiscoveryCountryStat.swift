public struct DiscoveryCountryStat: Equatable {
    public let countryCode: String
    public let countryNameKr: String
    public let souvenirCount: Int
    public let imageUrl: String

    public init(
        countryCode: String,
        countryNameKr: String,
        souvenirCount: Int,
        imageUrl: String
    ) {
        self.countryCode = countryCode
        self.countryNameKr = countryNameKr
        self.souvenirCount = souvenirCount
        self.imageUrl = imageUrl
    }
}
