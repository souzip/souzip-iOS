import Domain

final class MyPageViewModel: BaseViewModel<
    MyPageState,
    MyPageAction,
    MyPageEvent,
    MyPageRoute
> {
    // MARK: - Repository

    private let userRepo: UserRepository
    private let souvenirRepo: SouvenirRepository
    private let countryRepo: CountryRepository
    private let authRepo: AuthRepository

    // MARK: - Init

    init(
        userRepo: UserRepository,
        souvenirRepo: SouvenirRepository,
        countryRepo: CountryRepository,
        authRepo: AuthRepository
    ) {
        self.userRepo = userRepo
        self.souvenirRepo = souvenirRepo
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
                if isLogin, state.value.isGeust == false {
                    mutate { $0.isGeust = !isLogin }
                    await loadInitialData()
                    return
                }
                let needs = await souvenirRepo.consumeMyPageNeedsRefresh()
                guard needs else { return }
                await loadInitialData()
            }

        case .tapSetting:
            navigate(to: .setting)

        case let .tapSegmentTab(tab):
            handleSelectTab(tab)

        case let .tapCountry(countryItem):
            handleSelectCountry(countryItem)

        case let .tapSouvenir(souvenir):
            navigate(to: .souvenirRoute(.detail(id: souvenir.id)))

        case .tapLogin:
            navigate(to: .loginModal)

        case .tapCreateSouvenir:
            navigate(to: .souvenirRoute(.create))
        }
    }

    // MARK: - Private Logic

    private func loadInitialData() async {
        do {
            // 1. 프로필 데이터 가져오기
            async let profileTask = await fetchProfile()
            async let souvenirsTask = await fetchColletionSouvenirs()

            let profile = try await profileTask
            let souvenirs = try await souvenirsTask

            let mapSouvenirs = souvenirs.compactMap { souvenir -> SouvenirThumbnail? in
                guard let country = try? countryRepo.fetchCountry(countryCode: souvenir.country) else { return nil }

                return .init(
                    id: souvenir.id,
                    thumbnailUrl: souvenir.thumbnailUrl,
                    country: country.nameKorean,
                    createdAt: souvenir.createdAt,
                    updatedAt: souvenir.updatedAt
                )
            }

            mutate { state in
                state.profile = profile
                state.collectionSouvenirs = mapSouvenirs
            }
        } catch {
            emit(.showErrorAlert(error.localizedDescription))
        }
    }

    private func handleSelectTab(_ tab: CollectionTab) {
        mutate { state in
            state.selectedTab = tab
        }
    }

    private func handleSelectCountry(_ countryItem: CountryItem) {
        let country = countryItem.name == "전체" ? nil : countryItem.name

        mutate { state in
            state.selectedCountry = country
        }
    }

    private func fetchProfile() async throws -> ProfileData {
        let userProfile = try await userRepo.getUserProfile()

        return ProfileData(
            profileImageUrl: userProfile.profileImageUrl,
            nickname: userProfile.nickname,
            email: userProfile.email
        )
    }

    private func fetchColletionSouvenirs() async throws -> [SouvenirThumbnail] {
        try await userRepo.getUserSouvenirs()
    }
}
