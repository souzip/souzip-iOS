import Domain

struct RecommendSectionModel {
    var section: RecommendSection
    var items: [RecommendItem]
}

// MARK: - Section

enum RecommendSection: Hashable {
    case preferredCategoryChips
    case preferredCategoryCards
    case preferredMore

    case uploadBasedCards(country: String)
    case uploadMore(country: String)
    case uploadEmpty

    case spacer
}

extension RecommendSection {
    var title: String {
        switch self {
        case .preferredCategoryChips:
            "선호 카테고리 기반 기념품 새로운 소식"
        case let .uploadBasedCards(country):
            "최근 \(country) 기념품을 업로드 하셨네요\n이와 비슷한 기념품을 추천해드릴게요"
        default:
            ""
        }
    }
}

// MARK: - Item

enum RecommendItem: Hashable {
    case countryChip(CountryChipItem)
    case souvenirCard(SouvenirCardItem)
    case moreButton(String)
    case uploadPrompt
    case spacer

    case empty(id: String, text: String)
}
