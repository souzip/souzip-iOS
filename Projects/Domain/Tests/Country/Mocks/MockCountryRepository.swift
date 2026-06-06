import Foundation
@testable import Domain

final class MockCountryRepository: CountryRepository {
    var stubPopularCountries: [CountryDetail] = []
    var stubCountryDetail: CountryDetail?
    var stubLocationAddress: LocationAddress?
    var stubSearchResults: [LocationSearchHit] = []

    var loadPopularCountriesError: Error?
    var loadCountryError: Error?
    var loadAddressError: Error?
    var searchLocationsError: Error?

    private(set) var loadPopularCountriesCallCount = 0
    private(set) var loadCountryCallCount = 0
    private(set) var lastLoadCountryCode: String?
    private(set) var loadAddressCallCount = 0
    private(set) var lastLoadAddressLatitude: Double?
    private(set) var lastLoadAddressLongitude: Double?
    private(set) var searchLocationsCallCount = 0
    private(set) var lastSearchKeyword: String?

    func loadPopularCountries() throws -> [CountryDetail] {
        loadPopularCountriesCallCount += 1

        if let loadPopularCountriesError {
            throw loadPopularCountriesError
        }

        return stubPopularCountries
    }

    func loadCountry(countryCode: String) throws -> CountryDetail {
        loadCountryCallCount += 1
        lastLoadCountryCode = countryCode

        if let loadCountryError {
            throw loadCountryError
        }

        guard let stubCountryDetail else {
            throw MockCountryError.missingStub
        }

        return stubCountryDetail
    }

    func loadAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> LocationAddress {
        loadAddressCallCount += 1
        lastLoadAddressLatitude = latitude
        lastLoadAddressLongitude = longitude

        if let loadAddressError {
            throw loadAddressError
        }

        guard let stubLocationAddress else {
            throw MockCountryError.missingStub
        }

        return stubLocationAddress
    }

    func searchLocations(keyword: String) async throws -> [LocationSearchHit] {
        searchLocationsCallCount += 1
        lastSearchKeyword = keyword

        if let searchLocationsError {
            throw searchLocationsError
        }

        return stubSearchResults
    }
}

enum MockCountryError: Error {
    case failed
    case missingStub
}
