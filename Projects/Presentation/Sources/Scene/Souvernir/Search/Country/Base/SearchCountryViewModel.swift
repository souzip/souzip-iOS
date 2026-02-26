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

    /// 엔터 입력 후 API 결과를 기다리는 중인지 여부
    private var pendingReturnKey = false

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

        case .returnKeyTapped:
            handleReturnKeyTapped()
        }
    }

    // MARK: - Private Logic

    private func handleSearchTextChangedUI(_ text: String) {
        pendingReturnKey = false
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
                handlePendingReturnKeyIfNeeded(items: items)
            } catch {
                emit(.showAlert(message: error.localizedDescription))
                emit(.loading(false))
                handlePendingReturnKeyIfNeeded(items: [])
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
        pendingReturnKey = false
        mutate { state in
            state.searchText = ""
            state.items = []
            state.isEmpty = true
        }
    }

    private func handleReturnKeyTapped() {
        let currentState = state.value
        // 이미 결과가 있으면 즉시 첫 번째 아이템 선택
        if let firstItem = currentState.items.first {
            handleSelectItem(firstItem)
            return
        }

        // 검색어가 없으면 Return 버튼으로 이미 키보드가 내려간 상태
        guard !currentState.searchText.isEmpty else { return }

        // 검색어는 있지만 아직 API 결과 대기 중 → 완료 후 처리
        pendingReturnKey = true
    }

    private func handlePendingReturnKeyIfNeeded(items: [SearchResultItem]) {
        guard pendingReturnKey else { return }
        pendingReturnKey = false

        if let firstItem = items.first {
            handleSelectItem(firstItem)
        }
    }

    private func handleSelectItem(_ item: SearchResultItem) {
        onResult(item)
    }
}
