public protocol DomainWishlistFactory: AnyObject {
    func makeWishlistRepository() -> WishlistRepository
    func makeAddToWishlistUseCase() -> AddToWishlistUseCase
    func makeRemoveFromWishlistUseCase() -> RemoveFromWishlistUseCase
}
