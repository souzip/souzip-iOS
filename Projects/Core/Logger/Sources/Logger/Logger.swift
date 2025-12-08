import OSLog

public final class Logger {
    public static let shared = Logger(configuration: .default)

    private let osLogger: OSLog
    private let configuration: LoggerConfiguration

    init(configuration: LoggerConfiguration) {
        self.configuration = configuration
        self.osLogger = OSLog(
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
        let logMessage = "[\(category.rawValue)] [\(fileName):\(line)] \(function) - \(message)"

        os_log(
            level.osLogType,
            log: osLogger,
            "%{public}@",
            logMessage
        )
        #endif
    }
}
