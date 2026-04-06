import ProjectDescription

public enum ModuleDependencies {
    public static func dependencies(for module: Module) -> [TargetDependency] {
        switch module {
        case .app:
            [
                .module(.presentation),
                .module(.domain),
                .module(.data),
                .module(.designSystem),
                .module(.analytics),
                .module(.storage),
                .module(.networking),
                .module(.utils),
            ]

        case .presentation:
            [
                .module(.domain),
                .module(.logger),
                .module(.analytics),
                .module(.designSystem),
                .module(.utils),
                .module(.ads),

                .external(.rxSwift),
                .external(.rxRelay),
                .external(.rxCocoa),
                .external(.kingfisher),
                .external(.mapboxMaps),
            ]

        case .domain:
            []

        case .data:
            [
                .module(.domain),
                .module(.networking),
                .module(.logger),
                .module(.storage),
                .module(.utils),
                .module(.analytics),

                .external(.kakaoSDKCommon),
                .external(.kakaoSDKAuth),
                .external(.kakaoSDKUser),
                .external(.googleSignIn),
            ]

        case .networking:
            [
                .module(.logger),
            ]

        case .logger:
            []

        case .analytics:
            [
                .external(.amplitudeSwift),
            ]

        case .storage:
            [
                .module(.logger),
                .module(.utils),
            ]

        case .ads:
            [
                .module(.logger),
                .module(.analytics),
                .module(.utils),

                .external(.googleMobileAds),
            ]

        case .designSystem:
            [
                .module(.logger),
                .module(.utils),
                .external(.snapKit),
            ]

        case .utils:
            []
        }
    }
}
