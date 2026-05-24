import XCTest
@testable import Domain

final class MockWishlistRepository: WishlistRepository {
    var addToWishlistResult: WishlistMutationResult = DomainTestFixtures.wishlistMutation
    var removeFromWishlistResult: WishlistMutationResult = .init(
        souvenirId: 10,
        isWishlisted: false
    )

    private(set) var addToWishlistCallCount = 0
    private(set) var lastAddSouvenirId: Int?
    private(set) var removeFromWishlistCallCount = 0
    private(set) var lastRemoveSouvenirId: Int?

    func addToWishlist(souvenirId: Int) async throws -> WishlistMutationResult {
        addToWishlistCallCount += 1
        lastAddSouvenirId = souvenirId
        return addToWishlistResult
    }

    func removeFromWishlist(souvenirId: Int) async throws -> WishlistMutationResult {
        removeFromWishlistCallCount += 1
        lastRemoveSouvenirId = souvenirId
        return removeFromWishlistResult
    }
}
