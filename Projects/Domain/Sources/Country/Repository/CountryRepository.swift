public protocol CountryRepository {
    func fetchTop30Countries() throws -> [CountryDetail]
    func fetchCountry(countryCode: String) throws -> CountryDetail

    func getAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> GeocodingAddress

    func searchLocations(
        keyword: String
    ) async throws -> [SearchedLocation]
}
