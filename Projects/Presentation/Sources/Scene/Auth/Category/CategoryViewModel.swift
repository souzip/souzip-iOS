import Domain

final class CategoryViewModel: BaseViewModel<
    CategoryState,
    CategoryAction,
    CategoryEvent,
    AuthRoute
> {
    // MARK: - Init

    init() {
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .back:
            navigate(to: .back)

        case let .toggle(item):
            handleToggle(item.category)

        case .complete:
            break
        }
    }

    // MARK: - Private Logic

    private func handleToggle(_ category: SouvenirCategory) {
        mutate { state in
            if state.selected.contains(category) {
                state.selected.remove(category)
            } else {
                guard state.selected.count < 5 else {
                    self.emit(.showToast(message: "카테고리는 5개까지 선택가능해요."))
                    return
                }
                state.selected.insert(category)
            }

            guard let idx = state.indexByCategory[category] else { return }

            state.items[idx].isSelected = state.selected.contains(category)
        }
    }
}
