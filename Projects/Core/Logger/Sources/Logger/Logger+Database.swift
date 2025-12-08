public extension Logger {
    func logDatabase(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .debug,
            category: .database,
            file: file,
            function: function,
            line: line
        )
    }
}
