public struct DiscoveryCountryStat: Equatable {
    public let countryCode: String
    public let countryNameKr: String
    public let souvenirCount: Int

    public init(countryCode: String, countryNameKr: String, souvenirCount: Int) {
        self.countryCode = countryCode
        self.countryNameKr = countryNameKr
        self.souvenirCount = souvenirCount
    }
}
