import RxRelay

final class LocationSearchResultViewModel: BaseViewModel<
    LocationSearchResultState,
    LocationSearchResultAction,
    Never,
    SouvenirRoute
> {
    // MARK: - Properties

    private let onConfirm: (SearchResultItem) -> Void

    // MARK: - Init

    init(
        items: [SearchResultItem],
        searchText: String,
        onConfirm: @escaping (SearchResultItem) -> Void
    ) {
        self.onConfirm = onConfirm
        super.init(initialState: State(items: items, searchText: searchText))
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case let .selectItemFromList(index),
             let .selectItemFromMap(index):
            handleSelectItem(index)

        case .tapConfirm:
            handleConfirm()

        case .back:
            navigate(to: .pop)

        case .tapSearchBar:
            navigate(
                to: .popToSearchFromLocationResult(
                    .refineQuery(state.value.searchText)
                )
            )

        case .tapClearSearchBar:
            navigate(to: .popToSearchFromLocationResult(.clearAndRestart))
        }
    }

    // MARK: - Private

    private func handleSelectItem(_ index: Int) {
        guard state.value.items.indices.contains(index) else { return }
        mutate { state in
            state.selectedIndex = index
        }
    }

    private func handleConfirm() {
        guard let item = state.value.selectedItem else { return }
        onConfirm(item)
        navigate(to: .poptoForm)
    }
}
