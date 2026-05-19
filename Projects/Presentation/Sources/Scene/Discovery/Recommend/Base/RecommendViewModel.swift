import Domain
import RxCocoa
import RxSwift

final class RecommendViewModel: BaseViewModel<
    RecommendState,
    RecommendAction,
    RecommendEvent,
    DiscoveryRoute
> {
    // MARK: - UseCase

    private let loadAIRecommendationsForCategory: LoadAIRecommendationsForCategoryUseCase
    private let loadAIRecommendationsForUpload: LoadAIRecommendationsForUploadUseCase
    private let loadCountryDetail: LoadCountryDetailUseCase
    private let authSessionStore: AuthSessionStore
    private let wishlistToggleExecutor: WishlistToggleExecutor

    private var preferredAll: [CatalogSouvenir] = []
    private var uploadAll: [CatalogSouvenir] = []

    // MARK: - Init

    init(
        loadAIRecommendationsForCategory: LoadAIRecommendationsForCategoryUseCase,
        loadAIRecommendationsForUpload: LoadAIRecommendationsForUploadUseCase,
        loadCountryDetail: LoadCountryDetailUseCase,
        authSessionStore: AuthSessionStore,
        wishlistToggleExecutor: WishlistToggleExecutor
    ) {
        self.loadAIRecommendationsForCategory = loadAIRecommendationsForCategory
        self.loadAIRecommendationsForUpload = loadAIRecommendationsForUpload
        self.loadCountryDetail = loadCountryDetail
        self.authSessionStore = authSessionStore
        self.wishlistToggleExecutor = wishlistToggleExecutor
        super.init(initialState: State())
        bindAuthSessionStore()
    }

    // MARK: - Action

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
                await loadInitialData()
                emit(.endRefreshing)
            }

        case .back:
            navigate(to: .pop)

        case let .countryChipTap(item):
            Task { await handleCountryChipTap(item) }

        case let .souvenirCardTap(item):
            navigate(to: .souvenirRoute(.detail(id: item.id)))

        case let .souvenirHeartTap(souvenirID):
            handleSouvenirHeartTap(souvenirID: souvenirID)

        case .uploadButtonTap:
            navigate(to: .souvenirRoute(.create))

        case .preferredMoreTap:
            mutate { $0.isPreferredExpanded.toggle() }

        case .uploadMoreTap:
            mutate { $0.isUploadExpanded.toggle() }
        }
    }
}

// MARK: - Auth

