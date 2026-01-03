import Domain

enum MyPageAction {
    case viewDidLoad
    case tapSetting
    case tapSegmentTab(CollectionTab)

    case tapCountry(CountryItem)
    case tapSouvenir(SouvenirThumbnailItem)

    case tapCreateSouvenir
}

struct MyPageState {
    var profile: ProfileData?
    var selectedTab: CollectionTab = .collection
    var selectedCountry: String?
    var collectionSouvenirs: [SouvenirThumbnail] = []

    var allCountries: [String] {
        Array(Set(collectionSouvenirs.map(\.country))).sorted()
    }

    var collectionData: MyCollectionData {
        // 국가 필터 아이템
        let countryItems = [
            CountryItem(name: "전체", isSelected: selectedCountry == nil),
        ] + allCountries.map { country in
            CountryItem(name: country, isSelected: country == selectedCountry)
        }

        // 기념품 필터링
        let filteredSouvenirs: [SouvenirThumbnail] = if let selectedCountry {
            collectionSouvenirs.filter { $0.country == selectedCountry }
        } else {
            collectionSouvenirs
        }

        // SouvenirThumbnail -> SouvenirThumbnailItem 변환
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

    var visibleContent: MyPageVisibleContent {
        switch selectedTab {
        case .liked:
            .likedEmpty
        case .collection:
            collectionSouvenirs.isEmpty ? .collectionEmpty : .collection
        }
    }
}

enum MyPageVisibleContent {
    case collection
    case collectionEmpty
    case likedEmpty
}

enum MyPageEvent {
    case showErrorAlert(String)
}
