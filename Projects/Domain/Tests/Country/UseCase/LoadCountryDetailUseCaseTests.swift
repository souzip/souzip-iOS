import XCTest
@testable import Domain

final class LoadCountryDetailUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockCountryRepository, DefaultLoadCountryDetailUseCase) {
        let mockRepository = MockCountryRepository()
        let sut = DefaultLoadCountryDetailUseCase(countryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeCountryDetail(code: String = "KR") -> CountryDetail {
        CountryDetail(
            nameEnglish: "South Korea",
            nameKorean: "대한민국",
            code: code,
            region: CountryRegion(englishName: "Asia", koreanName: "아시아"),
            capital: "Seoul",
            flagImageURL: "https://example.com/kr.png",
            coordinate: Coordinate(latitude: 37.5665, longitude: 126.9780),
            currency: CurrencyInfo(code: "KRW", symbol: "₩")
        )
    }

    private func assertCountryDetail(
        _ actual: CountryDetail,
        equals expected: CountryDetail,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(actual.nameEnglish, expected.nameEnglish, file: file, line: line)
        XCTAssertEqual(actual.nameKorean, expected.nameKorean, file: file, line: line)
        XCTAssertEqual(actual.code, expected.code, file: file, line: line)
        XCTAssertEqual(actual.region.englishName, expected.region.englishName, file: file, line: line)
        XCTAssertEqual(actual.region.koreanName, expected.region.koreanName, file: file, line: line)
        XCTAssertEqual(actual.capital, expected.capital, file: file, line: line)
        XCTAssertEqual(actual.flagImageURL, expected.flagImageURL, file: file, line: line)
        XCTAssertEqual(actual.coordinate.latitude, expected.coordinate.latitude, file: file, line: line)
        XCTAssertEqual(actual.coordinate.longitude, expected.coordinate.longitude, file: file, line: line)
        XCTAssertEqual(actual.currency.code, expected.currency.code, file: file, line: line)
        XCTAssertEqual(actual.currency.symbol, expected.currency.symbol, file: file, line: line)
    }

    func test_국가코드정상_국가상세반환() throws {
        let (mockRepository, sut) = makeSUT()
        let expected = makeCountryDetail()
        mockRepository.stubCountryDetail = expected

        let result = try sut.execute(countryCode: "KR")

        assertCountryDetail(result, equals: expected)
        XCTAssertEqual(mockRepository.loadCountryCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoadCountryCode, "KR")
    }

    func test_국가조회실패_에러전파() {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadCountryError = CountryError.notFound

        XCTAssertThrowsError(try sut.execute(countryCode: "XX")) { error in
            XCTAssertEqual(error as? CountryError, .notFound)
        }

        XCTAssertEqual(mockRepository.loadCountryCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoadCountryCode, "XX")
    }

    func test_다른국가코드_저장소전달() throws {
        let (mockRepository, sut) = makeSUT()
        let expected = makeCountryDetail(code: "JP")
        mockRepository.stubCountryDetail = expected

        let result = try sut.execute(countryCode: "JP")

        assertCountryDetail(result, equals: expected)
        XCTAssertEqual(mockRepository.lastLoadCountryCode, "JP")
    }
}
