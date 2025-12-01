import ProjectDescription

public extension Project {
    static func app(
        _ module: Module = .app,
        infoPlist: InfoPlist? = nil,
        additionalScripts: [TargetScript] = []
    ) -> Project {
        
        let dependencies = ModuleDependencies.dependencies(for: module)
        let scripts = BuildScripts.app + additionalScripts
        
        return Project(
            name: module.rawValue,
            organizationName: Environment.organizationName,
            settings: .settings(
                base: DefaultSettings.base,
                configurations: DefaultSettings.configurations
            ),
            targets: [
                .target(
                    name: module.rawValue,
                    destinations: Environment.deploymentDestination,
                    product: .app,
                    bundleId: Environment.bundlePrefix,
                    deploymentTargets: Environment.deploymentTarget,
                    infoPlist: infoPlist ?? DefaultInfoPlist.app,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    scripts: scripts,
                    dependencies: dependencies
                )
            ],
            schemes: DefaultSchemes.appSchemes(for: module)
        )
    }
}
