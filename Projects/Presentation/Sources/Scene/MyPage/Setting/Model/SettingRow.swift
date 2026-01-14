import Foundation

enum SettingRow: Hashable {
    case title(String)
    case item(SettingItem)
    case spacer(CGFloat)
}

struct SettingItem: Hashable {
    let type: SettingItemType
    let title: String
    let trailingText: String?
    let showsChevron: Bool
}

enum SettingItemType: Hashable {
    case termsOfService
    case privacyPolicy
    case locationTerms
    case marketingConsentInfo

    case appVersion

    case notice
    case faq
    case feedback

    case logout
    case withdraw
}

extension SettingItemType {
    var url: String {
        switch self {
        case .termsOfService: "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f5801885cfc72d69e16a34"
        case .privacyPolicy: "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f5802499befa952e59529e"
        case .locationTerms: "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f580db899bcb4bd78c8012"
        case .marketingConsentInfo: "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f580cdbe77dce440e8e85f"
        case .notice: "https://noiseless-hornet-d9e.notion.site/2e2d4699d3f58000a30bd96d614229a3?v=2e2d4699d3f58083bd95000cda957c2c&source=copy_link"
        case .feedback:
            "https://docs.google.com/forms/d/e/1FAIpQLSe9uOrj9bjyrqtMWKCWcXduYgmrmTqKyGt94YwPKiAMvjqj2w/viewform"
        case .faq: "https://noiseless-hornet-d9e.notion.site/2e2d4699d3f580f5b18dfe8c222cd9a1?v=2e2d4699d3f5809e9b88000ccf9654d8&source=copy_link"
        default: ""
        }
    }
}
