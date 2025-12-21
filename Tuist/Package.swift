// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers
    
    let packageSettings = ExternalLibrary.packageSettings
#endif

let package = Package(
    name: "Souzip",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.26.0"),
//        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "9.0.0")
    ]
)
