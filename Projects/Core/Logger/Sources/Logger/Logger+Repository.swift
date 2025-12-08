extension Logger {
    public func logRepository(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .debug,
            category: .repository,
            file: file,
            function: function,
            line: line
        )
    }
}
