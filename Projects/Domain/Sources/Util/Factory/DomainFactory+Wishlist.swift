public extension DefaultDomainFactory {
    func makeWishlistRepository() -> WishlistRepository {
        factory.makeWishlistRepository()
    }

    func makeAddToWishlistUseCase() -> AddToWishlistUseCase {
        DefaultAddToWishlistUseCase(wishlistRepo: makeWishlistRepository())
    }

    func makeRemoveFromWishlistUseCase() -> RemoveFromWishlistUseCase {
        DefaultRemoveFromWishlistUseCase(wishlistRepo: makeWishlistRepository())
    }
}
