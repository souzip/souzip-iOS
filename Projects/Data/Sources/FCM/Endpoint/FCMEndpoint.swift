import Foundation
import Networking

public enum FCMEndpoint {
    case register(
        token: String,
        deviceId: String,
        deviceType: String,
        deviceModel: String?,
        osVersion: String?,
        appVersion: String?
    )
    case deactivate(deviceId: String)
}

extension FCMEndpoint: APIEndpoint {
    public var path: String {
        "/api/users/me/fcm-tokens"
    }

    public var method: HTTPMethod {
        switch self {
        case .register:
            .post
        case .deactivate:
            .delete
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var parameters: [String: Any]? {
        switch self {
        case .register:
            nil
        case let .deactivate(deviceId):
            ["deviceId": deviceId]
        }
    }

    public var body: Data? {
        switch self {
        case let .register(token, deviceId, deviceType, deviceModel, osVersion, appVersion):
            let request = RegisterFCMTokenRequest(
                token: token,
                deviceId: deviceId,
                deviceType: deviceType,
                deviceModel: deviceModel,
                osVersion: osVersion,
                appVersion: appVersion
            )
            return try? JSONEncoder().encode(request)

        case .deactivate:
            return nil
        }
    }
}
