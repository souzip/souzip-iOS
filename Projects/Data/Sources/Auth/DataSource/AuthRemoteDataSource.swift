import Foundation
import Networking

public protocol AuthRemoteDataSource {
    func login(platform: OAuthPlatform) async throws -> LoginResponse
    func refresh(refreshToken: String) async throws -> RefreshResponse
    func logout() async throws
    func withdraw() async throws
}

public final class DefaultAuthRemoteDataSource: AuthRemoteDataSource {
    private let plain: NetworkClient
    private let authed: NetworkClient?
    private let oauthServices: [OAuthPlatform: OAuthService]

    public init(
        plain: NetworkClient,
        authed: NetworkClient?,
        oauthServices: [OAuthPlatform: OAuthService]
    ) {
        self.plain = plain
        self.authed = authed
        self.oauthServices = oauthServices
    }

    public func login(platform: OAuthPlatform) async throws -> LoginResponse {
        guard let service = oauthServices[platform] else {
            throw OAuthServiceError.notSupported
        }

        let oauthToken = try await service.login()
        let endpoint = AuthEndpoint.login(
            provider: platform.apiPath,
            accessToken: oauthToken
        )

        let response: APIResponse<LoginResponse> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    public func refresh(refreshToken: String) async throws -> RefreshResponse {
        let endpoint = AuthEndpoint.refresh(refreshToken: refreshToken)
        let response: APIResponse<RefreshResponse> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    public func logout() async throws {
        guard let authed else { return }

        let endpoint = AuthEndpoint.logout
        let _: EmptyResponse = try await authed.request(endpoint)
    }

    public func withdraw() async throws {
        guard let authed else { return }

        let endpoint = AuthEndpoint.withdraw
        let _: EmptyResponse = try await authed.request(endpoint)
    }
}
