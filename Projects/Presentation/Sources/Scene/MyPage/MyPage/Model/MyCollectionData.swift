import Foundation

struct MyCollectionData: Hashable {
    let countryFilter: CountryFilterSection
    let souvenirGrid: SouvenirGridSection
}

// MARK: - MyCollection Section

enum MyCollectionSection: Int, CaseIterable {
    case countryFilter
    case souvenirGrid
}

// MARK: - MyCollection Item

enum MyCollectionItem: Hashable {
    case country(CountryItem)
    case souvenir(SouvenirThumbnailItem)
}

// MARK: - Country

struct CountryItem: Hashable {
    let name: String
    let isSelected: Bool
}

struct CountryFilterSection: Hashable {
    let countries: [CountryItem]
}

// MARK: - Souvenir

struct SouvenirThumbnailItem: Hashable {
    let id: Int
    let thumbnailUrl: String
}

struct SouvenirGridSection: Hashable {
    let souvenirs: [SouvenirThumbnailItem]
}
