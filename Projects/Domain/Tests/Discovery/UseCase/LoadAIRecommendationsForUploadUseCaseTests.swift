import XCTest
@testable import Domain

final class LoadAIRecommendationsForUploadUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockDiscoveryRepository, DefaultLoadAIRecommendationsForUploadUseCase) {
        let mockRepository = MockDiscoveryRepository()
        let sut = DefaultLoadAIRecommendationsForUploadUseCase(discoveryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeCatalogSouvenir() -> CatalogSouvenir {
        CatalogSouvenir(
            id: 2,
            name: "업로드추천기념품",
            category: .culture,
            countryCode: "KR",
            thumbnailUrl: "https://example.com/upload-thumb.jpg"
        )
    }

    func test_정상호출_추천목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expected = [makeCatalogSouvenir()]
        mockRepository.stubAIRecommendationsForUpload = expected

        let result = try await sut.execute()

        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockRepository.aiRecUploadCallCount, 1)
    }

    func test_조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadAIRecommendationsForUploadError = MockDiscoveryError.failed

        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockDiscoveryError, .failed)
        }

        XCTAssertEqual(mockRepository.aiRecUploadCallCount, 1)
    }
}
