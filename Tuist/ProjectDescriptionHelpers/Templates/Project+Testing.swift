import ProjectDescription

public extension Target {
    static func testTarget(
        for module: Module,
        dependencies: [TargetDependency] = []
    ) -> Target {
        .target(
            name: "\(module.rawValue)Tests",
            destinations: Environment.deploymentDestination,
            product: .unitTests,
            bundleId: "\(Environment.bundlePrefix).\(module.rawValue.lowercased()).tests",
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: DefaultInfoPlist.test,
            sources: ["Tests/**"],
            scripts: BuildScripts.test,
            dependencies: dependencies
        )
    }
}
