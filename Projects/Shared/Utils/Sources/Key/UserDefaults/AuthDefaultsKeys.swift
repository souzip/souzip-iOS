import Foundation

public enum AuthDefaultsKeys {
    public static let recentLoginPlatform =
        DefaultsKey<Data?>("recent_login_platform", default: nil)
}
