import Domain

enum MyPageCollectionTabAction {
    case tapCountry(CountryItem)
    case tapSouvenir(SouvenirThumbnailItem)
    case tapCreateSouvenir
}

struct MyPageCollectionTabState: Equatable {
    var selectedCountry: String?
    var collectionSouvenirs: [SouvenirThumbnail] = []

    var allCountries: [String] {
        Array(Set(collectionSouvenirs.map(\.country))).sorted()
    }

    var collectionData: MyCollectionData {
        let countryItems = [
            CountryItem(name: "전체", isSelected: selectedCountry == nil),
        ] + allCountries.map { country in
            CountryItem(name: country, isSelected: selectedCountry == country)
        }

        let filteredSouvenirs: [SouvenirThumbnail] = if let selectedCountry {
            collectionSouvenirs.filter { $0.country == selectedCountry }
        } else {
            collectionSouvenirs
        }

        let souvenirItems = filteredSouvenirs.map { souvenir in
            SouvenirThumbnailItem(
                id: souvenir.id,
                thumbnailUrl: souvenir.thumbnailUrl
            )
        }

        return MyCollectionData(
            countryFilter: CountryFilterSection(countries: countryItems),
            souvenirGrid: SouvenirGridSection(souvenirs: souvenirItems)
        )
    }
}

enum MyPageCollectionTabEvent: Equatable {
    case unused
}
