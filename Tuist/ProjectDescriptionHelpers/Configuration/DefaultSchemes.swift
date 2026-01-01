import ProjectDescription

public enum DefaultSchemes {
    
    public static func appSchemes(for module: Module) -> [Scheme] {
        [
            createScheme(
                name: "\(Environment.appName)-Debug",
                configuration: Environment.debugConfigName,
                module: module
            ),
            createScheme(
                name: "\(Environment.appName)",
                configuration: Environment.releaseConfigName,
                module: module
            )
        ]
    }
    
    private static func createScheme(
        name: String,
        configuration: ConfigurationName,
        module: Module
    ) -> Scheme {
        .scheme(
            name: name,
            buildAction: .buildAction(
                targets: [.target(module.rawValue)]
            ),
            testAction: .testPlans([]),
            runAction: .runAction(configuration: configuration),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }
}
