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
                throw NetworkError.unknown(
                    NSError(domain: "응답 형식 오류", code: -1)
                )
            }

            Logger.shared.logNetworkResponse(httpResponse, data: data, endpoint: endpoint.path)

            if httpResponse.statusCode == 401, let refresher = tokenRefresher {
                return try await handleUnauthorized(
                    endpoint: endpoint,
                    isRetry: isRetry,
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
                throw NetworkError.unknown(
                    NSError(domain: "멀티파트 엔드포인트 타입 오류", code: -1)
                )
            }

            var urlRequest = try createMultipartURLRequest(multipartEndpoint)

            if let token = try? await tokenRefresher?.getAccessToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            logMultipartBodySizeIfPossible(urlRequest: urlRequest, endpoint: endpoint.path)

            Logger.shared.logNetworkRequest(urlRequest, endpoint: endpoint.path)

            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(
                    NSError(domain: "응답 형식 오류", code: -1)
                )
            }

            Logger.shared.logNetworkResponse(httpResponse, data: data, endpoint: endpoint.path)

            if httpResponse.statusCode == 401, let refresher = tokenRefresher {
                return try await handleMultipartUnauthorized(
                    endpoint: endpoint,
                    isRetry: isRetry,
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

    // MARK: - Body Size Logging

    private func logMultipartBodySizeIfPossible(urlRequest: URLRequest, endpoint: String) {
        if let body = urlRequest.httpBody {
            let bytes = body.count
            let mb = Double(bytes) / 1024.0 / 1024.0
            Logger.shared.info(
                "📦 멀티파트 요청 바디 크기: \(bytes) bytes (약 \(String(format: "%.2f", mb)) MB) [\(endpoint)]",
                category: .network
            )
        } else {
            Logger.shared.info(
                "📦 멀티파트 요청 바디가 nil 입니다. (파일/스트림 업로드 방식일 수 있어요.) [\(endpoint)]",
                category: .network
            )
        }
    }

    // MARK: - Unauthorized Handling

    private func handleUnauthorized<T>(
        endpoint: any APIEndpoint,
        isRetry: Bool,
        refresher: TokenRefresher
    ) async throws -> T where T: Decodable {
        guard !isRetry else {
            try? await refresher.clearTokens()
            Logger.shared.logAPIFailure(
                endpoint: endpoint.path,
                statusCode: 401,
                message: "인증에 실패했어요. 다시 로그인해주세요."
            )
            throw NetworkError.unauthorized
        }

        do {
            Logger.shared.info("🔄 토큰 갱신을 시도합니다.", category: .network)
            try await refresher.refreshToken()
            Logger.shared.info("✅ 토큰 갱신 성공! 요청을 다시 시도합니다.", category: .network)

            return try await performRequest(endpoint, isRetry: true)
        } catch {
            try? await refresher.clearTokens()
            Logger.shared.error("❌ 토큰 갱신 실패: \(error.localizedDescription)", category: .network)
            throw NetworkError.unauthorized
        }
    }

    private func handleMultipartUnauthorized<T>(
        endpoint: any APIEndpoint,
        isRetry: Bool,
        refresher: TokenRefresher
    ) async throws -> T where T: Decodable {
        guard !isRetry else {
            try? await refresher.clearTokens()
            Logger.shared.logAPIFailure(
                endpoint: endpoint.path,
                statusCode: 401,
                message: "인증에 실패했어요. 다시 로그인해주세요. (멀티파트)"
            )
            throw NetworkError.unauthorized
        }

        do {
            Logger.shared.info("🔄 토큰 갱신을 시도합니다. (멀티파트)", category: .network)
            try await refresher.refreshToken()
            Logger.shared.info("✅ 토큰 갱신 성공! 멀티파트 요청을 다시 시도합니다.", category: .network)

            return try await performMultipartRequest(endpoint, isRetry: true)
        } catch {
            try? await refresher.clearTokens()
            Logger.shared.error("❌ 토큰 갱신 실패(멀티파트): \(error.localizedDescription)", category: .network)
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

        case 401:
            Logger.shared.logAPIFailure(
                endpoint: endpoint,
                statusCode: 401,
                message: "인증이 만료되었어요. 다시 로그인해주세요."
            )
            throw NetworkError.unauthorized

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
