/// `GET /api/users/me/wishlists` 응답 `content` 한 행.
public struct WishlistedSouvenirRow: Equatable {
    public let souvenirId: Int
    public let name: String
    public let countryCode: String
    public let thumbnailUrl: String
    public let wishedAt: String
    public let isWishlisted: Bool

    public init(
        souvenirId: Int,
        name: String,
        countryCode: String,
        thumbnailUrl: String,
        wishedAt: String,
        isWishlisted: Bool
    ) {
        self.souvenirId = souvenirId
        self.name = name
        self.countryCode = countryCode
        self.thumbnailUrl = thumbnailUrl
        self.wishedAt = wishedAt
        self.isWishlisted = isWishlisted
    }
}
