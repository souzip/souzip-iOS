import Foundation

public struct DefaultsKey<Value> {
    public let name: String
    public let defaultValue: Value

    public init(_ name: String, default defaultValue: Value) {
        self.name = name
        self.defaultValue = defaultValue
    }
}

public enum AuthDefaultsKeys {
    public static let recentLoginProvider =
        DefaultsKey<String?>("recent_login_provider", default: nil)
}

public enum UserDefaultsKeys {
    public static let recentLoginPlatform =
        DefaultsKey<Data?>("recent_login_platform", default: nil)

    public static let cachedUser =
        DefaultsKey<Data?>("user_cached_profile", default: nil)

    public static let needsOnboarding =
        DefaultsKey<Bool>("needs_onboarding", default: false)
}
