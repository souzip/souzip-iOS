import ProjectDescription

public enum ModuleDependencies {
    public static func dependencies(for module: Module) -> [TargetDependency] {
        switch module {
        case .app:
            return [
                .module(.presentation),
                .module(.domain),
                .module(.data),
                .module(.networking),
                .module(.logger),
                .module(.keychain),
                .module(.utils),
            ]
            
        case .presentation:
            return [
                .module(.domain),
                .module(.logger),
                .module(.designSystem),
                .module(.utils),

                .external(.rxSwift),
                .external(.rxRelay),
                .external(.rxCocoa),
                .external(.kingfisher),
                .external(.swiftSVG),
                .external(.mapboxMaps)
            ]
            
        case .domain:
            return [
                .module(.utils),
                .module(.logger)
            ]
            
        case .data:
            return [
                .module(.domain),
                .module(.networking),
                .module(.logger),
                .module(.keychain),
                .module(.userDefaults),
                .module(.utils),

                .external(.kakaoSDKCommon),
                .external(.kakaoSDKAuth),
                .external(.kakaoSDKUser),
                .external(.googleSignIn),
            ]
            
        case .networking:
            return [
                .module(.logger)
            ]

        case .logger:
            return []

        case .keychain:
            return [
                .module(.logger),
                .module(.utils)
            ]

        case .userDefaults:
            return [
                .module(.logger),
                .module(.utils)
            ]

        case .designSystem:
            return [
                .module(.logger),
                .module(.utils),
                .external(.snapKit)
            ]
            
        case .utils:
            return []
        }
    }
}
