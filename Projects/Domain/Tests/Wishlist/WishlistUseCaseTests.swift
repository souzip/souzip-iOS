import XCTest
@testable import Domain

final class WishlistUseCaseTests: XCTestCase {
    func test_위시리스트추가_식별자전달() async throws {
        let mock = MockWishlistRepository()
        let sut = DefaultAddToWishlistUseCase(wishlistRepo: mock)

        let result = try await sut.execute(souvenirId: 10)

        XCTAssertTrue(result.isWishlisted)
        XCTAssertEqual(mock.addToWishlistCallCount, 1)
        XCTAssertEqual(mock.lastAddSouvenirId, 10)
    }

    func test_위시리스트제거_식별자전달() async throws {
        let mock = MockWishlistRepository()
        let sut = DefaultRemoveFromWishlistUseCase(wishlistRepo: mock)

        let result = try await sut.execute(souvenirId: 10)

        XCTAssertFalse(result.isWishlisted)
        XCTAssertEqual(mock.removeFromWishlistCallCount, 1)
        XCTAssertEqual(mock.lastRemoveSouvenirId, 10)
    }
}
