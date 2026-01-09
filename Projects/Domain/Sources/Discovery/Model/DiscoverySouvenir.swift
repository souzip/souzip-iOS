public struct DiscoverySouvenir: Equatable {
    public let id: Int
    public let name: String
    public let category: String
    public let countryCode: String
    public let thumbnailUrl: String

    public init(
        id: Int,
        name: String,
        category: String,
        countryCode: String,
        thumbnailUrl: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.countryCode = countryCode
        self.thumbnailUrl = thumbnailUrl
    }
}
