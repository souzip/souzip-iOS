import XCTest
@testable import Domain

final class SearchLocationsUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockCountryRepository, DefaultSearchLocationsUseCase) {
        let mockRepository = MockCountryRepository()
        let sut = DefaultSearchLocationsUseCase(countryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeSearchResults() -> [LocationSearchHit] {
        [
            .city(
                CitySearchHit(
                    id: LocationSearchHitID(rawValue: "city-seoul"),
                    title: "서울",
                    countryLine: "대한민국",
                    coordinate: Coordinate(latitude: 37.5665, longitude: 126.9780)
                )
            ),
            .place(
                PlaceSearchHit(
                    id: LocationSearchHitID(rawValue: "place-gyeongbokgung"),
                    title: "경복궁",
                    placeKind: "관광지",
                    areaDescription: "서울 종로구",
                    coordinate: Coordinate(latitude: 37.5796, longitude: 126.9770)
                )
            ),
        ]
    }

    func test_키워드정상_검색결과반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expected = makeSearchResults()
        mockRepository.stubSearchResults = expected

        let result = try await sut.execute(keyword: "서울")

        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockRepository.searchLocationsCallCount, 1)
        XCTAssertEqual(mockRepository.lastSearchKeyword, "서울")
    }

    func test_검색결과없음_빈목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubSearchResults = []

        let result = try await sut.execute(keyword: "없는키워드")

        XCTAssertTrue(result.isEmpty)
        XCTAssertEqual(mockRepository.searchLocationsCallCount, 1)
        XCTAssertEqual(mockRepository.lastSearchKeyword, "없는키워드")
    }

    func test_위치검색실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.searchLocationsError = CountryError.unauthorized

        do {
            _ = try await sut.execute(keyword: "서울")
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? CountryError, .unauthorized)
        }

        XCTAssertEqual(mockRepository.searchLocationsCallCount, 1)
        XCTAssertEqual(mockRepository.lastSearchKeyword, "서울")
    }

    func test_다른키워드_저장소전달() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubSearchResults = makeSearchResults()

        _ = try await sut.execute(keyword: "도쿄")

        XCTAssertEqual(mockRepository.lastSearchKeyword, "도쿄")
    }
}
