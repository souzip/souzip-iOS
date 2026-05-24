import XCTest
@testable import Domain

final class MockCountryRepository: CountryRepository {
    var loadPopularCountriesResult: [CountryDetail] = [DomainTestFixtures.countryDetail]
    var loadCountryResult: CountryDetail = DomainTestFixtures.countryDetail
    var loadAddressResult: LocationAddress = DomainTestFixtures.locationAddress
    var searchLocationsResult: [LocationSearchHit] = [DomainTestFixtures.citySearchHit]

    private(set) var loadCountryCallCount = 0
    private(set) var lastCountryCode: String?
    private(set) var loadAddressCallCount = 0
    private(set) var lastLatitude: Double?
    private(set) var lastLongitude: Double?
    private(set) var searchLocationsCallCount = 0
    private(set) var lastSearchKeyword: String?
    private(set) var loadPopularCountriesCallCount = 0

    func loadPopularCountries() throws -> [CountryDetail] {
        loadPopularCountriesCallCount += 1
        return loadPopularCountriesResult
    }

    func loadCountry(countryCode: String) throws -> CountryDetail {
        loadCountryCallCount += 1
        lastCountryCode = countryCode
        return loadCountryResult
    }

    func loadAddress(latitude: Double, longitude: Double) async throws -> LocationAddress {
        loadAddressCallCount += 1
        lastLatitude = latitude
        lastLongitude = longitude
        return loadAddressResult
    }

    func searchLocations(keyword: String) async throws -> [LocationSearchHit] {
        searchLocationsCallCount += 1
        lastSearchKeyword = keyword
        return searchLocationsResult
    }
}
