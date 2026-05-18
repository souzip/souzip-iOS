import Foundation
import Networking

public protocol WishlistRemoteDataSource {
    func addToWishlist(souvenirId: Int) async throws -> WishlistMutationDataDTO
    func removeFromWishlist(souvenirId: Int) async throws -> WishlistMutationDataDTO
}

public final class DefaultWishlistRemoteDataSource: WishlistRemoteDataSource {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func addToWishlist(souvenirId: Int) async throws -> WishlistMutationDataDTO {
        let endpoint = WishlistEndpoint.addToWishlist(souvenirId: souvenirId)
        let response: APIResponse<WishlistMutationDataDTO> = try await networkClient.request(endpoint)
        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    public func removeFromWishlist(souvenirId: Int) async throws -> WishlistMutationDataDTO {
        let endpoint = WishlistEndpoint.removeFromWishlist(souvenirId: souvenirId)
        let response: APIResponse<WishlistMutationDataDTO> = try await networkClient.request(endpoint)
        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }
}
