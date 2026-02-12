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
                let isLogin = await authRepo.checkLoginStatus()
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
            Task { await handleCountryChipTap(item) }

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
            let topCountryCodes = ["JP", "HK", "TW"]

            // 0) 기본 카테고리 + 첫번째 선택
            let defaultCategories = CategoryItem.defaultItems
            guard let firstCategory = defaultCategories.first?.category else {
                mutate { state in
                    state.countries = []
                    state.countrySouvenirs = []
                    state.categories = []
                    state.categorySouvenirs = []
                    state.isCategoryExpanded = false
                    state.statCountry = []
                }
                return
            }

            let selectedCategories = defaultCategories.map {
                CategoryItem(category: $0.category, isSelected: $0.category == firstCategory)
            }

            async let countriesTask: [CountryChipItem] = fetchTopCountries(codes: topCountryCodes)

            async let categorySouvenirsTask: [SouvenirCardItem] = fetchTop10ByCategory(category: firstCategory)

            async let statsTask: [StatCountryChipItem] = fetchDiscoveryStats()

            let countries = try await countriesTask
            guard let firstCountryCode = countries.first?.countryCode else {
                mutate { state in
                    state.countries = []
                    state.countrySouvenirs = []
                    state.categories = selectedCategories
                    state.categorySouvenirs = []
                    state.isCategoryExpanded = false
                    state.statCountry = []
                }
                return
            }

            async let countrySouvenirsTask: [SouvenirCardItem] = fetchTop10ByCountry(countryCode: firstCountryCode)

            let (
                countrySouvenirs,
                categorySouvenirs,
                stats
            ) = try await (
                countrySouvenirsTask,
                categorySouvenirsTask,
                statsTask
            )

            mutate { state in
                state.countries = countries.enumerated().map { idx, chip in
                    CountryChipItem(
                        countryCode: chip.countryCode,
                        title: chip.title,
                        flagImage: chip.flagImage,
                        isSelected: idx == 0
                    )
                }

                state.countrySouvenirs = countrySouvenirs
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

    private func handleCountryChipTap(_ item: CountryChipItem) async {
        guard state.value.countries.contains(where: { $0.countryCode == item.countryCode && $0.isSelected }) == false else {
            return
        }

        setSelectedCountry(code: item.countryCode)

        do {
            let souvenirs = try await fetchTop10ByCountry(countryCode: item.countryCode)
            setCountrySouvenirs(souvenirs)
        } catch {
            emit(.showErrorAlert(error.localizedDescription))
        }
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

    private func fetchTopCountries(codes: [String]) throws -> [CountryChipItem] {
        codes.compactMap { code -> CountryChipItem? in
            guard let country = try? countryRepo.fetchCountry(
                countryCode: code
            ) else { return nil }

            return CountryChipItem(
                countryCode: country.code,
                title: country.nameKorean,
                flagImage: country.flagImageURL,
                isSelected: false
            )
        }
    }

    private func fetchTop10ByCountry(countryCode: String) async throws -> [SouvenirCardItem] {
        let souvenirs = try await discoveryRepo.getTop10SouvenirsByCountry(countryCode: countryCode)
        return souvenirs.map {
            let category = koreanTitle(from: $0.category)

            return SouvenirCardItem(
                id: $0.id,
                imageURL: $0.thumbnailUrl,
                title: $0.name,
                category: category
            )
        }
    }

    private func fetchTop10ByCategory(category: SouvenirCategory) async throws -> [SouvenirCardItem] {
        let souvenirs = try await discoveryRepo.getTop10SouvenirsByCategory(category: category)
        return souvenirs.map {
            let category = koreanTitle(from: $0.category)

            return SouvenirCardItem(
                id: $0.id,
                imageURL: $0.thumbnailUrl,
                title: $0.name,
                category: category
            )
        }
    }

    private func fetchDiscoveryStats() async throws -> [StatCountryChipItem] {
        let stats = try await discoveryRepo.getTop3CountryStats()

        // rank: 1~3
        return stats.enumerated().map { index, item in
            StatCountryChipItem(
                flagImage: item.imageUrl,
                title: item.countryNameKr,
                count: "\(item.souvenirCount)",
                rank: index + 1
            )
        }
    }

    private func koreanTitle(from serverCode: String) -> String {
        switch serverCode {
        case "FOOD_SNACK": "먹거리·간식"
        case "BEAUTY_HEALTH": "뷰티·헬스"
        case "FASHION_ACCESSORY": "패션·악세서리"
        case "CULTURE_TRADITION": "문화·전통"
        case "TOY_KIDS": "장난감·키즈"
        case "SOUVENIR_BASIC": "기념품 기본템"
        case "HOME_LIFESTYLE": "홈·라이프스타일"
        case "STATIONERY_ART": "문구·아트"
        case "TRAVEL_PRACTICAL": "여행·실용템"
        case "TECH_GADGET": "테크·전자제품"
        default:
            serverCode // 혹은 ""
        }
    }
}
