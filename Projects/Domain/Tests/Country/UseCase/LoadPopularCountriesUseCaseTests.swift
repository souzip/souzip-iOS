import XCTest
@testable import Domain

final class LoadPopularCountriesUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockCountryRepository, DefaultLoadPopularCountriesUseCase) {
        let mockRepository = MockCountryRepository()
        let sut = DefaultLoadPopularCountriesUseCase(countryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeCountryDetail(code: String) -> CountryDetail {
        CountryDetail(
            nameEnglish: code,
            nameKorean: code,
            code: code,
            region: CountryRegion(englishName: "Asia", koreanName: "아시아"),
            capital: "Capital",
            flagImageURL: "https://example.com/\(code).png",
            coordinate: Coordinate(latitude: 0, longitude: 0),
            currency: CurrencyInfo(code: "USD", symbol: "$")
        )
    }

    func test_인기국가존재_목록반환() throws {
        let (mockRepository, sut) = makeSUT()
        let expected = [
            makeCountryDetail(code: "KR"),
            makeCountryDetail(code: "JP"),
        ]
        mockRepository.stubPopularCountries = expected

        let result = try sut.execute()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].code, "KR")
        XCTAssertEqual(result[1].code, "JP")
        XCTAssertEqual(mockRepository.loadPopularCountriesCallCount, 1)
    }

    func test_인기국가없음_빈목록반환() throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubPopularCountries = []

        let result = try sut.execute()

        XCTAssertTrue(result.isEmpty)
        XCTAssertEqual(mockRepository.loadPopularCountriesCallCount, 1)
    }

    func test_인기국가조회실패_에러전파() {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadPopularCountriesError = CountryError.networkError

        XCTAssertThrowsError(try sut.execute()) { error in
            XCTAssertEqual(error as? CountryError, .networkError)
        }

        XCTAssertEqual(mockRepository.loadPopularCountriesCallCount, 1)
    }
}
