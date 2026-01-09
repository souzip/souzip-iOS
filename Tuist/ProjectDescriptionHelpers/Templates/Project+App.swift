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
                configurations: DefaultSettings.configurations(isApp: true)
            ),
            targets: [
                .target(
                    name: module.rawValue,
                    destinations: Environment.deploymentDestination,
                    product: .app,
                    bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
                    deploymentTargets: Environment.deploymentTarget,
                    infoPlist: infoPlist ?? DefaultInfoPlist.app,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    entitlements: .file(path: .relativeToRoot("Projects/App/App.entitlements")),
                    scripts: scripts,
                    dependencies: dependencies,
                    settings: .settings(
                        configurations: DefaultSettings.targetConfigurations()
                    )
                )
            ],
            schemes: DefaultSchemes.appSchemes(for: module)
        )
    }
}
