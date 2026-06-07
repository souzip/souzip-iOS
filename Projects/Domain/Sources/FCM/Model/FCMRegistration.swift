public struct FCMRegistration: Sendable {
    public let token: String
    public let deviceId: String
    public let deviceType: FCMDeviceType
    public let deviceModel: String?
    public let osVersion: String?
    public let appVersion: String?

    public init(
        token: String,
        deviceId: String,
        deviceType: FCMDeviceType,
        deviceModel: String?,
        osVersion: String?,
        appVersion: String?
    ) {
        self.token = token
        self.deviceId = deviceId
        self.deviceType = deviceType
        self.deviceModel = deviceModel
        self.osVersion = osVersion
        self.appVersion = appVersion
    }
}
