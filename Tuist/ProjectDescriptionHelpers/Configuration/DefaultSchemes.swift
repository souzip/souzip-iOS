import ProjectDescription

public enum DefaultSchemes {
    /// App.xcodeproj — 앱 실행(⌘R). Xcode 스킴 목록에 항상 표시된다.
    public static func appSchemes(for module: Module) -> [Scheme] {
        [
            createAppRunScheme(
                name: "\(Environment.appName)-Debug",
                configuration: Environment.debugConfigName,
                module: module
            ),
            createAppRunScheme(
                name: Environment.appName,
                configuration: Environment.releaseConfigName,
                module: module
            ),
        ]
    }

    /// Souzip.xcworkspace — 모듈 단위 테스트(⌘U). App 스킴과 **이름을 겹치지 않음**.
    public static func workspaceTestScheme() -> [Scheme] {
        [
            createWorkspaceTestScheme(
                name: "\(Environment.appName)-Tests",
                configuration: Environment.debugConfigName
            ),
        ]
    }

    // MARK: - App (Run only)

    private static func createAppRunScheme(
        name: String,
        configuration: ConfigurationName,
        module: Module
    ) -> Scheme {
        .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(
                targets: [.target(module.rawValue)]
            ),
            runAction: .runAction(configuration: configuration),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }

    // MARK: - Workspace (cross-project tests)

    private static func createWorkspaceTestScheme(
        name: String,
        configuration: ConfigurationName
    ) -> Scheme {
        let appTarget: TargetReference = .project(path: Module.app.path, target: Module.app.rawValue)

        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: [appTarget]),
            testAction: .targets(
                Module.modulesWithUnitTests.map {
                    .testableTarget(
                        target: .project(path: $0.path, target: $0.unitTestsTargetName)
                    )
                },
                configuration: configuration
            ),
            runAction: .runAction(
                configuration: configuration,
                executable: appTarget
            ),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }
}
