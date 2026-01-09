public struct SouvenirDetail {
    public let id: Int
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
    public let isOwned: Bool
    public let owner: SouvenirOwner
    public let files: [SouvenirFile]

    public init(
        id: Int,
        name: String,
        localPrice: Int?,
        currencySymbol: String?,
        krwPrice: Int?,
        description: String,
        address: String,
        locationDetail: String?,
        coordinate: Coordinate,
        category: SouvenirCategory,
        purpose: SouvenirPurpose,
        countryCode: String,
        isOwned: Bool,
        owner: SouvenirOwner,
        files: [SouvenirFile]
    ) {
        self.id = id
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
        self.isOwned = isOwned
        self.owner = owner
        self.files = files
    }

    public var thumbnailUrl: String? {
        files.first?.url
    }

    public var imageUrls: [String] {
        files.map(\.url)
    }
}
