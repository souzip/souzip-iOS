import Foundation
import Networking

public protocol UserRemoteDataSource {
    func getUserProfile() async throws -> UserProfileResponse
    func getUserSouvenirs(request: SouvenirListRequest) async throws -> UserSouvenirsResponse
    func getUserWishlists(request: SouvenirListRequest) async throws -> UserWishlistsResponse
}

public final class DefaultUserRemoteDataSource: UserRemoteDataSource {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func getUserProfile() async throws -> UserProfileResponse {
        let endpoint = UserEndpoint.getUserProfile
        let response: APIResponse<UserProfileResponse> = try await networkClient.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    public func getUserSouvenirs(request: SouvenirListRequest) async throws -> UserSouvenirsResponse {
        let endpoint = UserEndpoint.getUserSouvenirs(
            page: request.page,
            size: request.size
        )
        let response: APIResponse<UserSouvenirsResponse> = try await networkClient.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    public func getUserWishlists(request: SouvenirListRequest) async throws -> UserWishlistsResponse {
        let endpoint = UserEndpoint.getUserWishlists(
            page: request.page,
            size: request.size
        )
        let response: APIResponse<UserWishlistsResponse> = try await networkClient.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }
}
