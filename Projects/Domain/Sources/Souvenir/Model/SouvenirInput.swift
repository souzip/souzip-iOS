public struct SouvenirInput {
    public let name: String
    public let localPrice: Int?
    public let currencySymbol: String?
    public let krwPrice: Int?
    public let description: String
    public let address: String
    public let locationDetail: String?
    public let coordinate: Coordinate
    public let category: SouvenirCategory
    public let purpose: SouvenirPurpose
    public let countryCode: String

    public init(
        name: String,
        localPrice: Int? = nil,
        currencySymbol: String? = nil,
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
        self.localPrice = localPrice
        self.currencySymbol = currencySymbol
        self.krwPrice = krwPrice
        self.description = description
        self.address = address
        self.locationDetail = locationDetail
        self.coordinate = coordinate
        self.category = category
        self.purpose = purpose
        self.countryCode = countryCode
    }
}
