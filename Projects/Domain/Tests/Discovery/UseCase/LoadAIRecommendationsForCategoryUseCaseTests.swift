import XCTest
@testable import Domain

final class LoadAIRecommendationsForCategoryUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockDiscoveryRepository, DefaultLoadAIRecommendationsForCategoryUseCase) {
        let mockRepository = MockDiscoveryRepository()
        let sut = DefaultLoadAIRecommendationsForCategoryUseCase(discoveryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeCatalogSouvenir() -> CatalogSouvenir {
        CatalogSouvenir(
            id: 1,
            name: "테스트기념품",
            category: .snack,
            countryCode: "JP",
            thumbnailUrl: "https://example.com/thumb.jpg"
        )
    }

    func test_정상호출_추천목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expected = [makeCatalogSouvenir()]
        mockRepository.stubAIRecommendationsForCategory = expected

        let result = try await sut.execute()

        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockRepository.loadAIRecommendationsForCategoryCallCount, 1)
    }

    func test_조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadAIRecommendationsForCategoryError = MockDiscoveryError.failed

        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockDiscoveryError, .failed)
        }

        XCTAssertEqual(mockRepository.loadAIRecommendationsForCategoryCallCount, 1)
    }
}
