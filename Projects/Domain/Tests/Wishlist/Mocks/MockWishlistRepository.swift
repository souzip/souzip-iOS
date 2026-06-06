import Foundation
@testable import Domain

final class MockWishlistRepository: WishlistRepository {
    var stubAddToWishlistResult = WishlistMutationResult(souvenirId: 1, isWishlisted: true)
    var stubRemoveFromWishlistResult = WishlistMutationResult(souvenirId: 1, isWishlisted: false)

    var addToWishlistError: Error?
    var removeFromWishlistError: Error?

    private(set) var addToWishlistCallCount = 0
    private(set) var removeFromWishlistCallCount = 0
    private(set) var lastAddToWishlistSouvenirId: Int?
    private(set) var lastRemoveFromWishlistSouvenirId: Int?

    func addToWishlist(souvenirId: Int) async throws -> WishlistMutationResult {
        addToWishlistCallCount += 1
        lastAddToWishlistSouvenirId = souvenirId

        if let addToWishlistError {
            throw addToWishlistError
        }

        return stubAddToWishlistResult
    }

    func removeFromWishlist(souvenirId: Int) async throws -> WishlistMutationResult {
        removeFromWishlistCallCount += 1
        lastRemoveFromWishlistSouvenirId = souvenirId

        if let removeFromWishlistError {
            throw removeFromWishlistError
        }

        return stubRemoveFromWishlistResult
    }
}

enum MockWishlistError: Error {
    case failed
}
