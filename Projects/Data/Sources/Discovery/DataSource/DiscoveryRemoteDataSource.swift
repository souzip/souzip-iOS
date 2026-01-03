import Foundation
import Networking

public protocol DiscoveryRemoteDataSource {
    // Public
    func getTop10ByCountry(countryCode: String) async throws -> [DiscoverySouvenirResponse]
    func getTop10ByCategory(categoryName: String) async throws -> [DiscoverySouvenirResponse]
    func getTop3CountryStats() async throws -> [DiscoveryCountryStatResponse]

    // AI (Authed)
    func getAIPreferenceCategory() async throws -> AIRecommendationResponse
    func getAIPreferenceUpload() async throws -> AIRecommendationResponse
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

    public func getTop10ByCountry(countryCode: String) async throws -> [DiscoverySouvenirResponse] {
        let endpoint = DiscoveryEndpoint.top10ByCountry(countryCode: countryCode)
        let response: APIResponse<[DiscoverySouvenirResponse]> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    public func getTop10ByCategory(categoryName: String) async throws -> [DiscoverySouvenirResponse] {
        let endpoint = DiscoveryEndpoint.top10ByCategory(categoryName: categoryName)
        let response: APIResponse<[DiscoverySouvenirResponse]> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    public func getTop3CountryStats() async throws -> [DiscoveryCountryStatResponse] {
        let endpoint = DiscoveryEndpoint.top3CountryStats
        let response: APIResponse<[DiscoveryCountryStatResponse]> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    // MARK: - AI (Authed)

    public func getAIPreferenceCategory() async throws -> AIRecommendationResponse {
        let endpoint = DiscoveryEndpoint.aiPreferenceCategory
        let response: APIResponse<AIRecommendationResponse> = try await authed.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }

    public func getAIPreferenceUpload() async throws -> AIRecommendationResponse {
        let endpoint = DiscoveryEndpoint.aiPreferenceUpload
        let response: APIResponse<AIRecommendationResponse> = try await authed.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }
}
