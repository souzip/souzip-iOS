import Foundation

public struct LoggerConfiguration {
    let subsystem: String
    let category: String

    public init(
        subsystem: String,
        category: String = "App",
    ) {
        self.subsystem = subsystem
        self.category = category
    }

    public static let `default` = LoggerConfiguration(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.app"
    )
}
