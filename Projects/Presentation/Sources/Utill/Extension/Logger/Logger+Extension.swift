import Logger

public extension Logger {
    func logLifecycle(
        caller: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let actualFile = caller.map { "\(String(describing: type(of: $0))).swift" } ?? file
        let actualLine = caller != nil ? 0 : line

        info(
            "Life Cycle",
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

        debug(
            "상태 변경: \(state)",
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

        debug(
            "사용자 액션: \(action)",
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

        info(
            "이벤트: \(event)",
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

        info(
            "화면 전환: \(route)",
            category: .ui,
            file: actualFile,
            function: function,
            line: actualLine
        )
    }
}
