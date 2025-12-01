// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "SnapKit": .framework,
            "Kingfisher": .framework
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .configuration("Debug")),
                .release(name: .configuration("Staging")),
                .release(name: .configuration("Release"))
            ]
        )
    )
#endif

let package = Package(
    name: "Souzip",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ]
)
