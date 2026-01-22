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
        "NSLocationWhenInUseUsageDescription": "지도에서 내 위치를 확인하여 근처 기념품을 추천받기 위해 권한이 필요합니다.(필수권한)",
        "NSPhotoLibraryUsageDescription": "기념품 사진을 업로드하기 위해 사진 라이브러리 접근 권한이 필요합니다.(필수권한)",
    ]

    // MARK: - App Configuration

    private static let appSpecific: [String: Plist.Value] = [
        // API Keys & Tokens
        "API_BASE_URL": "$(API_BASE_URL)",
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "GOOGLE_CLIENT_ID": "$(GOOGLE_CLIENT_ID)",
        "MBXAccessToken": "$(MAPBOX_ACCESS_TOKEN)",
        "AMPLITUDE_API_KEY": "$(AMPLITUDE_API_KEY)",

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
            .merging(AdMobInfoPlist.configuration)
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
