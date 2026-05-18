public struct WishlistMutationResult: Equatable {
    public let souvenirId: Int
    public let isWishlisted: Bool

    public init(souvenirId: Int, isWishlisted: Bool) {
        self.souvenirId = souvenirId
        self.isWishlisted = isWishlisted
    }
}
