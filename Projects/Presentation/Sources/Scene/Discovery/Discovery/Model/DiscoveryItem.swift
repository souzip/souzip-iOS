import UIKit

enum DiscoveryItem: Hashable {
    case countryChip(CountryChipItem)
    case souvenirCard(SouvenirFeedCardItem)
    case banner
    case categoryChip(CategoryItem)
    case moreButton(String)
    case statCountryChip([StatCountryChipItem])

    case empty(id: String, text: String)
    case spacer
}

/// 국가 칩 아이템
struct CountryChipItem: Hashable {
    let countryCode: String
    let title: String
    let flagImage: String
    let isSelected: Bool
}

/// 통계 국가 칩 아이템
struct StatCountryChipItem: Hashable {
    let flagImage: String
    let title: String
    let count: String
    let rank: Int
}
