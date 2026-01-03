public protocol CountryRepository {
    func fetchCountries() async throws -> [CountryDetail]
    func fetchCountry(countryCode: String) async throws -> CountryDetail

    func getAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> GeocodingAddress

    func searchLocations(
        keyword: String
    ) async throws -> [SearchedLocation]
}
