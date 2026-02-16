import ProjectDescription

public enum ModuleDependencies {
    public static func dependencies(for module: Module) -> [TargetDependency] {
        switch module {
        case .app:
            return [
                .module(.presentation),
                .module(.domain),
                .module(.data),
            ]
            
        case .presentation:
            return [
                .module(.domain),
                .module(.logger),
                .module(.designSystem),
                .module(.utils),
                .module(.adMob),

                .external(.rxSwift),
                .external(.rxRelay),
                .external(.rxCocoa),
                .external(.kingfisher),
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
            return [
                .external(.amplitudeSwift)
            ]

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
            
        case .adMob:
            return [
                .module(.logger),
                .module(.utils),
                
                .external(.googleMobileAds)
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
