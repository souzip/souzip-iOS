import Foundation

public struct NetworkConfiguration {
    public let baseURL: String
    public let timeout: TimeInterval

    public init(
        baseURL: String,
        timeout: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
    }
}
