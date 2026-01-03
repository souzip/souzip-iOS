public struct GeocodingAddressResponse: Decodable {
    public let formattedAddress: String
    public let city: String
    public let countryCode: String
}
