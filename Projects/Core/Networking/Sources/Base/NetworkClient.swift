import Foundation
import Logger

public protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func requestMultipart<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
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

    // MARK: - Regular Request

    public func request<T>(_ endpoint: any APIEndpoint) async throws -> T where T: Decodable {
        try await performRequest(endpoint, isRetry: false)
    }

    // MARK: - Multipart Request

    public func requestMultipart<T>(_ endpoint: any APIEndpoint) async throws -> T where T: Decodable {
        try await performMultipartRequest(endpoint, isRetry: false)
    }

    // MARK: - Private Implementation

    private func performRequest<T>(
        _ endpoint: any APIEndpoint,
        isRetry: Bool
    ) async throws -> T where T: Decodable {
        do {
            var urlRequest = try endpoint.asURLRequest(baseURL: baseURL)

            if let token = try? await tokenRefresher?.getAccessToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            Logger.shared.logNetworkRequest(urlRequest, endpoint: endpoint.path)

            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            Logger.shared.logNetworkResponse(httpResponse, data: data, endpoint: endpoint.path)

            if httpResponse.statusCode == 401, let refresher = tokenRefresher {
                return try await handleUnauthorized(
                    endpoint: endpoint,
                    isRetry: isRetry,
                    isMultipart: false,
                    refresher: refresher
                )
            }

            return try handleResponse(httpResponse, data: data, endpoint: endpoint.path)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    // MARK: - Private Implementation (Multipart)

    private func performMultipartRequest<T>(
        _ endpoint: any APIEndpoint,
        isRetry: Bool
    ) async throws -> T where T: Decodable {
        do {
            guard let multipartEndpoint = endpoint as? MultipartEndpoint else {
                throw NetworkError.invalidEndpointType
            }

            var urlRequest = try createMultipartURLRequest(multipartEndpoint)

            if let token = try? await tokenRefresher?.getAccessToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            Logger.shared.logMultipartBodySize(
                bodySize: urlRequest.httpBody?.count,
                endpoint: endpoint.path
            )

            Logger.shared.logNetworkRequest(urlRequest, endpoint: endpoint.path)

            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            Logger.shared.logNetworkResponse(httpResponse, data: data, endpoint: endpoint.path)

            if httpResponse.statusCode == 401, let refresher = tokenRefresher {
                return try await handleUnauthorized(
                    endpoint: endpoint,
                    isRetry: isRetry,
                    isMultipart: true,
                    refresher: refresher
                )
            }

            return try handleResponse(httpResponse, data: data, endpoint: endpoint.path)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    private func createMultipartURLRequest(_ endpoint: MultipartEndpoint) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = endpoint.createMultipartBody(boundary: boundary)

        return request
    }

    // MARK: - Unauthorized Handling

    private func handleUnauthorized<T>(
        endpoint: any APIEndpoint,
        isRetry: Bool,
        isMultipart: Bool,
        refresher: TokenRefresher
    ) async throws -> T where T: Decodable {
        guard !isRetry else {
            try? await refresher.clearTokens()
            Logger.shared.logAuthorizationFailure(
                endpoint: endpoint.path,
                isMultipart: isMultipart
            )
            throw NetworkError.unauthorized
        }

        do {
            Logger.shared.logTokenRefreshStart(isMultipart: isMultipart)
            try await refresher.refreshToken()
            Logger.shared.logTokenRefreshSuccess(isMultipart: isMultipart)

            if isMultipart {
                return try await performMultipartRequest(endpoint, isRetry: true)
            } else {
                return try await performRequest(endpoint, isRetry: true)
            }
        } catch {
            try? await refresher.clearTokens()
            Logger.shared.logTokenRefreshFailure(error: error, isMultipart: isMultipart)
            throw NetworkError.unauthorized
        }
    }

    // MARK: - Response Handling

    private func handleResponse<T>(
        _ response: HTTPURLResponse,
        data: Data,
        endpoint: String
    ) throws -> T where T: Decodable {
        switch response.statusCode {
        case 200 ... 299:
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                Logger.shared.logAPISuccess(endpoint: endpoint, statusCode: response.statusCode)
                return decoded
            } catch {
                throw NetworkError.decodingError(error)
            }
        default:
            let errorMessage = (try? JSONDecoder()
                .decode(ErrorResponse.self, from: data)
                .message) ?? "알 수 없는 오류가 발생했어요."

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
