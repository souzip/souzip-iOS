public extension Logger {
    func logLifecycle(
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            "Life Cycle",
            level: .info,
            category: .ui,
            file: file,
            function: function,
            line: line
        )
    }

    func logAction(
        _ action: CustomStringConvertible,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            "Action: \(action)",
            level: .debug,
            category: .ui,
            file: file,
            function: function,
            line: line
        )
    }
}
