enum DiscoveryAction {
    case countryChipTap(CountryChipItem)
    case categoryChipTap(CategoryChipItem)
    case souvenirCardTap(SouvenirCardItem)
    case moreButtonTap

    case tapFAB
}

struct DiscoveryState {
    var data: DiscoveryData?
    var selectedCountryId: String?
    var selectedCategoryId: String?
    var isCategoryExpanded: Bool = false
    var fullCategoryCards: [SouvenirCardItem] = []
}

enum DiscoveryEvent {
    case showToast(message: String)
}

extension DiscoveryData {
    static var mock: Self {
        .init(
            top10: .init(
                header: .init(
                    id: "top10-header",
                    title: "한국인이 저주찾는\n나라별 추천 기념품 Top 10",
                    subtitle: nil
                ),
                countryChips: [
                    .init(id: "us", title: "미국", flagImage: "https://picsum.photos/seed/banner1/800/400", isSelected: true),
                    .init(id: "jp", title: "일본", flagImage: "https://picsum.photos/seed/banner1/800/400", isSelected: false),
                    .init(id: "uk", title: "영국", flagImage: "https://picsum.photos/seed/banner1/800/400", isSelected: false),
                    .init(id: "vn", title: "베트남", flagImage: "https://picsum.photos/seed/banner1/800/400", isSelected: false),
                ],
                souvenirCards: [
                    .init(id: "1", imageURL: "https://picsum.photos/seed/souvenir1/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                    .init(id: "2", imageURL: "https://picsum.photos/seed/souvenir2/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                    .init(id: "3", imageURL: "https://picsum.photos/seed/souvenir3/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                    .init(id: "4", imageURL: "https://picsum.photos/seed/souvenir4/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                ]
            ),
            banner: .init(
                banner: .init(id: "banner-1", imageURL: "https://picsum.photos/seed/banner1/800/400")
            ),
            category: .init(
                header: .init(
                    id: "category-header",
                    title: "요즘 떠오르는\n카테고리별 기념품 추천",
                    subtitle: nil
                ),
                categoryChips: [
                    .init(category: .art, isSelected: true),
                    .init(category: .culture, isSelected: false),
                    .init(category: .fashion, isSelected: false),
                ],
                souvenirCards: [
                    .init(id: "5", imageURL: "https://picsum.photos/seed/souvenir5/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                    .init(id: "6", imageURL: "https://picsum.photos/seed/souvenir6/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                    .init(id: "7", imageURL: "https://picsum.photos/seed/souvenir7/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                    .init(id: "8", imageURL: "https://picsum.photos/seed/souvenir8/400/400", title: "기념품명기념품명기념...", category: "카테고리"),
                ],
                moreButtonTitle: "더보기"
            ),
            statistics: .init(
                header: .init(
                    id: "statistics-header",
                    title: "수집에서 기념품이\n가장 많이 등록된 나라는?",
                    subtitle: "2025년 12월 기준 수집 기념품 수 기준"
                ),
                countryChips: [
                    .init(id: "stat-jp", country: "미국 · 뉴욕", flagImage: "https://picsum.photos/seed/souvenir8/400/400", count: "262", rank: 1),
                    .init(id: "stat-uk", country: "미국 · 뉴욕", flagImage: "https://picsum.photos/seed/souvenir8/400/400", count: "78", rank: 2),
                    .init(id: "stat-vn", country: "미국 · 뉴욕", flagImage: "https://picsum.photos/seed/souvenir8/400/400", count: "78", rank: 3),
                ]
            )
        )
    }
}
