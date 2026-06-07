import Domain

enum FCMRequestMapper {
    static func toRegisterRequest(_ registration: FCMRegistration) -> RegisterFCMTokenRequest {
        RegisterFCMTokenRequest(
            token: registration.token,
            deviceId: registration.deviceId,
            deviceType: registration.deviceType.rawValue,
            deviceModel: registration.deviceModel,
            osVersion: registration.osVersion,
            appVersion: registration.appVersion
        )
    }
}
