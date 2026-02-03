import Domain
import Foundation
import Networking

public final class DefaultSouvenirRepository: SouvenirRepository {
    private(set) var needsMyPageRefresh: Bool = false

    private let souvenirRemote: SouvenirRemoteDataSource

    public init(souvenirRemote: SouvenirRemoteDataSource) {
        self.souvenirRemote = souvenirRemote
    }

    // MARK: - Get Souvenir

    public func getSouvenir(id: Int) async throws -> SouvenirDetail {
        do {
            let dto = try await souvenirRemote.getSouvenir(id: id)
            return SouvenirDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Create Souvenir

    public func createSouvenir(
        input: SouvenirInput,
        images: [Data]
    ) async throws -> SouvenirDetail {
        do {
            let request = SouvenirDTOMapper.toRequest(input)
            let multipartData = MultipartSouvenirData(
                souvenirRequest: request,
                imageFiles: images
            )

            let dto = try await souvenirRemote.createSouvenir(data: multipartData)
            needsMyPageRefresh = true
            return SouvenirDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Update Souvenir

    public func updateSouvenir(
        id: Int,
        input: SouvenirInput,
    ) async throws -> SouvenirDetail {
        do {
            let request = SouvenirDTOMapper.toRequest(input)
            let multipartData = MultipartSouvenirData(
                souvenirRequest: request,
                imageFiles: []
            )

            let dto = try await souvenirRemote.updateSouvenir(
                id: id,
                data: multipartData
            )
            needsMyPageRefresh = true
            return SouvenirDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Delete Souvenir

    public func deleteSouvenir(id: Int) async throws {
        do {
            try await souvenirRemote.deleteSouvenir(id: id)
            needsMyPageRefresh = true
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Get Nearby Souvenirs

    public func getNearbySouvenirs(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> [SouvenirListItem] {
        do {
            let dto = try await souvenirRemote.getNearbySouvenirs(
                latitude: latitude,
                longitude: longitude,
                radiusMeter: radiusMeter
            )
            return SouvenirDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func consumeMyPageNeedsRefresh() async -> Bool {
        defer { needsMyPageRefresh = false }
        return needsMyPageRefresh
    }
}

// MARK: - Error Mapper

private extension DefaultSouvenirRepository {
    func mapToDomainError(_ error: Error) -> SouvenirError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                return .unauthorized

            case .serverError:
                return .serverError

            case .noData:
                return .notFound

            case .invalidURL, .invalidResponse, .invalidEndpointType,
                 .unknown, .encodingError, .decodingError:
                return .networkError
            }
        }

        return .unknown
    }
}
