import XCTest
@testable import Domain

final class AddToWishlistUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockWishlistRepository, DefaultAddToWishlistUseCase) {
        let mockRepository = MockWishlistRepository()
        let sut = DefaultAddToWishlistUseCase(wishlistRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_위시리스트추가성공_결과반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expectedResult = WishlistMutationResult(souvenirId: 42, isWishlisted: true)
        mockRepository.stubAddToWishlistResult = expectedResult

        let result = try await sut.execute(souvenirId: 42)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(mockRepository.addToWishlistCallCount, 1)
        XCTAssertEqual(mockRepository.lastAddToWishlistSouvenirId, 42)
    }

    func test_기념품ID전달_리포지토리호출() async throws {
        let (mockRepository, sut) = makeSUT()

        _ = try await sut.execute(souvenirId: 15)

        XCTAssertEqual(mockRepository.lastAddToWishlistSouvenirId, 15)
        XCTAssertEqual(mockRepository.addToWishlistCallCount, 1)
    }

    func test_위시리스트추가실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.addToWishlistError = MockWishlistError.failed

        do {
            _ = try await sut.execute(souvenirId: 42)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockWishlistError, .failed)
        }

        XCTAssertEqual(mockRepository.addToWishlistCallCount, 1)
        XCTAssertEqual(mockRepository.lastAddToWishlistSouvenirId, 42)
    }
}
