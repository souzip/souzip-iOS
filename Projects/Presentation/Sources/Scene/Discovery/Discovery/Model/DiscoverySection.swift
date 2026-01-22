import Domain

struct DiscoverySectionModel {
    let section: DiscoverySection
    let items: [DiscoveryItem]
}

enum DiscoverySection: Hashable {
    case top10CountryChips
    case top10Cards
    case banner
    case categoryChips
    case categoryCards
    case categoryMore
    case statisticsChips(date: String)

    case spacer
}

extension DiscoverySection {
    var title: String {
        switch self {
        case .top10CountryChips:
            "한국인이 자주 찾는\n나라별 추천 기념품 TOP 10"
        case .categoryChips:
            "요즘 떠오르는\n카테고리별 기념품 추천"
        case .statisticsChips:
            "수집에서 기념품이\n가장 많이 등록된 나라"
        default: ""
        }
    }

    var subTitle: String {
        switch self {
        case let .statisticsChips(date):
            "\(date) 등록 기념품 수 기준"
        default: ""
        }
    }
}
