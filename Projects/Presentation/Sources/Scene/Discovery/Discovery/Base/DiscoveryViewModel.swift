import Domain

final class DiscoveryViewModel: BaseViewModel<
    DiscoveryState,
    DiscoveryAction,
    DiscoveryEvent,
    DiscoveryRoute
> {
    // MARK: - Init

    init() {
        super.init(initialState: State())
        Task { await loadInitialData() }
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case let .countryChipTap(item):
            Task { await handleCountryChipTap(item) }

        case let .categoryChipTap(item):
            Task { await handleCategoryChipTap(item) }

        case let .souvenirCardTap(item):
            navigate(to: .souvenirRoute(.detail(id: item.id)))

        case .moreButtonTap:
            handleMoreButtonTap()

        case .tapFAB:
            break
        }
    }

    // MARK: - Data Loading

    private func loadInitialData() async {
        let mockData = DiscoveryData.mock

        mutate { state in
            // 1. 먼저 전체 카드 저장 (8개)
            if let category = mockData.category {
                state.fullCategoryCards = category.souvenirCards
            }

            // 2. 화면에 표시할 데이터는 4개로 제한
            var displayData = mockData
            if let category = mockData.category {
                let limitedCards = Array(category.souvenirCards.prefix(4))
                let updatedCategory = CategorySection(
                    header: category.header,
                    categoryChips: category.categoryChips,
                    souvenirCards: limitedCards,
                    moreButtonTitle: category.moreButtonTitle
                )
                displayData = DiscoveryData(
                    top10: mockData.top10,
                    banner: mockData.banner,
                    category: updatedCategory,
                    statistics: mockData.statistics
                )
            }

            state.data = displayData
        }
    }

    // MARK: - Private Logic

    private func handleCountryChipTap(_ item: CountryChipItem) async {
        guard let data = state.value.data,
              let top10 = data.top10 else { return }

        // 이미 선택된 칩이면 무시
        if state.value.selectedCountryId == item.id { return }

        // TODO: 실제로는 try await fetchTop10Cards(countryId: item.id)
        let newCards = await fetchMockSouvenirCards(for: item.id)

        mutate { state in
            state.selectedCountryId = item.id

            let updatedChips = top10.countryChips.map { chip in
                CountryChipItem(
                    id: chip.id,
                    title: chip.title,
                    flagImage: chip.flagImage,
                    isSelected: chip.id == item.id
                )
            }

            let updatedTop10 = Top10Section(
                header: top10.header,
                countryChips: updatedChips,
                souvenirCards: newCards
            )

            state.data = DiscoveryData(
                top10: updatedTop10,
                banner: data.banner,
                category: data.category,
                statistics: data.statistics
            )
        }
    }

    private func handleCategoryChipTap(_ item: CategoryChipItem) async {
        guard let data = state.value.data,
              let category = data.category else { return }

        // 이미 선택된 칩이면 무시
        let selectedId = "\(item.category.title)"
        if state.value.selectedCategoryId == selectedId { return }

        // TODO: 실제로는 try await fetchCategoryCards(category: item.category)
        let fullCards = await fetchMockSouvenirCards(for: item.category)

        mutate { state in
            state.selectedCategoryId = selectedId
            state.isCategoryExpanded = false
            state.fullCategoryCards = fullCards

            let updatedChips = category.categoryChips.map { chip in
                CategoryChipItem(
                    category: chip.category,
                    isSelected: chip.category == item.category
                )
            }

            let limitedCards = Array(fullCards.prefix(4))
            let updatedCategory = CategorySection(
                header: category.header,
                categoryChips: updatedChips,
                souvenirCards: limitedCards,
                moreButtonTitle: category.moreButtonTitle
            )

            state.data = DiscoveryData(
                top10: data.top10,
                banner: data.banner,
                category: updatedCategory,
                statistics: data.statistics
            )
        }
    }

    private func handleMoreButtonTap() {
        guard let data = state.value.data,
              let category = data.category else { return }

        mutate { state in
            state.isCategoryExpanded = true

            let updatedCategory = CategorySection(
                header: category.header,
                categoryChips: category.categoryChips,
                souvenirCards: state.fullCategoryCards,
                moreButtonTitle: category.moreButtonTitle
            )

            state.data = DiscoveryData(
                top10: data.top10,
                banner: data.banner,
                category: updatedCategory,
                statistics: data.statistics
            )
        }
    }

    // MARK: - Mock API Calls (TODO: 실제 API로 교체)

    private func fetchMockSouvenirCards(for countryId: String) async -> [SouvenirCardItem] {
        [
            SouvenirCardItem(id: 1, imageURL: "https://picsum.photos/seed/\(countryId)1/400/400", title: "\(countryId) 기념품 1", category: "카테고리"),
            SouvenirCardItem(id: 2, imageURL: "https://picsum.photos/seed/\(countryId)2/400/400", title: "\(countryId) 기념품 2", category: "카테고리"),
            SouvenirCardItem(id: 3, imageURL: "https://picsum.photos/seed/\(countryId)3/400/400", title: "\(countryId) 기념품 3", category: "카테고리"),
            SouvenirCardItem(id: 4, imageURL: "https://picsum.photos/seed/\(countryId)4/400/400", title: "\(countryId) 기념품 4", category: "카테고리"),
        ]
    }

    private func fetchMockSouvenirCards(for category: SouvenirCategory) async -> [SouvenirCardItem] {
        let categoryName = category.title
        return (1 ... 8).map { index in
            SouvenirCardItem(
                id: 1,
                imageURL: "https://picsum.photos/seed/\(categoryName)\(index)/400/400",
                title: "\(categoryName) 기념품 \(index)",
                category: categoryName
            )
        }
    }
}
