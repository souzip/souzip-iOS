import Domain
import Foundation

final class DefaultCountryRepository: CountryRepository {
    func fetchCountries() async throws -> [Country] {
        let dto: CountryResponseDTO =
            try JSONLoader.load(filename: "country", as: CountryResponseDTO.self)

        let all = dto.data.countries.map { $0.toDomain() }

        // TOP30만 남기고, 요청 순서 유지
        return all
            .filter { PopularDestinationsKR.orderIndex[$0.code] != nil }
            .sorted {
                PopularDestinationsKR.orderIndex[$0.code, default: .max]
                    < PopularDestinationsKR.orderIndex[$1.code, default: .max]
            }
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
