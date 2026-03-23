import Logger

public extension Logger {
    func userDefaultsError(
        message: String,
        key: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let composedMessage =
            """
            UserDefaults 처리 중 오류가 발생했습니다.
            - 메시지: \(message)
            - 키: \(key)
            """

        info(
            composedMessage,
            category: .database,
            file: file,
            function: function,
            line: line
        )
    }
}
