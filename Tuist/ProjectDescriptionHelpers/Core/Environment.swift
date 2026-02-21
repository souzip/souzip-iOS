import ProjectDescription

public enum Environment {

    // MARK: - App Information

    public static let appName = "수집"
    public static let bundlePrefix = "com.swyp.souzip"
    public static let organizationName = "Souzip"
    public static let organizationTeamId = "DZAU4TTS8S"

    // MARK: - Version

    public static let appVersion = "1.1.0"
    public static let appBuildVersion = "1"
    public static let swiftVersion = "5.9"

    // MARK: - Platform

    public static let deployment = "16.0"
    public static let deploymentTarget: DeploymentTargets = .iOS(deployment)
    public static let deploymentDestination: Destinations = [.iPhone]

    // MARK: - Configuration Names

    public static let debugConfigName: ConfigurationName = .debug
    public static let releaseConfigName: ConfigurationName = .release

    // MARK: - Build Environments

    public enum BuildEnvironment {
        case debug
        case release

        public var displayName: String {
            switch self {
            case .debug: "\(Environment.appName)-Dev"
            case .release: Environment.appName
            }
        }

        public var bundleId: String {
            switch self {
            case .debug: "\(Environment.bundlePrefix).dev"
            case .release: Environment.bundlePrefix
            }
        }

        public var appIconName: String {
            switch self {
            case .debug: "AppIcon-Dev"
            case .release: "AppIcon"
            }
        }
    }
}