private extension RecommendViewModel {
    func bindAuthSessionStore() {
        authSessionStore.authStateChanges
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLogin in
                self?.mutate { $0.isGuest = !isLogin }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Load

private extension RecommendViewModel {
    func loadInitialData() async {
        do {
            let (preferred, upload) = try await fetchAIRecommendations()

            preferredAll = preferred
            uploadAll = upload

            let countries = await makeCountryChips(from: preferredAll)
            let initialSelectedCode = countries.first?.countryCode

            let selectedCountries = setSelectedCountry(
                countries,
                selectedCode: initialSelectedCode
            )

            let preferredCardsAll = makePreferredCardsAll(selectedCode: initialSelectedCode)
            let uploadCardsAll = mapToCards(uploadAll)
            let uploadCountryName = await resolveUploadCountryName(from: uploadAll)

            mutate { state in
                state.countries = selectedCountries
                state.preferredSouvenirs = preferredCardsAll

                state.uploadSouvenirs = uploadCardsAll
                state.uploadCountryName = uploadCountryName

                state.isPreferredExpanded = false
                state.isUploadExpanded = false
            }
        } catch {
            emit(.showErrorAlert(message: error.localizedDescription))
        }
    }

    func fetchAIRecommendations() async throws -> (
        preferred: [CatalogSouvenir],
        upload: [CatalogSouvenir]
    ) {
        async let preferredTask = loadAIRecommendationsForCategory.execute()
        async let uploadTask = loadAIRecommendationsForUpload.execute()

        let preferred = try await preferredTask
        let upload = try await uploadTask

        return (preferred, upload)
    }
}

// MARK: - Tap Handling

private extension RecommendViewModel {
    func handleCountryChipTap(_ item: CountryChipItem) async {
        // 이미 선택된 칩이면 무시
        guard state.value.countries.contains(where: {
            $0.countryCode == item.countryCode && $0.isSelected
        }) == false else { return }

        mutate { state in
            state.countries = self.setSelectedCountry(
                state.countries,
                selectedCode: item.countryCode
            )
            state.isPreferredExpanded = false
        }

        let preferredCardsAll = makePreferredCardsAll(selectedCode: item.countryCode)
        mutate { $0.preferredSouvenirs = preferredCardsAll }
    }
}

// MARK: - Builders

private extension RecommendViewModel {
    func makeCountryChips(from preferred: [CatalogSouvenir]) async -> [CountryChipItem] {
        let codes = orderedUnique(preferred.map(\.countryCode))

        var result: [CountryChipItem] = []

        for code in codes {
            guard let country = try? loadCountryDetail.execute(countryCode: code) else {
                continue
            }

            result.append(
                CountryChipItem(
                    countryCode: country.code,
                    title: country.nameKorean,
                    flagImage: country.flagImageURL,
                    isSelected: false
                )
            )
        }

        return result
    }

    func setSelectedCountry(
        _ countries: [CountryChipItem],
        selectedCode: String?
    ) -> [CountryChipItem] {
        guard let selectedCode, !selectedCode.isEmpty else { return countries }

        return countries.map { chip in
            CountryChipItem(
                countryCode: chip.countryCode,
                title: chip.title,
                flagImage: chip.flagImage,
                isSelected: chip.countryCode.caseInsensitiveCompare(selectedCode) == .orderedSame
            )
        }
    }

    func makePreferredCardsAll(selectedCode: String?) -> [SouvenirFeedCardItem] {
        let filtered = filterByCountry(preferredAll, countryCode: selectedCode)
        return mapToCards(filtered)
    }

    func resolveUploadCountryName(from upload: [CatalogSouvenir]) async -> String? {
        guard let code = upload.first?.countryCode else { return nil }
        guard let country = try? loadCountryDetail.execute(countryCode: code) else { return nil }
        return country.nameKorean
    }
}

// MARK: - Helpers

private extension RecommendViewModel {
    func mapToCards(_ souvenirs: [CatalogSouvenir]) -> [SouvenirFeedCardItem] {
        souvenirs.map { SouvenirFeedCardItem(catalogSouvenir: $0) }
    }

    func filterByCountry(
        _ souvenirs: [CatalogSouvenir],
        countryCode: String?
    ) -> [CatalogSouvenir] {
        guard let code = countryCode, code.isEmpty == false else { return souvenirs }
        return souvenirs.filter { $0.countryCode.caseInsensitiveCompare(code) == .orderedSame }
    }

    func orderedUnique(_ codes: [String]) -> [String] {
        var set = Set<String>()
        var result: [String] = []
        result.reserveCapacity(codes.count)

        for code in codes {
            let upper = code.uppercased()
            if set.insert(upper).inserted {
                result.append(upper)
            }
        }
        return result
    }
}

// MARK: - Wishlist

private extension RecommendViewModel {
    func handleSouvenirHeartTap(souvenirID: Int) {
        if state.value.isGuest {
            navigate(to: .loginBottomSheet)
            return
        }

        guard let item = findFeedCard(souvenirID: souvenirID) else { return }

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

    func findFeedCard(souvenirID: Int) -> SouvenirFeedCardItem? {
        if let item = state.value.preferredSouvenirs.first(where: { $0.id == souvenirID }) {
            return item
        }
        return state.value.uploadSouvenirs.first(where: { $0.id == souvenirID })
    }

    func applyWishlisted(souvenirID: Int, isWishlisted: Bool?) {
        mutate { state in
            state.preferredSouvenirs = state.preferredSouvenirs.map {
                $0.id == souvenirID ? $0.withWishlisted(isWishlisted) : $0
            }
            state.uploadSouvenirs = state.uploadSouvenirs.map {
                $0.id == souvenirID ? $0.withWishlisted(isWishlisted) : $0
            }
        }
    }
}
