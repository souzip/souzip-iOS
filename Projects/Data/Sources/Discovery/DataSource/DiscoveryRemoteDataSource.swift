import Foundation
import Networking

public protocol DiscoveryRemoteDataSource {
    // Public
    func loadTop10CountrySouvenirs() async throws -> [Top10CountrySouvenirResponse]
    func loadTop10ByCategory(categoryName: String) async throws -> [DiscoverySouvenirResponse]

    // AI (Authed)
    func loadAIPreferenceCategory() async throws -> AIRecommendationResponse
    func loadAIPreferenceUpload() async throws -> AIRecommendationResponse
}

public final class DefaultDiscoveryRemoteDataSource: DiscoveryRemoteDataSource {
    private let plain: NetworkClient
    private let authed: NetworkClient

    public init(
        plain: NetworkClient,
        authed: NetworkClient
    ) {
        self.plain = plain
        self.authed = authed
    }

    // MARK: - Public

    public func loadTop10CountrySouvenirs() async throws -> [Top10CountrySouvenirResponse] {
        let endpoint = DiscoveryEndpoint.top10CountrySouvenirs
        let response: APIResponse<[Top10CountrySouvenirResponse]> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    public func loadTop10ByCategory(categoryName: String) async throws -> [DiscoverySouvenirResponse] {
        let endpoint = DiscoveryEndpoint.top10ByCategory(categoryName: categoryName)
        let response: APIResponse<[DiscoverySouvenirResponse]> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    // MARK: - AI (Authed)

    public func loadAIPreferenceCategory() async throws -> AIRecommendationResponse {
        let endpoint = DiscoveryEndpoint.aiPreferenceCategory
        let response: APIResponse<AIRecommendationResponse> = try await authed.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    public func loadAIPreferenceUpload() async throws -> AIRecommendationResponse {
        let endpoint = DiscoveryEndpoint.aiPreferenceUpload
        let response: APIResponse<AIRecommendationResponse> = try await authed.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }
}
