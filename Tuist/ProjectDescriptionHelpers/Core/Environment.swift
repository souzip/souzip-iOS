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
}
