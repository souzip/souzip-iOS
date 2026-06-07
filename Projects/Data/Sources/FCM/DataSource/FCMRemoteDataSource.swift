import Networking

protocol FCMRemoteDataSource {
    func register(request: RegisterFCMTokenRequest) async throws
    func deactivate(deviceId: String) async throws
}

final class DefaultFCMRemoteDataSource: FCMRemoteDataSource {
    private let authed: NetworkClient

    init(authed: NetworkClient) {
        self.authed = authed
    }

    func register(request: RegisterFCMTokenRequest) async throws {
        let endpoint = FCMEndpoint.register(
            token: request.token,
            deviceId: request.deviceId,
            deviceType: request.deviceType,
            deviceModel: request.deviceModel,
            osVersion: request.osVersion,
            appVersion: request.appVersion
        )
        let _: EmptyResponse = try await authed.request(endpoint)
    }

    func deactivate(deviceId: String) async throws {
        let endpoint = FCMEndpoint.deactivate(deviceId: deviceId)
        let _: EmptyResponse = try await authed.request(endpoint)
    }
}
