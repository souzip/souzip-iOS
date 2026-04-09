public struct LocationAddress {
    public let address: String
    public let city: String
    public let countryCode: String

    public init(
        address: String,
        city: String,
        countryCode: String
    ) {
        self.address = address
        self.city = city
        self.countryCode = countryCode
    }
}
