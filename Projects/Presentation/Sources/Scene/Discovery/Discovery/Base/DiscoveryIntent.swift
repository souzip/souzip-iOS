import Domain
import Foundation

enum DiscoveryAction {
    case viewDidLoad

    case countryChipTap(CountryChipItem)
    case categoryChipTap(CategoryItem)
    case souvenirCardTap(SouvenirCardItem)
    case moreButtonTap

    case tapFAB
}

struct DiscoveryState {
    var countries: [CountryChipItem] = []
    var countrySouvenirs: [SouvenirCardItem] = []
    var categories: [CategoryItem] = []
    var categorySouvenirs: [SouvenirCardItem] = []

    var isCategoryExpanded: Bool = false
    var statCountry: [StatCountryChipItem] = []

    var sectionModels: [DiscoverySectionModel] {
        var models: [DiscoverySectionModel] = []

        if !countries.isEmpty {
            models.append(.init(
                section: .top10CountryChips,
                items: countries.map { .countryChip($0) }
            ))
        }

        if !countrySouvenirs.isEmpty {
            models.append(.init(
                section: .top10Cards,
                items: countrySouvenirs.map { .souvenirCard($0) }
            ))
        }

        if !categories.isEmpty {
            models.append(.init(
                section: .categoryChips,
                items: categories.map { .categoryChip($0) }
            ))
        }

        if !categorySouvenirs.isEmpty {
            let visible = isCategoryExpanded
                ? categorySouvenirs
                : Array(categorySouvenirs.prefix(4))

            models.append(.init(
                section: .categoryCards,
                items: visible.map { .souvenirCard($0) }
            ))

            if !isCategoryExpanded, categorySouvenirs.count > 4 {
                models.append(.init(
                    section: .categoryMore,
                    items: [.moreButton("더보기")]
                ))
            }
        }

        models.append(
            DiscoverySectionModel(
                section: .spacer,
                items: [.spacer]
            )
        )

        if !statCountry.isEmpty {
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date) % 100
            let month = calendar.component(.month, from: date)

            let dateText = "\(year)년 \(month)월"

            models.append(.init(
                section: .statisticsChips(date: dateText),
                items: [.statCountryChip(statCountry)]
            ))
        }

        return models
    }
}

enum DiscoveryEvent {
    case showErrorAlert(_ message: String)
}
