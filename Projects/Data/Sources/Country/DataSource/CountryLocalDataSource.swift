import Foundation

public protocol CountryLocalDataSource {
    func fetchCountries() throws -> [CountryDTO]
    func fetchCountry(countryCode: String) throws -> CountryDTO?
}

public final class DefaultCountryLocalDataSource: CountryLocalDataSource {
    private var cachedCountries: [String: CountryDTO]?

    public init() {}

    public func fetchCountries() throws -> [CountryDTO] {
        try Array(loadCache().values)
    }

    public func fetchCountry(countryCode: String) throws -> CountryDTO? {
        let cache = try loadCache()
        let key = countryCode.uppercased()
        return cache[key]
    }

    // MARK: - Private

    private func loadCache() throws -> [String: CountryDTO] {
        if let cached = cachedCountries { return cached }

        let response: CountryResponseDTO =
            try JSONLoader.load(filename: "country")

        let dict = Dictionary(
            response.data.countries.map { ($0.code.uppercased(), $0) },
            uniquingKeysWith: { first, _ in first }
        )
        cachedCountries = dict
        return dict
    }
}
