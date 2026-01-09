import Domain
import Foundation
import Networking

final class DefaultCountryRepository: CountryRepository {
    private let countryRemote: CountryRemoteDataSource
    private let countryLocal: CountryLocalDataSource

    public init(
        countryRemote: CountryRemoteDataSource,
        countryLocal: CountryLocalDataSource
    ) {
        self.countryRemote = countryRemote
        self.countryLocal = countryLocal
    }

    func fetchCountries() throws -> [CountryDetail] {
        try countryLocal.fetchCountries()
    }

    func fetchCountry(countryCode: String) throws -> CountryDetail {
        try countryLocal.fetchCountry(countryCode: countryCode)
    }

    // MARK: - Address

    func getAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> GeocodingAddress {
        do {
            let dto = try await countryRemote.getAddress(
                latitude: latitude,
                longitude: longitude
            )
            return CountryDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Search

    func searchLocations(
        keyword: String
    ) async throws -> [SearchedLocation] {
        do {
            let dto = try await countryRemote.searchLocations(keyword: keyword)
            return CountryDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }
}

// MARK: - Error Mapper

private extension DefaultCountryRepository {
    func mapToDomainError(_ error: Error) -> CountryError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                return .unauthorized
            case .serverError:
                return .serverError
            case .noData:
                return .notFound
            case .invalidURL, .unknown, .encodingError, .decodingError:
                return .networkError
            }
        }

        return .unknown
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
