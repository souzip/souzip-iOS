import Domain
import RxCocoa
import RxSwift

final class DiscoveryViewModel: BaseViewModel<
    DiscoveryState,
    DiscoveryAction,
    DiscoveryEvent,
    DiscoveryRoute
> {
    // MARK: - UseCase

    private let loadCountryTopSouvenirs: LoadCountryTopSouvenirsUseCase
    private let loadTopSouvenirsByCategory: LoadTopSouvenirsByCategoryUseCase
    private let loadCountryDetail: LoadCountryDetailUseCase
    private let authSessionStore: AuthSessionStore
    private let wishlistToggleExecutor: WishlistToggleExecutor

    // MARK: - Init

    init(
        loadCountryTopSouvenirs: LoadCountryTopSouvenirsUseCase,
        loadTopSouvenirsByCategory: LoadTopSouvenirsByCategoryUseCase,
        loadCountryDetail: LoadCountryDetailUseCase,
        authSessionStore: AuthSessionStore,
        wishlistToggleExecutor: WishlistToggleExecutor
    ) {
        self.loadCountryTopSouvenirs = loadCountryTopSouvenirs
        self.loadTopSouvenirsByCategory = loadTopSouvenirsByCategory
        self.loadCountryDetail = loadCountryDetail
        self.authSessionStore = authSessionStore
        self.wishlistToggleExecutor = wishlistToggleExecutor
        super.init(initialState: State())
        bindAuthSessionStore()
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
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

        case let .souvenirHeartTap(souvenirID):
            handleSouvenirHeartTap(souvenirID: souvenirID)

        case .moreButtonTap:
            handleMoreButtonTap()

        case .tapFAB:
            navigate(to: .recommend)
        }
    }

    // MARK: - Auth

    private func bindAuthSessionStore() {
        authSessionStore.authStateChanges
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLogin in
                self?.mutate { $0.isGuest = !isLogin }
            })
            .disposed(by: disposeBag)
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
            async let countrySouvenirsTask = loadCountryTopSouvenirs.execute()
            async let categorySouvenirsTask: [SouvenirFeedCardItem] = fetchTop10ByCategory(category: firstCategory)

            let (allCountrySouvenirs, categorySouvenirs) = try await (
                countrySouvenirsTask,
                categorySouvenirsTask
            )

            // 2) 국가 칩 구성 (전체, 첫번째 선택)
            let countryChips: [CountryChipItem] = allCountrySouvenirs.enumerated().map { idx, item in
                let flagImage = (try? loadCountryDetail.execute(countryCode: item.countryCode))?.flagImageURL ?? ""

                return CountryChipItem(
                    countryCode: item.countryCode,
                    title: item.countryNameKr,
                    flagImage: flagImage,
                    isSelected: idx == 0
                )
            }

            // 3) 첫번째 국가의 기념품
            let firstCountrySouvenirs: [SouvenirFeedCardItem] = allCountrySouvenirs.first.map {
                mapToFeedCardItems($0.souvenirs)
            } ?? []

            // 4) 통계 (상위 3개)
            let stats: [StatCountryChipItem] = allCountrySouvenirs.prefix(3).enumerated().map { index, item in
                let flagImage = (try? loadCountryDetail.execute(countryCode: item.countryCode))?.flagImageURL ?? ""

                return StatCountryChipItem(
                    flagImage: flagImage,
                    title: item.countryNameKr,
                    count: "\(item.souvenirCount)",
                    rank: index + 1
                )
            }

            mutate { state in
                state.countryTopSouvenirs = Dictionary(
                    allCountrySouvenirs.map { ($0.countryCode, $0) },
                    uniquingKeysWith: { first, _ in first }
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

        let souvenirs = mapToFeedCardItems(cached.souvenirs)
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

    private func setCountrySouvenirs(_ items: [SouvenirFeedCardItem]) {
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

    private func setCategorySouvenirs(_ items: [SouvenirFeedCardItem]) {
        mutate { $0.categorySouvenirs = items }
    }

    private func setCategoryExpanded(_ expanded: Bool) {
        mutate { $0.isCategoryExpanded = expanded }
    }

    private func handleMoreButtonTap() {
        mutate { $0.isCategoryExpanded.toggle() }
    }

    // MARK: - Fetch Helpers

    private func fetchTop10ByCategory(category: SouvenirCategory) async throws -> [SouvenirFeedCardItem] {
        let souvenirs = try await loadTopSouvenirsByCategory.execute(category: category)
        return mapToFeedCardItems(souvenirs)
    }

    private func mapToFeedCardItems(_ souvenirs: [CatalogSouvenir]) -> [SouvenirFeedCardItem] {
        souvenirs.map { SouvenirFeedCardItem(catalogSouvenir: $0) }
    }

    // MARK: - Wishlist

    private func handleSouvenirHeartTap(souvenirID: Int) {
        if state.value.isGuest {
            navigate(to: .loginBottomSheet)
            return
        }

        guard let item = findFeedCard(souvenirID: souvenirID) else { return }

        // `isWishlisted == nil`(비로그인·미설정)은 PRD상 비찜 UI — `guard let`으로 막지 않는다.
        let currentlyWishlisted = item.isWishlisted
        let nextWishlisted = currentlyWishlisted == true ? false : true
        applyWishlisted(souvenirID: souvenirID, isWishlisted: nextWishlisted)

        Task {
            await wishlistToggleExecutor.toggle(
                souvenirId: souvenirID,
                currentlyWishlisted: currentlyWishlisted
            )
        }
    }

    private func findFeedCard(souvenirID: Int) -> SouvenirFeedCardItem? {
        if let item = state.value.countrySouvenirs.first(where: { $0.id == souvenirID }) {
            return item
        }
        return state.value.categorySouvenirs.first(where: { $0.id == souvenirID })
    }

    private func applyWishlisted(souvenirID: Int, isWishlisted: Bool?) {
        mutate { state in
            state.countrySouvenirs = state.countrySouvenirs.map {
                $0.id == souvenirID ? $0.withWishlisted(isWishlisted) : $0
            }
            state.categorySouvenirs = state.categorySouvenirs.map {
                $0.id == souvenirID ? $0.withWishlisted(isWishlisted) : $0
            }
        }
    }
}
