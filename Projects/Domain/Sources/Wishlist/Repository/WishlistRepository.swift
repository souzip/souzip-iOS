public protocol WishlistRepository {
    func addToWishlist(souvenirId: Int) async throws -> WishlistMutationResult
    func removeFromWishlist(souvenirId: Int) async throws -> WishlistMutationResult
}
