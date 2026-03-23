import ProjectDescription

public enum ModuleDependencies {
    public static func dependencies(for module: Module) -> [TargetDependency] {
        switch module {
        case .app:
            return [
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
            return [
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
            return []

        case .data:
            return [
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
            return [
                .module(.logger),
            ]

        case .logger:
            return []

        case .analytics:
            return [
                .external(.amplitudeSwift),
            ]

        case .storage:
            return [
                .module(.logger),
                .module(.utils),
            ]

        case .ads:
            return [
                .module(.logger),
                .module(.analytics),
                .module(.utils),

                .external(.googleMobileAds),
            ]

        case .designSystem:
            return [
                .module(.logger),
                .module(.utils),
                .external(.snapKit),
            ]

        case .utils:
            return []
        }
    }
}
