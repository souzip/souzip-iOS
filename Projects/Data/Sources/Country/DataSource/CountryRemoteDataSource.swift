import Foundation
import Networking

public protocol CountryRemoteDataSource {
    func getAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> GeocodingAddressResponse

    func searchLocations(
        keyword: String
    ) async throws -> SearchLocationsResponse
}

public final class DefaultCountryRemoteDataSource: CountryRemoteDataSource {
    private let plain: NetworkClient
    private let authed: NetworkClient

    public init(
        plain: NetworkClient,
        authed: NetworkClient
    ) {
        self.plain = plain
        self.authed = authed
    }

    // MARK: - Address API (인증 필요)

    public func getAddress(
        latitude: Double,
        longitude: Double
    ) async throws -> GeocodingAddressResponse {
        let endpoint = CountryEndpoint.geocodingAddress(
            latitude: latitude,
            longitude: longitude
        )

        let response: APIResponse<GeocodingAddressResponse> = try await authed.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    // MARK: - Search API (인증 불필요)

    public func searchLocations(
        keyword: String
    ) async throws -> SearchLocationsResponse {
        let endpoint = CountryEndpoint.searchLocations(keyword: keyword)

        let response: APIResponse<SearchLocationsResponse> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }
}
