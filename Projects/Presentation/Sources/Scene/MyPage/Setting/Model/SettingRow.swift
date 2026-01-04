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

    case feedback

    case logout
    case withdraw
}

extension SettingItemType {
    var url: String {
        switch self {
        case .termsOfService: "https://www.souzip.com/terms"
        case .privacyPolicy: "https://www.souzip.com/privacy"
        case .locationTerms: "https://www.souzip.com/location-terms"
        case .marketingConsentInfo: "https://www.souzip.com/marketing-terms"
        case .feedback:
            "https://docs.google.com/forms/d/e/1FAIpQLSe9uOrj9bjyrqtMWKCWcXduYgmrmTqKyGt94YwPKiAMvjqj2w/viewform"
        default: ""
        }
    }
}
