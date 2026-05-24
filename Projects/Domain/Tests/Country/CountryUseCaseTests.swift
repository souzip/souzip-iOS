import XCTest
@testable import Domain

final class CountryUseCaseTests: XCTestCase {
    func test_국가코드조회_리포지토리위임() throws {
        let mock = MockCountryRepository()
        let sut = DefaultLoadCountryDetailUseCase(countryRepo: mock)

        let result = try sut.execute(countryCode: "JP")

        XCTAssertEqual(result.code, DomainTestFixtures.countryDetail.code)
        XCTAssertEqual(mock.loadCountryCallCount, 1)
        XCTAssertEqual(mock.lastCountryCode, "JP")
    }

    func test_주소조회_좌표전달() async throws {
        let mock = MockCountryRepository()
        let sut = DefaultLoadLocationAddressUseCase(countryRepo: mock)

        let result = try await sut.execute(latitude: 35.0, longitude: 129.0)

        XCTAssertEqual(result.countryCode, DomainTestFixtures.locationAddress.countryCode)
        XCTAssertEqual(mock.loadAddressCallCount, 1)
        XCTAssertEqual(mock.lastLatitude, 35.0)
        XCTAssertEqual(mock.lastLongitude, 129.0)
    }

    func test_인기국가목록_리포지토리위임() throws {
        let mock = MockCountryRepository()
        let sut = DefaultLoadPopularCountriesUseCase(countryRepo: mock)

        let result = try sut.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.loadPopularCountriesCallCount, 1)
    }

    func test_위치검색_키워드전달() async throws {
        let mock = MockCountryRepository()
        let sut = DefaultSearchLocationsUseCase(countryRepo: mock)

        let result = try await sut.execute(keyword: "서울")

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.searchLocationsCallCount, 1)
        XCTAssertEqual(mock.lastSearchKeyword, "서울")
    }
}
