import ProjectDescription

public enum DefaultSettings {

    // MARK: - Base Settings

    public static let base: SettingsDictionary = [
        // Language / Platform
        "SWIFT_VERSION": .string(Environment.swiftVersion),
        "IPHONEOS_DEPLOYMENT_TARGET": "16.0",

        "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
        "EMBEDDED_CONTENT_CONTAINS_SWIFT": "YES",
        "OTHER_LDFLAGS": "$(inherited) -ObjC",

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
        "CLANG_MODULE_VERIFIER_SUPPORTED_LANGUAGES": "objective-c objective-c++",

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
        "OTHER_SWIFT_FLAGS": "-D DEBUG"
    ]

    // MARK: - Release Settings

    private static let releaseSettings: SettingsDictionary = [
        // 컴파일 최적화
        "SWIFT_OPTIMIZATION_LEVEL": "-O",
        "SWIFT_COMPILATION_MODE": "wholemodule",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "ENABLE_TESTABILITY": "NO"
    ]

    // MARK: - App Specific Settings

    private static func appSettings(for environment: Environment.BuildEnvironment) -> SettingsDictionary {
        return [
            "PRODUCT_BUNDLE_IDENTIFIER": .string(environment.bundleId),
            "APP_DISPLAY_NAME": .string(environment.displayName),
            "ASSETCATALOG_COMPILER_APPICON_NAME": .string(environment.appIconName)
        ]
    }

    // MARK: - Configurations

    public static func configurations(isApp: Bool = false) -> [Configuration] {
        var debug = base.merging(debugSettings)
        var release = base.merging(releaseSettings)

        if isApp {
            debug = debug.merging(appSettings(for: .debug))
            release = release.merging(appSettings(for: .release))
        }

        return [
            .debug(
                name: Environment.debugConfigName,
                settings: debug,
                xcconfig: .relativeToRoot("Config/Debug.xcconfig")
            ),
            .release(
                name: Environment.releaseConfigName,
                settings: release,
                xcconfig: .relativeToRoot("Config/Release.xcconfig")
            )
        ]
    }

    public static func targetConfigurations() -> [Configuration] {
        let debugAppSettings = appSettings(for: .debug)
        let releaseAppSettings = appSettings(for: .release)

        return [
            .debug(
                name: Environment.debugConfigName,
                settings: debugAppSettings
            ),
            .release(
                name: Environment.releaseConfigName,
                settings: releaseAppSettings
            )
        ]
    }
}

// MARK: - Extensions

private extension SettingsDictionary {
    func merging(_ other: SettingsDictionary) -> SettingsDictionary {
        self.merging(other) { _, new in new }
    }
}
