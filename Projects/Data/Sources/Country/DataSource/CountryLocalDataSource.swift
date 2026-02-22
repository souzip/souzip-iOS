import Foundation

public protocol CountryLocalDataSource {
    func fetchCountries() -> [CountryDTO]
    func fetchCountry(countryCode: String) -> CountryDTO?
}

public final class DefaultCountryLocalDataSource: CountryLocalDataSource {
    private let cachedCountries: [String: CountryDTO]

    public init() {
        do {
            let response: CountryResponseDTO = try JSONLoader.load(filename: "country")
            cachedCountries = Dictionary(
                response.data.countries.map { ($0.code.uppercased(), $0) },
                uniquingKeysWith: { first, _ in first }
            )
        } catch {
            fatalError("Failed to load country.json from bundle: \(error)")
        }
    }

    public func fetchCountries() -> [CountryDTO] {
        Array(cachedCountries.values)
    }

    public func fetchCountry(countryCode: String) -> CountryDTO? {
        cachedCountries[countryCode.uppercased()]
    }
}
