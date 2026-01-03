import Domain

// MARK: - Discovery Domain Models

/// 발견 화면 섹션
enum DiscoverySection: Int, CaseIterable {
    case top10CountryChips
    case top10Cards
    case banner
    case categoryChips
    case categoryCards
    case categoryMore
    case statisticsChips
}

/// 발견 화면 아이템
enum DiscoveryItem: Hashable {
    case countryChip(CountryChipItem)
    case souvenirCard(SouvenirCardItem)
    case banner(BannerItem)
    case categoryChip(CategoryChipItem)
    case moreButton(String)
    case statCountryChip([StatCountryChipItem])
}

/// 국가 칩 아이템
struct CountryChipItem: Hashable {
    let id: String
    let title: String
    let flagImage: String // 국기 이미지
    let isSelected: Bool
}

/// 기념품 카드 아이템
struct SouvenirCardItem: Hashable {
    let id: Int
    let imageURL: String?
    let title: String
    let category: String
}

/// 배너 아이템
struct BannerItem: Hashable {
    let id: String
    let imageURL: String?
}

/// 카테고리 칩 아이템
struct CategoryChipItem: Hashable {
    let category: SouvenirCategory
    let isSelected: Bool
}

/// 섹션 헤더 아이템
struct SectionHeaderItem: Hashable {
    let id: String
    let title: String
    let subtitle: String?
}

/// 통계 국가 칩 아이템 (크기가 다른 칩)
struct StatCountryChipItem: Hashable {
    let id: String
    let country: String
    let flagImage: String
    let count: String
    let rank: Int
}

struct Top10Section {
    let header: SectionHeaderItem
    let countryChips: [CountryChipItem]
    let souvenirCards: [SouvenirCardItem]
}

struct BannerSection {
    let banner: BannerItem
}

struct CategorySection {
    let header: SectionHeaderItem
    let categoryChips: [CategoryChipItem]
    let souvenirCards: [SouvenirCardItem]
    let moreButtonTitle: String
}

struct StatisticsSection {
    let header: SectionHeaderItem
    let countryChips: [StatCountryChipItem]
}
