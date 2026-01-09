import Domain

final class CategoryViewModel: BaseViewModel<
    CategoryState,
    CategoryAction,
    CategoryEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let saveCategories: SaveCategoriesUseCase
    private let completeOnboarding: CompleteOnboardingUseCase

    // MARK: - Init

    init(
        saveCategories: SaveCategoriesUseCase,
        completeOnboarding: CompleteOnboardingUseCase
    ) {
        self.saveCategories = saveCategories
        self.completeOnboarding = completeOnboarding
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
            Task { await handleComplete() }
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

    private func handleComplete() async {
        let categories = Array(state.value.selected)

        guard !categories.isEmpty else {
            emit(.showToast(message: "카테고리를 최소 1개 선택해주세요."))
            return
        }

        do {
            // 1. 카테고리 저장
            saveCategories.execute(categories: categories)

            mutate { $0.isLoading = true }

            // 2. 온보딩 완료 API 호출
            _ = try await completeOnboarding.execute()

            // 3. 성공 시 메인 화면으로 이동
            mutate { $0.isLoading = false }
            navigate(to: .main) // 또는 적절한 Route

        } catch {
            mutate { $0.isLoading = false }
            emit(.showAlert(message: error.localizedDescription))
        }
    }
}
