import ProjectDescription

public enum ExternalLibrary: String, CaseIterable {
    // MARK: - Reactive
    
    case rxSwift = "RxSwift"
    case rxRelay = "RxRelay"
    case rxCocoa = "RxCocoa"

    // MARK: - UI
    
    case snapKit = "SnapKit"
    
    // MARK: - Utility
    
    case kingfisher = "Kingfisher"

    // MARK: - Kakao SDK

    case kakaoSDKCommon = "KakaoSDKCommon"
    case kakaoSDKAuth = "KakaoSDKAuth"
    case kakaoSDKUser = "KakaoSDKUser"
//
//    // MARK: - Google Sign In
//
//    case googleSignIn = "GoogleSignIn"
}

public extension ExternalLibrary {
    // MARK: - Product Type Configuration

    var productType: Product {
        switch self {
        default: .staticFramework
        }
    }
    
    // MARK: - Package Settings

    static var packageSettings: PackageSettings {
        let productTypes = Dictionary(
            uniqueKeysWithValues: ExternalLibrary.allCases.map {
                ($0.rawValue, $0.productType)
            }
        )
        
        return PackageSettings(
            productTypes: productTypes,
            baseSettings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deployment),
                    "SWIFT_VERSION": .string(Environment.swiftVersion),
                ],
                configurations: [
                    .debug(name: .configuration("Debug")),
                    .release(name: .configuration("Staging")),
                    .release(name: .configuration("Release"))
                ]
            )
        )
    }
}
