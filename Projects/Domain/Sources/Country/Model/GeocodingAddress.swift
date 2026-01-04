public struct GeocodingAddress {
    public let formattedAddress: String
    public let city: String
    public let countryCode: String

    public init(
        formattedAddress: String,
        city: String,
        countryCode: String
    ) {
        self.formattedAddress = formattedAddress
        self.city = city
        self.countryCode = countryCode
    }
}
