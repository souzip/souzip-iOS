import Domain

final class SearchCountryViewModel: BaseViewModel<
    SearchCountryState,
    SearchCountryAction,
    SearchCountryEvent,
    SouvenirRoute
> {
    // MARK: - Properties

    private let onResult: ([SearchResultItem], SearchResultItem, String) -> Void

    private let countryRepo: CountryRepository

    /// 엔터 입력 후 API 결과를 기다리는 중인지 여부
    private var pendingReturnKey = false

    /// 진행 중인 위치 검색 요청 — 새 검색 시 취소해 이전 응답이 상태를 덮어쓰지 않게 함
    private var searchLocationsTask: Task<Void, Never>?

    // MARK: - Init

    init(
        initialSearchText: String = "",
        onResult: @escaping ([SearchResultItem], SearchResultItem, String) -> Void,
        countryRepo: CountryRepository
    ) {
        self.onResult = onResult
        self.countryRepo = countryRepo
        super.init(initialState: State(initialSearchText: initialSearchText))

        if !initialSearchText.isEmpty {
            handleSearchTextChangedAPI(initialSearchText)
        }
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

        case let .resumeFromLocationResult(query):
            handleResumeFromLocationResult(query)
        }
    }

    // MARK: - Private Logic

    private func handleSearchTextChangedUI(_ text: String) {
        searchLocationsTask?.cancel()
        searchLocationsTask = nil
        pendingReturnKey = false
        mutate { state in
            state.searchText = text
            state.items = []
            if text.isEmpty {
                state.isSearchInFlight = false
            } else {
                state.isSearchInFlight = true
            }
        }
    }

    private func handleSearchTextChangedAPI(_ text: String) {
        guard !text.isEmpty else { return }

        searchLocationsTask?.cancel()
        let query = text
        searchLocationsTask = Task { [weak self] in
            guard let self else { return }
            do {
                await MainActor.run {
                    self.emit(.loading(true))
                }
                let results = try await countryRepo.searchLocations(keyword: query)
                let items = mapToSearchResultItems(results)
                await MainActor.run {
                    guard self.state.value.searchText == query else { return }
                    guard !Task.isCancelled else { return }
                    self.mutate { state in
                        state.items = items
                        state.isSearchInFlight = false
                    }
                    self.emit(.loading(false))
                    self.handlePendingReturnKeyIfNeeded(items: items)
                }
            } catch {
                await MainActor.run {
                    guard self.state.value.searchText == query else { return }
                    if error is CancellationError || Task.isCancelled {
                        self.mutate { state in
                            state.isSearchInFlight = false
                        }
                        self.emit(.loading(false))
                        return
                    }
                    self.emit(.showAlert(message: error.localizedDescription))
                    self.emit(.loading(false))
                    self.mutate { state in
                        state.items = []
                        state.isSearchInFlight = false
                    }
                    self.handlePendingReturnKeyIfNeeded(items: [])
                }
            }
        }
    }

    private func mapToSearchResultItems(
        _ hits: [LocationSearchHit]
    ) -> [SearchResultItem] {
        hits.map { hit in
            switch hit {
            case let .city(city):
                SearchResultItem(
                    id: city.id.rawValue,
                    name: city.title,
                    detail: .city(subName: city.countryLine ?? ""),
                    coordinate: city.coordinate.toCLLocationCoordinate2D
                )

            case let .place(place):
                SearchResultItem(
                    id: place.id.rawValue,
                    name: place.title,
                    detail: .place(
                        category: place.placeKind ?? "",
                        region: place.areaDescription ?? ""
                    ),
                    coordinate: place.coordinate.toCLLocationCoordinate2D
                )
            }
        }
    }

    private func handleClearSearch() {
        searchLocationsTask?.cancel()
        searchLocationsTask = nil
        pendingReturnKey = false
        mutate { state in
            state.searchText = ""
            state.items = []
            state.isSearchInFlight = false
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
        onResult(state.value.items, item, state.value.searchText)
    }

    private func handleResumeFromLocationResult(_ query: String?) {
        pendingReturnKey = false
        if let query, !query.isEmpty {
            mutate { state in
                state.searchText = query
                state.items = []
                state.isSearchInFlight = true
            }
            handleSearchTextChangedAPI(query)
        } else {
            handleClearSearch()
        }
    }
}
