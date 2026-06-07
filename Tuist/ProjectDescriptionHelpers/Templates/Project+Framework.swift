import ProjectDescription

public extension Project {
    static func framework(
        _ module: Module,
        hasResources: Bool = false,
        hasTests: Bool = false,
        additionalScripts: [TargetScript] = [],
        additionalBaseSettings: SettingsDictionary = [:]
    ) -> Project {
        let dependencies = ModuleDependencies.dependencies(for: module)
        let resources: ResourceFileElements? = hasResources ? ["Resources/**"] : nil
        let scripts = BuildScripts.framework + additionalScripts
        let baseSettings = DefaultSettings.base.merging(additionalBaseSettings)
        var targets: [Target] = [
            .target(
                name: module.rawValue,
                destinations: Environment.deploymentDestination,
                product: .framework,
                bundleId: "\(Environment.bundlePrefix).\(module.rawValue.lowercased())",
                deploymentTargets: Environment.deploymentTarget,
                infoPlist: DefaultInfoPlist.framework,
                sources: ["Sources/**"],
                resources: resources,
                scripts: scripts,
                dependencies: dependencies,
                settings: additionalBaseSettings.isEmpty
                    ? nil
                    : .settings(
                        base: baseSettings,
                        configurations: DefaultSettings.frameworkConfigurations(
                            merging: additionalBaseSettings
                        )
                    )
            ),
        ]

        if hasTests {
            targets.append(
                .testTarget(
                    for: module,
                    dependencies: [.target(name: module.rawValue)]
                )
            )
        }

        return Project(
            name: module.rawValue,
            organizationName: Environment.organizationName,
            settings: .settings(
                base: baseSettings,
                configurations: DefaultSettings.configurations()
            ),
            targets: targets
        )
    }
}
