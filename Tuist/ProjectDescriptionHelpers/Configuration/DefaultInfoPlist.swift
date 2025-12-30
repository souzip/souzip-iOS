import ProjectDescription

public enum DefaultInfoPlist {
    // MARK: - Base Configuration

    private static let base: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string(Environment.appVersion),
        "CFBundleVersion": .string(Environment.appBuildVersion),
        "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
        "UIDesignRequiresCompatibility": true,
    ]

    // MARK: - Privacy Configuration

    private static let privacy: [String: Plist.Value] = [
        "NSLocationWhenInUseUsageDescription": "",
    ]

    // MARK: - App Configuration

    private static let appSpecific: [String: Plist.Value] = [
        // API Keys & Tokens
        "API_BASE_URL": "$(API_BASE_URL)",
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "GOOGLE_CLIENT_ID": "$(GOOGLE_CLIENT_ID)",
        "MBXAccessToken": "$(MAPBOX_ACCESS_TOKEN)",

        // UI Configuration
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
        ],

        // URL Schemes
        "LSApplicationQueriesSchemes": [
          "kakaokompassauth",
          "kakaolink",
          "kakaoplus"
        ],
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": [
                    "kakao$(KAKAO_APP_KEY)"
                ]
            ],
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": [
                    "$(GOOGLE_REVERSED_CLIENT_ID)"
                ]
            ]
        ],
    ]
    
    // MARK: - Public InfoPlists
    
    public static let app: InfoPlist = .extendingDefault(
        with: base
            .merging(privacy)
            .merging(appSpecific)
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
