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

    public func loadCountrySouvenirs() async throws -> [CountryTopSouvenir] {
        do {
            let dtos = try await discoveryRemote.loadTop10CountrySouvenirs()

            return dtos.map { dto in
                CountryTopSouvenir(
                    countryCode: dto.countryCode,
                    countryNameKr: dto.countryNameKr,
                    souvenirCount: dto.souvenirCount,
                    souvenirs: DiscoveryDTOMapper.toDomain(dto.souvenirs)
                )
            }
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func loadTopSouvenirsByCategory(
        category: SouvenirCategory
    ) async throws -> [CatalogSouvenir] {
        do {
            let categoryName = OnboardingDTOMapper.toDTO(category)
            let dto = try await discoveryRemote.loadTop10ByCategory(categoryName: categoryName)
            return DiscoveryDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - AI (Authed)

    public func loadAIRecommendationsForCategory() async throws -> [CatalogSouvenir] {
        do {
            let dto = try await discoveryRemote.loadAIPreferenceCategory()
            return DiscoveryDTOMapper.toDomain(dto.souvenirs)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func loadAIRecommendationsForUpload() async throws -> [CatalogSouvenir] {
        do {
            let dto = try await discoveryRemote.loadAIPreferenceUpload()
            return DiscoveryDTOMapper.toDomain(dto.souvenirs)
        } catch {
            throw mapToDomainError(error)
        }
    }
}

// MARK: - Private

private extension DefaultDiscoveryRepository {
    func mapToDomainError(_ error: Error) -> DiscoveryError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                return .unauthorized
            case .serverError:
                return .serverError
            case .noData:
                return .notFound
            case .invalidURL, .invalidResponse, .invalidEndpointType, .unknown, .encodingError, .decodingError:
                return .networkError
            }
        }
        return .unknown
    }
}
