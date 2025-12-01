import ProjectDescription

public enum DefaultSettings {
    
    // MARK: - Base Settings
    
    public static let base: SettingsDictionary = [
        "SWIFT_VERSION": .string(Environment.swiftVersion),
        "DEVELOPMENT_TEAM": .string(Environment.organizationTeamId),
        "CODE_SIGN_STYLE": "Automatic",
        "MARKETING_VERSION": .string(Environment.appVersion),
        "CURRENT_PROJECT_VERSION": .string(Environment.appBuildVersion),
        "IPHONEOS_DEPLOYMENT_TARGET": "16.0"
    ]
    
    // MARK: - Debug Settings
    
    private static let debugSettings: SettingsDictionary = [
        "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
        "GCC_OPTIMIZATION_LEVEL": "0",
        "DEBUG_INFORMATION_FORMAT": "dwarf",
        "ENABLE_TESTABILITY": true,
        "OTHER_SWIFT_FLAGS": "-D DEBUG"
    ]
    
    // MARK: - Release Settings
    
    private static let releaseSettings: SettingsDictionary = [
        "SWIFT_OPTIMIZATION_LEVEL": "-O",
        "SWIFT_COMPILATION_MODE": "wholemodule",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "ENABLE_TESTABILITY": false
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
            settings: base.merging(releaseSettings),
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
