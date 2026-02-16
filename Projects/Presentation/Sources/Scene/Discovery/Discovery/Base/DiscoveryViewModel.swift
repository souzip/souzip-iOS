import Domain

final class DiscoveryViewModel: BaseViewModel<
    DiscoveryState,
    DiscoveryAction,
    DiscoveryEvent,
    DiscoveryRoute
> {
    // MARK: - Repository

    private let discoveryRepo: DiscoveryRepository
    private let countryRepo: CountryRepository
    private let authRepo: AuthRepository

    // MARK: - Init

    init(
        discoveryRepo: DiscoveryRepository,
        countryRepo: CountryRepository,
        authRepo: AuthRepository
    ) {
        self.discoveryRepo = discoveryRepo
        self.countryRepo = countryRepo
        self.authRepo = authRepo
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task {
                let isLogin = await authRepo.isFullyAuthenticated()
                mutate { $0.isGuest = !isLogin }
            }

        case .viewDidLoad:
            Task {
                emit(.loading(true))
                await loadInitialData()
                emit(.loading(false))
            }

        case .refresh:
            Task {
                try? await Task.sleep(for: .seconds(1))
                await loadInitialData()
                emit(.endRefreshing)
            }

        case let .countryChipTap(item):
            handleCountryChipTap(item)

        case let .categoryChipTap(item):
            Task { await handleCategoryChipTap(item) }

        case let .souvenirCardTap(item):
            navigate(to: .souvenirRoute(.detail(id: item.id)))

        case .moreButtonTap:
            handleMoreButtonTap()

        case .tapFAB:
            navigate(to: .recommend)
        }
    }

    // MARK: - Data Loading

    private func loadInitialData() async {
        do {
            // 0) 기본 카테고리 + 첫번째 선택
            let defaultCategories = CategoryItem.defaultItems
            guard let firstCategory = defaultCategories.first?.category else { return }

            let selectedCategories = defaultCategories.map {
                CategoryItem(category: $0.category, isSelected: $0.category == firstCategory)
            }

            // 1) 국가별 기념품 + 카테고리별 기념품 동시 호출
            async let countrySouvenirsTask = discoveryRepo.getCountrySouvenirs()
            async let categorySouvenirsTask: [SouvenirCardItem] = fetchTop10ByCategory(category: firstCategory)

            let (allCountrySouvenirs, categorySouvenirs) = try await (
                countrySouvenirsTask,
                categorySouvenirsTask
            )

            // 2) 국가 칩 구성 (전체, 첫번째 선택)
            let countryChips: [CountryChipItem] = allCountrySouvenirs.enumerated().map { idx, item in
                let flagImage = (try? countryRepo.fetchCountry(countryCode: item.countryCode))?.flagImageURL ?? ""

                return CountryChipItem(
                    countryCode: item.countryCode,
                    title: item.countryNameKr,
                    flagImage: flagImage,
                    isSelected: idx == 0
                )
            }

            // 3) 첫번째 국가의 기념품
            let firstCountrySouvenirs: [SouvenirCardItem] = allCountrySouvenirs.first.map {
                mapToSouvenirCardItems($0.souvenirs)
            } ?? []

            // 4) 통계 (상위 3개)
            let stats: [StatCountryChipItem] = allCountrySouvenirs.prefix(3).enumerated().map { index, item in
                let flagImage = (try? countryRepo.fetchCountry(countryCode: item.countryCode))?.flagImageURL ?? ""

                return StatCountryChipItem(
                    flagImage: flagImage,
                    title: item.countryNameKr,
                    count: "\(item.souvenirCount)",
                    rank: index + 1
                )
            }

            mutate { state in
                state.countryTopSouvenirs = Dictionary(
                    uniqueKeysWithValues: allCountrySouvenirs.map { ($0.countryCode, $0) }
                )
                state.countries = countryChips
                state.countrySouvenirs = firstCountrySouvenirs
                state.categories = selectedCategories
                state.categorySouvenirs = categorySouvenirs
                state.isCategoryExpanded = false
                state.statCountry = stats
            }
        } catch {
            emit(.showErrorAlert(error.localizedDescription))
        }
    }

    // MARK: - Country Tap

    private func handleCountryChipTap(_ item: CountryChipItem) {
        guard state.value.countries.contains(where: { $0.countryCode == item.countryCode && $0.isSelected }) == false else {
            return
        }

        setSelectedCountry(code: item.countryCode)

        guard let cached = state.value.countryTopSouvenirs[item.countryCode] else { return }

        let souvenirs = mapToSouvenirCardItems(cached.souvenirs)
        setCountrySouvenirs(souvenirs)
    }

    private func setSelectedCountry(code: String) {
        mutate { state in
            state.countries = state.countries.map { chip in
                CountryChipItem(
                    countryCode: chip.countryCode,
                    title: chip.title,
                    flagImage: chip.flagImage,
                    isSelected: chip.countryCode == code
                )
            }
        }
    }

    private func setCountrySouvenirs(_ items: [SouvenirCardItem]) {
        mutate { $0.countrySouvenirs = items }
    }

    // MARK: - Category Tap

    private func handleCategoryChipTap(_ item: CategoryItem) async {
        guard state.value.categories.contains(where: { $0.category == item.category && $0.isSelected }) == false else {
            return
        }

        setSelectedCategory(category: item.category)
        setCategoryExpanded(false)

        do {
            let souvenirs = try await fetchTop10ByCategory(category: item.category)
            setCategorySouvenirs(souvenirs)
        } catch {
            emit(.showErrorAlert(error.localizedDescription))
        }
    }

    private func setSelectedCategory(category: SouvenirCategory) {
        mutate { state in
            state.categories = state.categories.map { chip in
                CategoryItem(
                    category: chip.category,
                    isSelected: chip.category == category
                )
            }
        }
    }

    private func setCategorySouvenirs(_ items: [SouvenirCardItem]) {
        mutate { $0.categorySouvenirs = items }
    }

    private func setCategoryExpanded(_ expanded: Bool) {
        mutate { $0.isCategoryExpanded = expanded }
    }

    private func handleMoreButtonTap() {
        mutate { $0.isCategoryExpanded.toggle() }
    }

    // MARK: - Fetch Helpers

    private func fetchTop10ByCategory(category: SouvenirCategory) async throws -> [SouvenirCardItem] {
        let souvenirs = try await discoveryRepo.getTop10SouvenirsByCategory(category: category)
        return mapToSouvenirCardItems(souvenirs)
    }

    private func mapToSouvenirCardItems(_ souvenirs: [DiscoverySouvenir]) -> [SouvenirCardItem] {
        souvenirs.map {
            SouvenirCardItem(
                id: $0.id,
                imageURL: $0.thumbnailUrl,
                title: $0.name,
                category: $0.category.title
            )
        }
    }
}
