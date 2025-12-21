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
            session: makeSession(),
            baseURL: config.baseURL
        )
    }

    public func makeAuthedClient(_ tokenRefresher: TokenRefresher) -> NetworkClient {
        DefaultNetworkClient.authed(
            session: makeSession(),
            baseURL: config.baseURL,
            tokenRefresher: tokenRefresher
        )
    }
}

private extension DefaultNetworkFactory {
    func makeSession() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = config.timeout
        sessionConfig.timeoutIntervalForResource = config.timeout
        return URLSession(configuration: sessionConfig)
    }
}
