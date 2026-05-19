import Domain
import Foundation

enum DiscoveryAction {
    case viewDidLoad
    case refresh

    case countryChipTap(CountryChipItem)
    case categoryChipTap(CategoryItem)
    case souvenirCardTap(SouvenirFeedCardItem)
    case moreButtonTap

    case tapFAB
}

struct DiscoveryState {
    var isGuest: Bool = true

    var countryTopSouvenirs: [String: CountryTopSouvenir] = [:]

    var countries: [CountryChipItem] = []
    var countrySouvenirs: [SouvenirFeedCardItem] = []
    var categories: [CategoryItem] = []
    var categorySouvenirs: [SouvenirFeedCardItem] = []

    var isCategoryExpanded: Bool = false
    var statCountry: [StatCountryChipItem] = []

    var sectionModels: [DiscoverySectionModel] {
        var models: [DiscoverySectionModel] = []

        // 1) 나라 칩
        if !countries.isEmpty {
            models.append(.init(
                section: .top10CountryChips,
                items: countries.map { .countryChip($0) }
            ))
        }

        // 2) 나라별 Top10 카드
        if !countries.isEmpty {
            let items: [DiscoveryItem] = countrySouvenirs.isEmpty
                ? [.empty(id: "top10Cards-empty", text: "비어있습니다")]
                : countrySouvenirs.map {
                    .souvenirCard($0.withListSlotID(SouvenirFeedCardListSlot.discoveryCountry.rawValue))
                }

            models.append(.init(
                section: .top10Cards,
                items: items
            ))
        }

        if !countries.isEmpty {
            models.append(.init(
                section: .banner,
                items: [.banner]
            ))
        }

        // 3) 카테고리 칩
        if !categories.isEmpty {
            models.append(.init(
                section: .categoryChips,
                items: categories.map { .categoryChip($0) }
            ))
        }

        // 4) 카테고리 카드/엠티/더보기
        if !categories.isEmpty {
            if categorySouvenirs.isEmpty {
                models.append(.init(
                    section: .categoryCards,
                    items: [.empty(id: "categoryCards-empty", text: "비어있습니다")]
                ))
            } else {
                let visible = isCategoryExpanded
                    ? categorySouvenirs
                    : Array(categorySouvenirs.prefix(4))

                models.append(.init(
                    section: .categoryCards,
                    items: visible.map {
                        .souvenirCard($0.withListSlotID(SouvenirFeedCardListSlot.discoveryCategory.rawValue))
                    }
                ))

                if !isCategoryExpanded, categorySouvenirs.count > 4 {
                    models.append(.init(
                        section: .categoryMore,
                        items: [.moreButton("더보기")]
                    ))
                }
            }
        }

        // spacer
        models.append(.init(section: .spacer, items: [.spacer]))

        // stats
        if !statCountry.isEmpty {
            models.append(.init(
                section: .statisticsChips,
                items: [.statCountryChip(statCountry)]
            ))
        }

        return models
    }
}

enum DiscoveryEvent {
    case loading(Bool)
    case showErrorAlert(_ message: String)
    case endRefreshing
}
