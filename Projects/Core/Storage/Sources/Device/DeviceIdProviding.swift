public protocol DeviceIdProviding: Sendable {
    func deviceId() async throws -> String
}
