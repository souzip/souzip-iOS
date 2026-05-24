import XCTest
@testable import Domain

final class DiscoveryUseCaseTests: XCTestCase {
    func test_국가별인기기념품_리포지토리위임() async throws {
        let mock = MockDiscoveryRepository()
        let sut = DefaultLoadCountryTopSouvenirsUseCase(discoveryRepo: mock)

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.loadCountrySouvenirsCallCount, 1)
    }

    func test_카테고리별인기_카테고리전달() async throws {
        let mock = MockDiscoveryRepository()
        let sut = DefaultLoadTopSouvenirsByCategoryUseCase(discoveryRepo: mock)

        let result = try await sut.execute(category: .tech)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.loadTopSouvenirsByCategoryCallCount, 1)
        XCTAssertEqual(mock.lastCategory, .tech)
    }

    func test_카테고리AI추천_리포지토리위임() async throws {
        let mock = MockDiscoveryRepository()
        let sut = DefaultLoadAIRecommendationsForCategoryUseCase(discoveryRepo: mock)

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.loadAIRecommendationsForCategoryCallCount, 1)
    }

    func test_업로드AI추천_리포지토리위임() async throws {
        let mock = MockDiscoveryRepository()
        let sut = DefaultLoadAIRecommendationsForUploadUseCase(discoveryRepo: mock)

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.loadAIRecommendationsForUploadCallCount, 1)
    }
}
