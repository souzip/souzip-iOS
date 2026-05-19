import Domain

actor WishlistToggleExecutor {
    private let addToWishlist: AddToWishlistUseCase
    private let removeFromWishlist: RemoveFromWishlistUseCase
    private var inFlightSouvenirIDs = Set<Int>()

    init(
        addToWishlist: AddToWishlistUseCase,
        removeFromWishlist: RemoveFromWishlistUseCase
    ) {
        self.addToWishlist = addToWishlist
        self.removeFromWishlist = removeFromWishlist
    }

    func toggle(souvenirId: Int, currentlyWishlisted: Bool?) async {
        guard inFlightSouvenirIDs.contains(souvenirId) == false else { return }
        inFlightSouvenirIDs.insert(souvenirId)
        defer { inFlightSouvenirIDs.remove(souvenirId) }

        let shouldWishlist = currentlyWishlisted != true
        if shouldWishlist {
            _ = try? await addToWishlist.execute(souvenirId: souvenirId)
        } else {
            _ = try? await removeFromWishlist.execute(souvenirId: souvenirId)
        }
    }
}
