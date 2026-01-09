import Domain

final class CategoryPickerViewModel: BaseViewModel<
    CategoryPickerState,
    CategoryPickerAction,
    CategoryPickerEvent,
    SouvenirRoute
> {
    // MARK: - Callback

    var onCompleted: (SouvenirCategory) -> Void

    // MARK: - Init

    init(
        initialCategory: SouvenirCategory? = nil,
        onCompleted: @escaping (SouvenirCategory) -> Void
    ) {
        self.onCompleted = onCompleted
        var initialState = State()

        // 초기 선택된 카테고리가 있다면 설정
        if let category = initialCategory {
            initialState.selected = category
            if let idx = initialState.indexByCategory[category] {
                initialState.items[idx].isSelected = true
            }
        }

        super.init(initialState: initialState)
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .back:
            navigate(to: .pop)

        case let .select(item):
            handleSelect(item.category)

        case .complete:
            handleComplete()
        }
    }

    // MARK: - Private Logic

    private func handleSelect(_ category: SouvenirCategory) {
        mutate { state in
            if let previousCategory = state.selected,
               let previousIdx = state.indexByCategory[previousCategory] {
                state.items[previousIdx].isSelected = false
            }

            state.selected = category

            guard let idx = state.indexByCategory[category] else { return }
            state.items[idx].isSelected = true
        }
    }

    private func handleComplete() {
        guard let selectedCategory = state.value.selected else {
            emit(.showToast(message: "카테고리를 선택해주세요."))
            return
        }

        onCompleted(selectedCategory)
        navigate(to: .pop)
    }
}
