import Domain

final class SearchCountryViewModel: BaseViewModel<
    SearchCountryState,
    SearchCountryAction,
    SearchCountryEvent,
    SouvenirRoute
> {
    // MARK: - Properties

    private let onResult: (SearchResultItem) -> Void

    // MARK: - Init

    init(
        onResult: @escaping (SearchResultItem) -> Void
    ) {
        self.onResult = onResult
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

//        if text.isEmpty {
//            emit(.loading(false))
//        } else {
//            emit(.loading(true))
//        }
    }

    private func handleSearchTextChangedAPI(_ text: String) {
        guard !text.isEmpty else { return }

        // 추후 API 연동
        // Task {
        //     do {
        //         let results = try await searchUseCase.search(query: text)
        //         mutate { state in
        //             state.items = results
        //             state.isEmpty = results.isEmpty
        //         }
        //         emit(.loading(false))
        //     } catch {
        //         emit(.loading(false))
        //         emit(.showToast(message: "검색 실패"))
        //     }
        // }
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
