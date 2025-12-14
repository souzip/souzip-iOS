import ProjectDescription

public enum DefaultSettings {

    // MARK: - Base Settings

    public static let base: SettingsDictionary = [
        // Language / Platform
        "SWIFT_VERSION": .string(Environment.swiftVersion),
        "IPHONEOS_DEPLOYMENT_TARGET": "16.0",

        // Versioning
        "MARKETING_VERSION": .string(Environment.appVersion),
        "CURRENT_PROJECT_VERSION": .string(Environment.appBuildVersion),

        // Signing / Product
        "DEVELOPMENT_TEAM": .string(Environment.organizationTeamId),
        "CODE_SIGN_STYLE": "Automatic",
        "PRODUCT_NAME": .string(Environment.appName),

        // Module Verifier
        "ENABLE_MODULE_VERIFIER": "YES",
        "CLANG_ENABLE_MODULE_VERIFIER": "YES",
//        "CLANG_MODULE_VERIFIER_SUPPORTED_LANGUAGES": "objective-c++",

        // Resource Symbol Generation
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
        "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
        "ENABLE_STRINGSDICT_CODE_GENERATION": "YES",

        // Optimization
        "DEAD_CODE_STRIPPING": "YES",

        // Scripts
        "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
    ]


    // MARK: - Debug Settings

    private static let debugSettings: SettingsDictionary = [
        // 컴파일 최적화
        "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
        "GCC_OPTIMIZATION_LEVEL": "0",
        "DEBUG_INFORMATION_FORMAT": "dwarf",
        "ENABLE_TESTABILITY": "YES",
        "OTHER_SWIFT_FLAGS": "-D DEBUG",

        "PRODUCT_BUNDLE_IDENTIFIER": .string(Environment.BuildEnvironment.debug.bundleId),
        "APP_DISPLAY_NAME": .string(Environment.BuildEnvironment.debug.displayName),
        "ASSETCATALOG_COMPILER_APPICON_NAME": .string(Environment.BuildEnvironment.debug.appIconName)
    ]

    // MARK: - Staging Settings

    private static let stagingSettings: SettingsDictionary = [
        // 컴파일 최적
        "SWIFT_OPTIMIZATION_LEVEL": "-O",
        "SWIFT_COMPILATION_MODE": "wholemodule",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "ENABLE_TESTABILITY": "NO",

        // 환경별 설정 - Bundle ID, 앱 이름, 아이콘
        "PRODUCT_BUNDLE_IDENTIFIER": .string(Environment.BuildEnvironment.staging.bundleId),
        "APP_DISPLAY_NAME": .string(Environment.BuildEnvironment.staging.displayName),
        "ASSETCATALOG_COMPILER_APPICON_NAME": .string(Environment.BuildEnvironment.staging.appIconName)
    ]

    // MARK: - Release Settings

    private static let releaseSettings: SettingsDictionary = [
        // 컴파일 최적화
        "SWIFT_OPTIMIZATION_LEVEL": "-O",
        "SWIFT_COMPILATION_MODE": "wholemodule",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "ENABLE_TESTABILITY": "NO",

        // 환경별 설정 - Bundle ID, 앱 이름, 아이콘
        "PRODUCT_BUNDLE_IDENTIFIER": .string(Environment.BuildEnvironment.release.bundleId),
        "APP_DISPLAY_NAME": .string(Environment.BuildEnvironment.release.displayName),
        "ASSETCATALOG_COMPILER_APPICON_NAME": .string(Environment.BuildEnvironment.release.appIconName)
    ]

    // MARK: - Configurations

    public static let configurations: [Configuration] = [
        .debug(
            name: Environment.debugConfigName,
            settings: base.merging(debugSettings),
            xcconfig: .relativeToRoot("Config/Debug.xcconfig")
        ),
        .release(
            name: Environment.stagingConfigName,
            settings: base.merging(stagingSettings),
            xcconfig: .relativeToRoot("Config/Staging.xcconfig")
        ),
        .release(
            name: Environment.releaseConfigName,
            settings: base.merging(releaseSettings),
            xcconfig: .relativeToRoot("Config/Release.xcconfig")
        )
    ]
}

// MARK: - Extensions

private extension SettingsDictionary {
    func merging(_ other: SettingsDictionary) -> SettingsDictionary {
        self.merging(other) { _, new in new }
    }
}
