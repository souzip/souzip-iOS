import XCTest
@testable import Domain

final class RemoveFromWishlistUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockWishlistRepository, DefaultRemoveFromWishlistUseCase) {
        let mockRepository = MockWishlistRepository()
        let sut = DefaultRemoveFromWishlistUseCase(wishlistRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_위시리스트제거성공_결과반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expectedResult = WishlistMutationResult(souvenirId: 42, isWishlisted: false)
        mockRepository.stubRemoveFromWishlistResult = expectedResult

        let result = try await sut.execute(souvenirId: 42)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(mockRepository.removeFromWishlistCallCount, 1)
        XCTAssertEqual(mockRepository.lastRemoveFromWishlistSouvenirId, 42)
    }

    func test_기념품ID전달_리포지토리호출() async throws {
        let (mockRepository, sut) = makeSUT()

        _ = try await sut.execute(souvenirId: 8)

        XCTAssertEqual(mockRepository.lastRemoveFromWishlistSouvenirId, 8)
        XCTAssertEqual(mockRepository.removeFromWishlistCallCount, 1)
    }

    func test_위시리스트제거실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.removeFromWishlistError = MockWishlistError.failed

        do {
            _ = try await sut.execute(souvenirId: 42)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockWishlistError, .failed)
        }

        XCTAssertEqual(mockRepository.removeFromWishlistCallCount, 1)
        XCTAssertEqual(mockRepository.lastRemoveFromWishlistSouvenirId, 42)
    }
}
