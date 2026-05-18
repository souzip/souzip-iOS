import Domain
import Networking

public final class DefaultWishlistRepository: WishlistRepository {
    private let remote: WishlistRemoteDataSource

    public init(remote: WishlistRemoteDataSource) {
        self.remote = remote
    }

    public func addToWishlist(souvenirId: Int) async throws -> WishlistMutationResult {
        do {
            let dto = try await remote.addToWishlist(souvenirId: souvenirId)
            return WishlistDTOMapper.toDomain(dto)
        } catch {
            throw mapToWishlistError(error)
        }
    }

    public func removeFromWishlist(souvenirId: Int) async throws -> WishlistMutationResult {
        do {
            let dto = try await remote.removeFromWishlist(souvenirId: souvenirId)
            return WishlistDTOMapper.toDomain(dto)
        } catch {
            throw mapToWishlistError(error)
        }
    }
}

// MARK: - Mapper

private extension DefaultWishlistRepository {
    func mapToWishlistError(_ error: Error) -> WishlistError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                return .unauthorized

            case .noData:
                return .noData

            case let .serverError(statusCode, _):
                if statusCode == 409 {
                    return .conflict
                }
                return .mutationFailed

            case .decodingError, .encodingError, .invalidURL, .invalidResponse, .invalidEndpointType:
                return .mutationFailed

            case .unknown:
                return .mutationFailed
            }
        }
        return .unknown
    }
}
