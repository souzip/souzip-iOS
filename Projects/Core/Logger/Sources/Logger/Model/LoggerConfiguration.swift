import Foundation

struct LoggerConfiguration {
    public static let debug = LoggerConfiguration(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.app"
    )

    let subsystem: String
    let category: String

    public init(
        subsystem: String,
        category: String = "App",
    ) {
        self.subsystem = subsystem
        self.category = category
    }
}
