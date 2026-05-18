import Foundation

public protocol AddToWishlistUseCase {
    func execute(souvenirId: Int) async throws -> WishlistMutationResult
}

public final class DefaultAddToWishlistUseCase: AddToWishlistUseCase {
    private let wishlistRepo: WishlistRepository

    public init(wishlistRepo: WishlistRepository) {
        self.wishlistRepo = wishlistRepo
    }

    public func execute(souvenirId: Int) async throws -> WishlistMutationResult {
        try await wishlistRepo.addToWishlist(souvenirId: souvenirId)
    }
}
