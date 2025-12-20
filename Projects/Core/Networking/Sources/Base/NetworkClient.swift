import Foundation
import Logger

public protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

public final class DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let baseURL: String
    private let tokenRefresher: TokenRefresher?

    private init(
        session: URLSession,
        baseURL: String,
        tokenRefresher: TokenRefresher?
    ) {
        self.session = session
        self.baseURL = baseURL
        self.tokenRefresher = tokenRefresher
    }

    // MARK: - Factory Methods

    public static func authed(
        session: URLSession = .shared,
        baseURL: String,
        tokenRefresher: TokenRefresher
    ) -> DefaultNetworkClient {
        DefaultNetworkClient(
            session: session,
            baseURL: baseURL,
            tokenRefresher: tokenRefresher
        )
    }

    public static func plain(
        session: URLSession = .shared,
        baseURL: String
    ) -> DefaultNetworkClient {
        DefaultNetworkClient(
            session: session,
            baseURL: baseURL,
            tokenRefresher: nil
        )
    }

    public func request<T>(_ endpoint: any APIEndpoint) async throws -> T where T: Decodable {
        try await performRequest(endpoint, isRetry: false)
    }

    // MARK: - Private Implementation

    /// 내부 구현 - isRetry 파라미터 포함
    private func performRequest<T>(
        _ endpoint: any APIEndpoint,
        isRetry: Bool
    ) async throws -> T where T: Decodable {
        // 1. Access Token 자동 주입
        var urlRequest = try endpoint.asURLRequest(baseURL: baseURL)
        if let token = try? await tokenRefresher?.getAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        Logger.shared.logNetworkRequest(urlRequest, endpoint: endpoint.path)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "Invalid Response", code: -1))
        }

        Logger.shared.logNetworkResponse(httpResponse, data: data, endpoint: endpoint.path)

        // 2. 401 처리 (tokenRefresher가 있을 때만)
        if httpResponse.statusCode == 401, let refresher = tokenRefresher {
            return try await handleUnauthorized(
                endpoint: endpoint,
                isRetry: isRetry,
                refresher: refresher
            )
        }

        return try handleResponse(httpResponse, data: data, endpoint: endpoint.path)
    }

    // MARK: - Private Logic

    private func handleUnauthorized<T>(
        endpoint: any APIEndpoint,
        isRetry: Bool,
        refresher: TokenRefresher
    ) async throws -> T where T: Decodable {
        // 이미 재시도했으면 포기
        guard !isRetry else {
            try? await refresher.clearTokens()
            Logger.shared.logAPIFailure(
                endpoint: endpoint.path,
                statusCode: 401,
                message: "Unauthorized - Refresh failed"
            )
            throw NetworkError.unauthorized
        }

        // 토큰 갱신 시도
        do {
            Logger.shared.info("Attempting token refresh", category: .network)
            try await refresher.refreshToken()
            Logger.shared.info("Token refresh successful, retrying request", category: .network)

            // 재시도
            return try await performRequest(endpoint, isRetry: true)
        } catch {
            // Refresh 실패 → 로그아웃
            try? await refresher.clearTokens()
            Logger.shared.error(
                "Token refresh failed: \(error.localizedDescription)",
                category: .network
            )
            throw NetworkError.unauthorized
        }
    }

    private func handleResponse<T>(
        _ response: HTTPURLResponse,
        data: Data,
        endpoint: String
    ) throws -> T where T: Decodable {
        switch response.statusCode {
        case 200 ... 299:
            let decoded = try JSONDecoder().decode(T.self, from: data)
            Logger.shared.logAPISuccess(endpoint: endpoint, statusCode: response.statusCode)
            return decoded

        case 401:
            Logger.shared.logAPIFailure(endpoint: endpoint, statusCode: 401, message: "Unauthorized")
            throw NetworkError.unauthorized

        default:
            let errorMessage = try? JSONDecoder()
                .decode(ErrorResponse.self, from: data)
                .message

            Logger.shared.logAPIFailure(
                endpoint: endpoint,
                statusCode: response.statusCode,
                message: errorMessage
            )

            throw NetworkError.serverError(
                statusCode: response.statusCode,
                message: errorMessage
            )
        }
    }
}
