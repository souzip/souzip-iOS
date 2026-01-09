public struct SouvenirThumbnail {
    public let id: Int
    public let thumbnailUrl: String
    public let country: String
    public let createdAt: String
    public let updatedAt: String

    public init(
        id: Int,
        thumbnailUrl: String,
        country: String,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.thumbnailUrl = thumbnailUrl
        self.country = country
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
