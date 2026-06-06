import XCTest
@testable import Domain

final class LoadCountryTopSouvenirsUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockDiscoveryRepository, DefaultLoadCountryTopSouvenirsUseCase) {
        let mockRepository = MockDiscoveryRepository()
        let sut = DefaultLoadCountryTopSouvenirsUseCase(discoveryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeCountryTopSouvenir() -> CountryTopSouvenir {
        CountryTopSouvenir(
            countryCode: "JP",
            countryNameKr: "일본",
            souvenirCount: 1,
            souvenirs: [
                CatalogSouvenir(
                    id: 3,
                    name: "일본인기기념품",
                    category: .snack,
                    countryCode: "JP",
                    thumbnailUrl: "https://example.com/jp-thumb.jpg"
                ),
            ]
        )
    }

    func test_정상호출_국가별목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expected = [makeCountryTopSouvenir()]
        mockRepository.stubCountrySouvenirs = expected

        let result = try await sut.execute()

        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockRepository.loadCountrySouvenirsCallCount, 1)
    }

    func test_조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadCountrySouvenirsError = MockDiscoveryError.failed

        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockDiscoveryError, .failed)
        }

        XCTAssertEqual(mockRepository.loadCountrySouvenirsCallCount, 1)
    }
}
