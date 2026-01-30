import Foundation
import Logger

extension Logger {
    func logNetworkRequest(
        _ request: URLRequest,
        endpoint: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var message = "🌐 네트워크 요청"
        if let endpoint {
            message += " [\(endpoint)]"
        }

        message += "\n"
        message += "URL: \(request.url?.absoluteString ?? "N/A")\n"
        message += "Method: \(request.httpMethod ?? "N/A")"

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            message += "\nHeaders: \(headers)"
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            message += "\nBody: \(bodyString)"
        }

        info(
            message,
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// 네트워크 응답 로깅
    func logNetworkResponse(
        _ response: HTTPURLResponse,
        data: Data?,
        endpoint: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let statusCode = response.statusCode
        let isSuccess = (200 ... 299).contains(statusCode)

        var message = isSuccess ? "✅ 네트워크 응답" : "⚠️ 네트워크 응답"
        if let endpoint {
            message += " [\(endpoint)]"
        }

        message += "\n"
        message += "Status Code: \(statusCode)\n"
        message += "URL: \(response.url?.absoluteString ?? "N/A")"

        if let data {
            message += "\nData Size: \(data.count) bytes"

            if let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(
                   withJSONObject: json,
                   options: .prettyPrinted
               ),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                message += "\nResponse Body:\n\(prettyString)"
            }
        }

        if isSuccess {
            info(
                message,
                category: .network,
                file: file,
                function: function,
                line: line
            )
        } else {
            warning(
                message,
                category: .network,
                file: file,
                function: function,
                line: line
            )
        }
    }

    /// 네트워크 에러 로깅
    func logNetworkError(
        _ error: Error,
        endpoint: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var message = "❌ 네트워크 오류"
        if let endpoint {
            message += " [\(endpoint)]"
        }

        message += "\n"
        message += "Error: \(error.localizedDescription)\n"
        message += "Type: \(String(describing: type(of: error)))"

        self.error(
            message,
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// API 호출 시작 로깅 (간단 버전)
    func logAPICall(
        endpoint: String,
        method: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        debug(
            "📡 API 호출: \(method) \(endpoint)",
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// API 응답 성공 로깅 (간단 버전)
    func logAPISuccess(
        endpoint: String,
        statusCode: Int,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        info(
            "✅ API 성공: \(endpoint) (\(statusCode))",
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// API 응답 실패 로깅 (간단 버전)
    func logAPIFailure(
        endpoint: String,
        statusCode: Int,
        message: String?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var logMessage = "❌ API 실패: \(endpoint)\n"
        logMessage += "Status Code: \(statusCode)\n"
        logMessage += "Message: \(message ?? "No message")"

        error(
            logMessage,
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// 토큰 갱신 시작 로깅
    func logTokenRefreshStart(
        isMultipart: Bool = false,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let type = isMultipart ? "(멀티파트)" : ""
        info(
            "🔄 토큰 갱신을 시도합니다. \(type)",
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// 토큰 갱신 성공 로깅
    func logTokenRefreshSuccess(
        isMultipart: Bool = false,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let type = isMultipart ? "멀티파트 " : ""
        info(
            "✅ 토큰 갱신 성공! \(type)요청을 다시 시도합니다.",
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// 토큰 갱신 실패 로깅
    func logTokenRefreshFailure(
        error: Error,
        isMultipart: Bool = false,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let type = isMultipart ? "(멀티파트)" : ""
        self.error(
            "❌ 토큰 갱신 실패\(type): \(error.localizedDescription)",
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// 멀티파트 바디 크기 로깅
    func logMultipartBodySize(
        bodySize: Int?,
        endpoint: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        if let bytes = bodySize {
            let mb = Double(bytes) / 1024.0 / 1024.0
            info(
                "📦 멀티파트 요청 바디 크기: \(bytes) bytes (약 \(String(format: "%.2f", mb)) MB) [\(endpoint)]",
                category: .network,
                file: file,
                function: function,
                line: line
            )
        } else {
            info(
                "📦 멀티파트 요청 바디가 nil입니다. (파일/스트림 업로드 방식일 수 있어요.) [\(endpoint)]",
                category: .network,
                file: file,
                function: function,
                line: line
            )
        }
    }

    /// 인증 실패 로깅 (재시도 실패 케이스)
    func logAuthorizationFailure(
        endpoint: String,
        isMultipart: Bool = false,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let type = isMultipart ? " (멀티파트)" : ""
        logAPIFailure(
            endpoint: endpoint,
            statusCode: 401,
            message: "인증에 실패했어요. 다시 로그인해주세요.\(type)",
            file: file,
            function: function,
            line: line
        )
    }
}
