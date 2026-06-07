import Domain
import Networking
import Storage

final class DefaultFCMRepository: FCMRepository {
    private let fcmRemote: FCMRemoteDataSource
    private let deviceIdStore: DeviceIdProviding

    init(
        fcmRemote: FCMRemoteDataSource,
        deviceIdStore: DeviceIdProviding
    ) {
        self.fcmRemote = fcmRemote
        self.deviceIdStore = deviceIdStore
    }

    func register(_ registration: FCMRegistration) async throws {
        do {
            let request = FCMRequestMapper.toRegisterRequest(registration)
            try await fcmRemote.register(request: request)
        } catch {
            throw mapToDomainError(error)
        }
    }

    func deactivate() async throws {
        do {
            let deviceId = try await deviceIdStore.deviceId()
            try await fcmRemote.deactivate(deviceId: deviceId)
        } catch {
            throw mapToDomainError(error)
        }
    }
}

// MARK: - Private

private extension DefaultFCMRepository {
    func mapToDomainError(_ error: Error) -> FCMError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverError:
                return .serverError
            case .unauthorized, .invalidURL, .invalidResponse,
                 .invalidEndpointType, .unknown, .encodingError, .decodingError,
                 .noData:
                return .networkError
            }
        }
        return .unknown
    }
}
