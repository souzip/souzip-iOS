import ProjectDescription

public enum DefaultInfoPlist {
    
    // MARK: - Base Configuration
    
    private static let base: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string(Environment.appVersion),
        "CFBundleVersion": .string(Environment.appBuildVersion),
        "CFBundleDisplayName": "$(APP_DISPLAY_NAME)"
    ]
    
    // MARK: - App Configuration
    
    private static let appSpecific: [String: Plist.Value] = [
        "UILaunchStoryboardName": "LaunchScreen",
        "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
        ],
        "UIUserInterfaceStyle": "Dark",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                ]
            ]
        ]
    ]
    
    // MARK: - Public InfoPlists
    
    public static let app: InfoPlist = .extendingDefault(
        with: base.merging(appSpecific)
    )

    public static let framework: InfoPlist = .default
    
    public static let test: InfoPlist = .default
}

// MARK: - Extensions

private extension Dictionary where Key == String, Value == Plist.Value {
    func merging(_ other: [String: Plist.Value]) -> [String: Plist.Value] {
        self.merging(other) { _, new in new }
    }
}
