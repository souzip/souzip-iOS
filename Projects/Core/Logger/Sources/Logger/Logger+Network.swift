import Foundation

public extension Logger {
    func logNetworkRequest(
        _ request: URLRequest,
        endpoint: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var message = "🌐 Network Request"
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

        log(
            message,
            level: .info,
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

        var message = isSuccess ? "✅ Network Response" : "⚠️ Network Response"
        if let endpoint {
            message += " [\(endpoint)]"
        }

        message += "\n"
        message += "Status Code: \(statusCode)\n"
        message += "URL: \(response.url?.absoluteString ?? "N/A")"

        if let data {
            message += "\nData Size: \(data.count) bytes"

            // JSON인 경우 예쁘게 출력
            if let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(
                   withJSONObject: json,
                   options: .prettyPrinted
               ),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                message += "\nResponse Body:\n\(prettyString)"
            }
        }

        let level: LogLevel = isSuccess ? .info : .warning

        log(
            message,
            level: level,
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }

    /// 네트워크 에러 로깅
    func logNetworkError(
        _ error: Error,
        endpoint: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var message = "❌ Network Error"
        if let endpoint {
            message += " [\(endpoint)]"
        }

        message += "\n"
        message += "Error: \(error.localizedDescription)\n"
        message += "Type: \(String(describing: type(of: error)))"

        log(
            message,
            level: .error,
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
        log(
            "📡 API Call: \(method) \(endpoint)",
            level: .debug,
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
        log(
            "✅ API Success: \(endpoint) (\(statusCode))",
            level: .info,
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
        var logMessage = "❌ API Failure: \(endpoint)\n"
        logMessage += "Status Code: \(statusCode)\n"
        logMessage += "Message: \(message ?? "No message")"

        log(
            logMessage,
            level: .error,
            category: .network,
            file: file,
            function: function,
            line: line
        )
    }
}
