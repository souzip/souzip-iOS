import Domain

final class SearchCountryViewModel: BaseViewModel<
    SearchCountryState,
    SearchCountryAction,
    SearchCountryEvent,
    SouvenirRoute
> {
    // MARK: - Properties

    private let onResult: (SearchResultItem) -> Void

    private let countryRepo: CountryRepository

    // MARK: - Init

    init(
        onResult: @escaping (SearchResultItem) -> Void,
        countryRepo: CountryRepository
    ) {
        self.onResult = onResult
        self.countryRepo = countryRepo
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .back:
            navigate(to: .pop)

        case let .searchTextChangedUI(text):
            handleSearchTextChangedUI(text)

        case let .searchTextChangedAPI(text):
            handleSearchTextChangedAPI(text)

        case .clearSearch:
            handleClearSearch()

        case let .selectItem(item):
            handleSelectItem(item)
        }
    }

    // MARK: - Private Logic

    private func handleSearchTextChangedUI(_ text: String) {
        mutate { state in
            state.searchText = text
            state.items = []
            state.isEmpty = text.isEmpty ? true : false
        }

    }

    private func handleSearchTextChangedAPI(_ text: String) {
        guard !text.isEmpty else { return }

        Task {
            do {
                emit(.loading(true))
                let results = try await countryRepo.searchLocations(keyword: text)
                let items = mapToSearchResultItems(results)
                mutate { state in
                    state.items = items
                    state.isEmpty = items.isEmpty
                }
                emit(.loading(false))
            } catch {
                emit(.showAlert(message: error.localizedDescription))
                emit(.loading(false))
            }
        }
    }

    private func mapToSearchResultItems(
        _ locations: [SearchedLocation]
    ) -> [SearchResultItem] {
        locations.map { location in
            let type: SearchResultType =
                location.type == .country ? .country : .city

            let name: String
            let subName: String

            switch type {
            case .country:
                name = location.nameKr
                subName = ""

            case .city:
                name = location.nameKr
                subName = location.countryNameKr ?? ""
            }

            return SearchResultItem(
                id: "\(type)-\(location.id)",
                name: name,
                subName: subName,
                type: type,
                coordinate: location.coordinate.toCLLocationCoordinate2D
            )
        }
    }

    private func handleClearSearch() {
        mutate { state in
            state.searchText = ""
            state.items = []
            state.isEmpty = true
        }
    }

    private func handleSelectItem(_ item: SearchResultItem) {
        onResult(item)
    }
}
