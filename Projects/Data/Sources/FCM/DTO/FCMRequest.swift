struct RegisterFCMTokenRequest: Encodable {
    let token: String
    let deviceId: String
    let deviceType: String
    let deviceModel: String?
    let osVersion: String?
    let appVersion: String?
}
