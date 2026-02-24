public struct SouvenirInput {
    public let name: String
    public let price: Int?
    public let currencyCode: String?
    public let description: String
    public let address: String
    public let locationDetail: String?
    public let coordinate: Coordinate
    public let category: SouvenirCategory
    public let purpose: SouvenirPurpose
    public let countryCode: String

    public init(
        name: String,
        price: Int? = nil,
        currencyCode: String? = nil,
        krwPrice: Int? = nil,
        description: String,
        address: String,
        locationDetail: String? = nil,
        coordinate: Coordinate,
        category: SouvenirCategory,
        purpose: SouvenirPurpose,
        countryCode: String
    ) {
        self.name = name
        self.price = price
        self.currencyCode = currencyCode
        self.description = description
        self.address = address
        self.locationDetail = locationDetail
        self.coordinate = coordinate
        self.category = category
        self.purpose = purpose
        self.countryCode = countryCode
    }
}
