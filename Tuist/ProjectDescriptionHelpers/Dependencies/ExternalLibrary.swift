import ProjectDescription

public enum ExternalLibrary: String, CaseIterable {
    // MARK: - Reactive

    case rxSwift = "RxSwift"
    case rxRelay = "RxRelay"
    case rxCocoa = "RxCocoa"

    // MARK: - UI

    case snapKit = "SnapKit"
    case parchment = "Parchment"

    // MARK: - Utility

    case kingfisher = "Kingfisher"

    // MARK: - Kakao SDK

    case kakaoSDKCommon = "KakaoSDKCommon"
    case kakaoSDKAuth = "KakaoSDKAuth"
    case kakaoSDKUser = "KakaoSDKUser"

    // MARK: - MapBox

    case mapboxMaps = "MapboxMaps"

    // MARK: - Google Sign In

    case googleSignIn = "GoogleSignIn"

    // MARK: - Analytics

    case amplitudeSwift = "AmplitudeSwift"

    // MARK: - Google Mobile Ads

    case googleMobileAds = "GoogleMobileAds"

    // MARK: - Firebase

    case firebaseCore = "FirebaseCore"
    case firebaseMessaging = "FirebaseMessaging"
}

public extension ExternalLibrary {
    // MARK: - Product Type Configuration

    private static let sharedGoogleProductTypes: [String: Product] = [
        "FBLPromises": .framework,
        "GoogleUtilities-AppDelegateSwizzler": .framework,
        "GoogleUtilities-Environment": .framework,
        "GoogleUtilities-Logger": .framework,
        "GoogleUtilities-Network": .framework,
        "GoogleUtilities-NSData": .framework,
        "GoogleUtilities-Reachability": .framework,
        "GoogleUtilities-UserDefaults": .framework,
        "third-party-IsAppEncrypted": .framework,
    ]

    var productType: Product {
        switch self {
        case .mapboxMaps: .framework
        case .amplitudeSwift, .googleMobileAds: .framework
        default: .staticFramework
        }
    }

    // MARK: - Package Settings

    static var packageSettings: PackageSettings {
        let externalProductTypes = Dictionary(
            uniqueKeysWithValues: ExternalLibrary.allCases.map {
                ($0.rawValue, $0.productType)
            }
        )
        let productTypes = externalProductTypes.merging(sharedGoogleProductTypes) { _, new in
            new
        }

        return PackageSettings(
            productTypes: productTypes,
            baseSettings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deployment),
                    "SWIFT_VERSION": .string(Environment.swiftVersion),
                ],
                configurations: [
                    .debug(name: .configuration("Debug")),
                    .release(name: .configuration("Release")),
                ]
            )
        )
    }
}
