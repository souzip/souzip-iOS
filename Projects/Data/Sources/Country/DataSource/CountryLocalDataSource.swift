import Domain

public protocol CountryLocalDataSource {
    func fetchCountries() throws -> [CountryDetail]
    func fetchCountry(countryCode: String) throws -> CountryDetail
}

import Domain
import Foundation

public final class DefaultCountryLocalDataSource: CountryLocalDataSource {

    public init() {}

    public func fetchCountries() throws -> [CountryDetail] {
        let dto: CountryResponseDTO =
            try JSONLoader.load(filename: "country", as: CountryResponseDTO.self)

        return dto.data.countries.map { $0.toDomain() }
    }

    public func fetchCountry(countryCode: String) throws -> CountryDetail {
        let countries = try fetchCountries()

        guard let country = countries.first(where: {
            $0.code.caseInsensitiveCompare(countryCode) == .orderedSame
        }) else {
            throw CountryError.notFound
        }

        return country
    }
}
