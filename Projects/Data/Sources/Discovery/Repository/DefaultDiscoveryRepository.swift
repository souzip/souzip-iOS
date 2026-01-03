import Domain
import Foundation
import Networking

public final class DefaultDiscoveryRepository: DiscoveryRepository {
    private let discoveryRemote: DiscoveryRemoteDataSource
    private let countryLocal: CountryLocalDataSource

    public init(
        discoveryRemote: DiscoveryRemoteDataSource,
        countryLocal: CountryLocalDataSource
    ) {
        self.discoveryRemote = discoveryRemote
        self.countryLocal = countryLocal
    }

    // MARK: - Public

    public func getTop10SouvenirsByCountry(countryCode: String) async throws -> [DiscoverySouvenir] {
        do {
            let dto = try await discoveryRemote.getTop10ByCountry(countryCode: countryCode)
            return mapSouvenirs(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func getTop10SouvenirsByCategory(categoryName: String) async throws -> [DiscoverySouvenir] {
        do {
            let dto = try await discoveryRemote.getTop10ByCategory(categoryName: categoryName)
            return mapSouvenirs(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func getTop3CountryStats() async throws -> [DiscoveryCountryStat] {
        do {
            let dto = try await discoveryRemote.getTop3CountryStats()

            return try dto.map { item in
                let country = try countryLocal.fetchCountry(countryCode: item.countryCode)

                return DiscoveryCountryStat(
                    countryCode: item.countryCode,
                    countryNameKr: item.countryNameKr,
                    souvenirCount: item.souvenirCount,
                    imageUrl: country.flagImageURL
                )
            }
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - AI (Authed)

    public func getAIRecommendationByPreferenceCategory() async throws -> [DiscoverySouvenir] {
        do {
            let dto = try await discoveryRemote.getAIPreferenceCategory()
            return mapSouvenirs(dto.souvenirs)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func getAIRecommendationByPreferenceUpload() async throws -> [DiscoverySouvenir] {
        do {
            let dto = try await discoveryRemote.getAIPreferenceUpload()
            return mapSouvenirs(dto.souvenirs)
        } catch {
            throw mapToDomainError(error)
        }
    }
}

// MARK: - Private

private extension DefaultDiscoveryRepository {
    func mapSouvenirs(_ dto: [DiscoverySouvenirResponse]) -> [DiscoverySouvenir] {
        dto.map {
            DiscoverySouvenir(
                id: $0.id,
                name: $0.name,
                category: $0.category,
                countryCode: $0.countryCode,
                thumbnailUrl: $0.thumbnailUrl
            )
        }
    }

    func mapToDomainError(_ error: Error) -> DiscoveryError {
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
