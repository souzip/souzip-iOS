public protocol CountryRepository {
    func fetchCountries() async throws -> [Country]
}
