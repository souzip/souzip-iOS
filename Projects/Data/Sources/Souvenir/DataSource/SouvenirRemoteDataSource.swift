import Foundation
import Networking

public protocol SouvenirRemoteDataSource {
    func getSouvenir(id: Int) async throws -> SouvenirDetailResponse
    func createSouvenir(data: MultipartSouvenirData) async throws -> SouvenirDetailResponse
    func updateSouvenir(id: Int, data: MultipartSouvenirData) async throws -> SouvenirDetailResponse
    func deleteSouvenir(id: Int) async throws
    func getNearbySouvenirs(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> NearbySouvenirsResponse
}

public final class DefaultSouvenirRemoteDataSource: SouvenirRemoteDataSource {
    private let plain: NetworkClient
    private let authed: NetworkClient

    public init(
        plain: NetworkClient,
        authed: NetworkClient
    ) {
        self.plain = plain
        self.authed = authed
    }

    // MARK: - Get Souvenir (인증 불필요)

    public func getSouvenir(id: Int) async throws -> SouvenirDetailResponse {
        let endpoint = SouvenirEndpoint.getSouvenir(id: id)
        let response: APIResponse<SouvenirDetailResponse> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    // MARK: - Create Souvenir (인증 필요)

    public func createSouvenir(data: MultipartSouvenirData) async throws -> SouvenirDetailResponse {
        let endpoint = SouvenirEndpoint.createSouvenir(data: data)
        let response: APIResponse<SouvenirDetailResponse> = try await authed
            .requestMultipart(endpoint)

        guard let responseData = response.data else {
            throw NetworkError.noData
        }

        return responseData
    }

    // MARK: - Update Souvenir (인증 필요)

    public func updateSouvenir(
        id: Int,
        data: MultipartSouvenirData
    ) async throws -> SouvenirDetailResponse {
        let endpoint = SouvenirEndpoint.updateSouvenir(id: id, data: data)
        let response: APIResponse<SouvenirDetailResponse> = try await authed
            .requestMultipart(endpoint)

        guard let responseData = response.data else {
            throw NetworkError.noData
        }

        return responseData
    }

    // MARK: - Delete Souvenir (인증 필요)

    public func deleteSouvenir(id: Int) async throws {
        let endpoint = SouvenirEndpoint.deleteSouvenir(id: id)
        let _: EmptyResponse = try await authed.request(endpoint)
    }

    // MARK: - Get Nearby Souvenirs (인증 불필요)

    public func getNearbySouvenirs(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int? = nil
    ) async throws -> NearbySouvenirsResponse {
        let endpoint = SouvenirEndpoint.getNearbySouvenirs(
            latitude: latitude,
            longitude: longitude,
            radiusMeter: radiusMeter
        )

        let response: APIResponse<NearbySouvenirsResponse> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }
}
