import OSLog

public final class Logger {
    public static let shared = Logger(configuration: .debug)

    private let osLogger: OSLog
    private let configuration: LoggerConfiguration

    init(configuration: LoggerConfiguration) {
        self.configuration = configuration
        osLogger = OSLog(
            subsystem: configuration.subsystem,
            category: configuration.category
        )
    }

    func log(
        _ message: String,
        level: LogLevel = .info,
        category: LogCategory = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            let location = line > 0 ? "[\(fileName):\(line)]" : "[\(fileName)]"
            let logMessage = "[\(category.rawValue)] \(location) \(function) - \(message)"

            os_log(
                level.osLogType,
                log: osLogger,
                "%{public}@",
                logMessage
            )
        #endif
    }
}

public extension Logger {
    func debug(
        _ message: String,
        category: LogCategory = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .debug,
            category: category,
            file: file,
            function: function,
            line: line
        )
    }

    func info(
        _ message: String,
        category: LogCategory = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .info,
            category: category,
            file: file,
            function: function,
            line: line
        )
    }

    func warning(
        _ message: String,
        category: LogCategory = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .warning,
            category: category,
            file: file,
            function: function,
            line: line
        )
    }

    func error(
        _ message: String,
        category: LogCategory = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .error,
            category: category,
            file: file,
            function: function,
            line: line
        )
    }
}
