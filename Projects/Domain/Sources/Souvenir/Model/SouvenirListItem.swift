public struct SouvenirListItem: Hashable {
    public let id: Int
    public let name: String
    public let category: SouvenirCategory
    public let purpose: SouvenirPurpose
    public let localPrice: Int?
    public let krwPrice: Int?
    public let currencySymbol: String?
    public let thumbnail: String
    public let coordinate: Coordinate
    public let address: String

    public init(
        id: Int,
        name: String,
        category: SouvenirCategory,
        purpose: SouvenirPurpose,
        localPrice: Int?,
        krwPrice: Int?,
        currencySymbol: String?,
        thumbnail: String,
        coordinate: Coordinate,
        address: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.purpose = purpose
        self.localPrice = localPrice
        self.krwPrice = krwPrice
        self.currencySymbol = currencySymbol
        self.thumbnail = thumbnail
        self.coordinate = coordinate
        self.address = address
    }

    public static func == (lhs: SouvenirListItem, rhs: SouvenirListItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
