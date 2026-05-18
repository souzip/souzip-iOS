public struct CollectedSouvenirSummary: Equatable {
    public let id: Int
    public let thumbnailUrl: String
    public let country: String
    public let createdAt: String
    public let updatedAt: String
    public let wishlistCount: Int
    public let isWishlisted: Bool

    public init(
        id: Int,
        thumbnailUrl: String,
        country: String,
        createdAt: String,
        updatedAt: String,
        wishlistCount: Int,
        isWishlisted: Bool
    ) {
        self.id = id
        self.thumbnailUrl = thumbnailUrl
        self.country = country
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.wishlistCount = wishlistCount
        self.isWishlisted = isWishlisted
    }
}
