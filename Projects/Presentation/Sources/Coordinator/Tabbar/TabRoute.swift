import DesignSystem
import UIKit

public enum TabRoute: Int, CaseIterable {
    case discovery
    case home
    case myPage

    case login

    public var item: DSTabBarItem? {
        switch self {
        case .discovery:
            .init(
                title: "발견",
                image: .dsIconGift,
                selectedImage: .dsIconGift.withTintColor(.dsMain)
            )
        case .home:
            .init(
                title: "지도",
                image: .dsIconGlobe,
                selectedImage: .dsIconGlobe.withTintColor(.dsMain)
            )
        case .myPage:
            .init(
                title: "마이",
                image: .dsIconUserProfile,
                selectedImage: .dsIconUserProfile.withTintColor(.dsMain)
            )
        default: nil
        }
    }

    public static var items: [DSTabBarItem] { allCases.compactMap(\.item) }
}
