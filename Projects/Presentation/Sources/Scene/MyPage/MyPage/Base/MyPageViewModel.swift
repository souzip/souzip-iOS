import Domain
import RxCocoa
import RxSwift

final class MyPageViewModel: BaseViewModel<
    MyPageState,
    MyPageAction,
    MyPageEvent,
    MyPageRoute
> {
    // MARK: - Child

    let collectionTabViewModel: MyPageCollectionTabViewModel

    // MARK: - UseCase

    private let loadUserProfile: LoadUserProfileUseCase
    private let loadUserSouvenirs: LoadUserSouvenirsUseCase
    private let loadCountryDetail: LoadCountryDetailUseCase
    private let userSouvenirInvalidationStore: UserSouvenirInvalidationStore
    private let authSessionStore: AuthSessionStore

    // MARK: - Init

    init(
        loadUserProfile: LoadUserProfileUseCase,
        loadUserSouvenirs: LoadUserSouvenirsUseCase,
        loadCountryDetail: LoadCountryDetailUseCase,
        userSouvenirInvalidationStore: UserSouvenirInvalidationStore,
        authSessionStore: AuthSessionStore,
        collectionTabViewModel: MyPageCollectionTabViewModel
    ) {
        self.loadUserProfile = loadUserProfile
        self.loadUserSouvenirs = loadUserSouvenirs
        self.loadCountryDetail = loadCountryDetail
        self.userSouvenirInvalidationStore = userSouvenirInvalidationStore
        self.authSessionStore = authSessionStore
        self.collectionTabViewModel = collectionTabViewModel
        super.init(initialState: State())
        bindAuthSessionStore()
        bindUserSouvenirInvalidationStore()
        bindChildCollectionRoutes()
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .tapSetting:
            navigate(to: .setting)

        case let .tapSegmentTab(tab):
            handleSelectTab(tab)

        case .tapLogin:
            navigate(to: .loginBottomSheet)

        case .tapCreateSouvenir:
            navigate(to: .souvenirRoute(.create))
        }
    }

    // MARK: - Auth

    private func bindAuthSessionStore() {
        authSessionStore.authStateChanges
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLogin in
                guard let self else { return }
                let wasGuest = state.value.isGuest
                mutate { $0.isGuest = !isLogin }
                if !isLogin {
                    collectionTabViewModel.syncSouvenirs([])
                }
                if isLogin, wasGuest {
                    Task { await self.loadInitialData() }
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - User souvenir collection

    private func bindUserSouvenirInvalidationStore() {
        userSouvenirInvalidationStore.userSouvenirCollectionDidChange
            .observe(on: MainScheduler.instance)
            .filter { [weak self] _ in
                guard let self else { return false }
                return !state.value.isGuest
            }
            .subscribe(onNext: { [weak self] _ in
                Task { await self?.loadInitialData() }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Child routes → 부모 route

    private func bindChildCollectionRoutes() {
        collectionTabViewModel.route
            .subscribe(onNext: { [weak self] route in
                self?.navigate(to: route)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Logic

    private func loadInitialData() async {
        do {
            async let profileTask = await fetchProfile()
            async let souvenirsTask = await fetchColletionSouvenirs()

            let profile = try await profileTask
            let souvenirPage = try await souvenirsTask

            let mapSouvenirs = souvenirPage.items.compactMap { souvenir -> SouvenirThumbnail? in
                guard let country = try? loadCountryDetail.execute(countryCode: souvenir.country) else { return nil }

                return .init(
                    id: souvenir.id,
                    thumbnailUrl: souvenir.thumbnailUrl,
                    country: country.nameKorean,
                    createdAt: souvenir.createdAt,
                    updatedAt: souvenir.updatedAt
                )
            }

            mutate { $0.profile = profile }
            collectionTabViewModel.syncSouvenirs(mapSouvenirs)
        } catch {
            emit(.showErrorAlert(error.localizedDescription))
        }
    }

    private func handleSelectTab(_ tab: CollectionTab) {
        mutate { state in
            state.selectedTab = tab
        }
    }

    private func fetchProfile() async throws -> ProfileData {
        let userProfile = try await loadUserProfile.execute()

        return ProfileData(
            profileImageUrl: userProfile.profileImageUrl,
            nickname: userProfile.nickname,
            email: userProfile.email
        )
    }

    private func fetchColletionSouvenirs() async throws -> UserSouvenirListPage {
        try await loadUserSouvenirs.execute(page: 1, size: 12)
    }
}
