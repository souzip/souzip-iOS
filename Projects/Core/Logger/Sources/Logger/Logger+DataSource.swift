extension Logger {
    public func logAPIRequest<T: EndpointLoggable>(
        _ endpoint: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log("[\(endpoint.method)] \(endpoint.path) 요청 시작", level: .debug, category: .network, file: file, function: function, line: line)
    }

    public func logAPISuccess<T: EndpointLoggable>(
        _ endpoint: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log("\(endpoint.path) 응답 성공", level: .info, category: .network, file: file, function: function, line: line)
    }

    public func logAPIFailure<T: EndpointLoggable>(
        _ endpoint: T,
        error: Error,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log("\(endpoint.path) 응답 실패: \(error.localizedDescription)", level: .error, category: .network, file: file, function: function, line: line)
    }
}
