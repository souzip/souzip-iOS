public protocol CountryRepository {
    func loadPopularCountries() throws -> [CountryDetail]
    func loadCountry(countryCode: String) throws -> CountryDetail

    func loadAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> LocationAddress

    func searchLocations(
        keyword: String
    ) async throws -> [LocationSearchHit]
}
