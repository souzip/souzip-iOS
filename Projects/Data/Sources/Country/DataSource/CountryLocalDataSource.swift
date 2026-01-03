import Domain
import Foundation

public protocol CountryLocalDataSource {
    func fetchCountries() throws -> [CountryDetail]
    func fetchCountry(countryCode: String) throws -> CountryDetail
}

public final class DefaultCountryLocalDataSource: CountryLocalDataSource {
    public init() {}

    public func fetchCountries() throws -> [CountryDetail] {
        let dto: CountryResponseDTO =
            try JSONLoader.load(filename: "country", as: CountryResponseDTO.self)

        let all = dto.data.countries.map { $0.toDomain() }

        return all
            .filter { PopularDestinationsKR.orderIndex[$0.code] != nil }
            .sorted {
                PopularDestinationsKR.orderIndex[$0.code, default: .max]
                    < PopularDestinationsKR.orderIndex[$1.code, default: .max]
            }
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

enum JSONLoader {
    static func load<T: Decodable>(
        filename: String,
        as type: T.Type
    ) throws -> T {
        guard let url = Bundle.module.url(
            forResource: filename,
            withExtension: "json"
        ) else {
            throw NSError(domain: "JSONNotFound", code: 0)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

private enum PopularDestinationsKR {
    static let top30Codes: [String] = [
        "JP", "VN", "CN", "TH", "PH", "TW", "HK", "SG", "MY", "ID",
        "US", "AU", "CA", "DE", "FR", "GB", "ES", "IT", "TR", "RU",
        "NL", "BE", "CH", "GR", "AT", "CZ", "HU", "PL", "MX", "BR",
    ]

    static let orderIndex: [String: Int] = Dictionary(uniqueKeysWithValues: top30Codes.enumerated().map { ($0.element, $0.offset) })
}
