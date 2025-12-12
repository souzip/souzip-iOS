public extension Logger {
    func logLifecycle(
        caller: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let actualFile = caller.map { "\(String(describing: type(of: $0))).swift" } ?? file
        let actualLine = caller != nil ? 0 : line

        log(
            "Life Cycle",
            level: .info,
            category: .ui,
            file: actualFile,
            function: function,
            line: actualLine
        )
    }

    func logState(
        _ state: some Any,
        caller: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let actualFile = caller.map { "\(String(describing: type(of: $0))).swift" } ?? file
        let actualLine = caller != nil ? 0 : line

        log(
            "State Changed: \(state)",
            level: .debug,
            category: .ui,
            file: actualFile,
            function: function,
            line: actualLine
        )
    }

    func logAction(
        _ action: some Any,
        caller: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let actualFile = caller.map { "\(String(describing: type(of: $0))).swift" } ?? file
        let actualLine = caller != nil ? 0 : line

        log(
            "Action: \(action)",
            level: .debug,
            category: .ui,
            file: actualFile,
            function: function,
            line: actualLine
        )
    }

    func logEvent(
        _ event: some Any,
        caller: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let actualFile = caller.map { "\(String(describing: type(of: $0))).swift" } ?? file
        let actualLine = caller != nil ? 0 : line

        log(
            "Event: \(event)",
            level: .info,
            category: .ui,
            file: actualFile,
            function: function,
            line: actualLine
        )
    }

    func logRoute(
        _ route: some Any,
        caller: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let actualFile = caller.map { "\(String(describing: type(of: $0))).swift" } ?? file
        let actualLine = caller != nil ? 0 : line

        log(
            "Route: \(route)",
            level: .info,
            category: .ui,
            file: actualFile,
            function: function,
            line: actualLine
        )
    }
}
