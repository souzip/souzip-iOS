import Foundation

public protocol RemoveFromWishlistUseCase {
    func execute(souvenirId: Int) async throws -> WishlistMutationResult
}

public final class DefaultRemoveFromWishlistUseCase: RemoveFromWishlistUseCase {
    private let wishlistRepo: WishlistRepository

    public init(wishlistRepo: WishlistRepository) {
        self.wishlistRepo = wishlistRepo
    }

    public func execute(souvenirId: Int) async throws -> WishlistMutationResult {
        try await wishlistRepo.removeFromWishlist(souvenirId: souvenirId)
    }
}
