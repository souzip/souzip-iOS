import ProjectDescription

public enum Environment {

    // MARK: - App Information

    public static let appName = "Souzip"
    public static let bundlePrefix = "com.swyp.souzip"
    public static let organizationName = "SWYP"
    public static let organizationTeamId = "3PVV8DQPL6"

    // MARK: - Version

    public static let appVersion = "1.0.0"
    public static let appBuildVersion = "1"
    public static let swiftVersion = "5.9"

    // MARK: - Platform

    public static let deploymentTarget: DeploymentTargets = .iOS("16.0")
    public static let deploymentDestination: Destinations = [.iPhone]

    // MARK: - Configuration Names

    public static let debugConfigName: ConfigurationName = .debug
    public static let stagingConfigName: ConfigurationName = .configuration("Staging")
    public static let releaseConfigName: ConfigurationName = .release

    // MARK: - Build Environments

    public enum BuildEnvironment {
        case debug
        case staging
        case release

        public var displayName: String {
            switch self {
            case .debug: "\(Environment.appName)-Dev"
            case .staging: "\(Environment.appName)-Staging"
            case .release: Environment.appName
            }
        }

        public var bundleId: String {
            switch self {
            case .debug: "\(Environment.bundlePrefix).dev"
            case .staging: "\(Environment.bundlePrefix).staging"
            case .release: Environment.bundlePrefix
            }
        }

        public var appIconName: String {
            switch self {
            case .debug: "AppIcon-Dev"
            case .staging: "AppIcon-Staging"
            case .release: "AppIcon"
            }
        }
    }
}
