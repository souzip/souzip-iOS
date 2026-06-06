import XCTest
@testable import Domain

final class LoadTopSouvenirsByCategoryUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockDiscoveryRepository, DefaultLoadTopSouvenirsByCategoryUseCase) {
        let mockRepository = MockDiscoveryRepository()
        let sut = DefaultLoadTopSouvenirsByCategoryUseCase(discoveryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeCatalogSouvenir() -> CatalogSouvenir {
        CatalogSouvenir(
            id: 4,
            name: "카테고리인기기념품",
            category: .fashion,
            countryCode: "FR",
            thumbnailUrl: "https://example.com/fashion-thumb.jpg"
        )
    }

    func test_정상호출_카테고리별목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expected = [makeCatalogSouvenir()]
        mockRepository.stubTopSouvenirsByCategory = expected

        let result = try await sut.execute(category: .fashion)

        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockRepository.loadTopSouvenirsByCategoryCallCount, 1)
        XCTAssertEqual(mockRepository.lastCategory, .fashion)
    }

    func test_조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadTopSouvenirsByCategoryError = MockDiscoveryError.failed

        do {
            _ = try await sut.execute(category: .art)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockDiscoveryError, .failed)
        }

        XCTAssertEqual(mockRepository.loadTopSouvenirsByCategoryCallCount, 1)
        XCTAssertEqual(mockRepository.lastCategory, .art)
    }
}
