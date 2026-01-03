import Foundation
import Networking

public protocol UserRemoteDataSource {
    func getUserProfile() async throws -> UserProfileResponse
    func getUserSouvenirs(request: SouvenirListRequest) async throws -> UserSouvenirsResponse
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
}
