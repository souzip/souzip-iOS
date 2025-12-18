import Foundation

public enum AppInfo {
    public static func string(_ key: InfoPlistKey) -> String? {
        Bundle.main.infoDictionary?[key.rawValue] as? String
    }

    public static func requiredString(_ key: InfoPlistKey) -> String {
        guard let value = string(key), !value.isEmpty else {
            fatalError("❌ \(key.rawValue) is missing. Check xcconfig / Info.plist.")
        }
        return value
    }

    public static var bundleID: String {
        Bundle.main.bundleIdentifier ?? "com.swyp.souzip.app"
    }

    public static var version: String {
        string(.bundleShortVersion) ?? "1.0.0"
    }
}
