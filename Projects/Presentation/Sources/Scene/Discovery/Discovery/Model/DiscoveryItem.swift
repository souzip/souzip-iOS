import UIKit

enum DiscoveryItem: Hashable {
    case countryChip(CountryChipItem)
    case souvenirCard(SouvenirCardItem)
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

/// 기념품 카드 아이템
struct SouvenirCardItem: Hashable {
    let id: Int
    let imageURL: String
    let title: String
    let category: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// 통계 국가 칩 아이템
struct StatCountryChipItem: Hashable {
    let flagImage: String
    let title: String
    let count: String
    let rank: Int
}
