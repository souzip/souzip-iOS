import Foundation
import Logger

public protocol NetworkFactory: AnyObject {
    func makePlainClient() -> NetworkClient
    func makeAuthedClient(_ tokenRefresher: TokenRefresher) -> NetworkClient
}

public final class DefaultNetworkFactory: NetworkFactory {
    private let config: NetworkConfiguration

    public init(config: NetworkConfiguration) {
        self.config = config
    }

    public func makePlainClient() -> NetworkClient {
        DefaultNetworkClient.plain(
            baseURL: config.baseURL
        )
    }

    public func makeAuthedClient(_ tokenRefresher: TokenRefresher) -> NetworkClient {
        DefaultNetworkClient.authed(
            baseURL: config.baseURL,
            tokenRefresher: tokenRefresher
        )
    }
}
