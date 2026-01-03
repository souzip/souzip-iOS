import Domain

final class MyPageViewModel: BaseViewModel<
    MyPageState,
    MyPageAction,
    MyPageEvent,
    MyPageRoute
> {
    // MARK: - Init

    init() {
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task { await loadInitialData() }

        case .tapSetting:
            navigate(to: .setting)

        case let .tapSegmentTab(tab):
            handleSelectTab(tab)

        case let .tapCountry(countryItem):
            handleSelectCountry(countryItem)

        case let .tapSouvenir(souvenir):
            navigate(to: .souvenirRoute(.detail(id: souvenir.id)))

        case .tapCreateSouvenir:
            navigate(to: .souvenirRoute(.create))
        }
    }

    // MARK: - Private Logic

    private func loadInitialData() async {
        // 1. 프로필 데이터 가져오기
        async let profileTask = await fetchProfile()
        async let souvenirsTask = await fetchColletionSouvenirs()

        let profile = await profileTask
        let souvenirs = await souvenirsTask

        mutate { state in
            state.profile = profile
//            state.collectionSouvenirs = souvenirs
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

    private func fetchProfile() async -> ProfileData {
        ProfileData(
            profileImageUrl: "https://picsum.photos/400/400?random=1",
            nickname: "닉네임닉네임닉네임닉네임닉네임닉네",
            email: "souzip@gmail.com"
        )
    }

    private func fetchColletionSouvenirs() async -> [SouvenirThumbnail] {
        [
            SouvenirThumbnail(
                id: 1,
                thumbnailUrl: "https://picsum.photos/400/400?random=1",
                country: "미국",
                createdAt: "2024-01-01",
                updatedAt: "2024-01-01"
            ),
            SouvenirThumbnail(
                id: 2,
                thumbnailUrl: "https://picsum.photos/400/400?random=2",
                country: "미국",
                createdAt: "2024-01-02",
                updatedAt: "2024-01-02"
            ),
            SouvenirThumbnail(
                id: 3,
                thumbnailUrl: "https://picsum.photos/400/400?random=3",
                country: "일본",
                createdAt: "2024-01-03",
                updatedAt: "2024-01-03"
            ),
            SouvenirThumbnail(
                id: 4,
                thumbnailUrl: "https://picsum.photos/400/400?random=4",
                country: "일본",
                createdAt: "2024-01-04",
                updatedAt: "2024-01-04"
            ),
            SouvenirThumbnail(
                id: 5,
                thumbnailUrl: "https://picsum.photos/400/400?random=5",
                country: "프랑스",
                createdAt: "2024-01-05",
                updatedAt: "2024-01-05"
            ),
            SouvenirThumbnail(
                id: 6,
                thumbnailUrl: "https://picsum.photos/400/400?random=6",
                country: "프랑스",
                createdAt: "2024-01-06",
                updatedAt: "2024-01-06"
            ),
            SouvenirThumbnail(
                id: 7,
                thumbnailUrl: "https://picsum.photos/400/400?random=7",
                country: "이탈리아",
                createdAt: "2024-01-07",
                updatedAt: "2024-01-07"
            ),
            SouvenirThumbnail(
                id: 8,
                thumbnailUrl: "https://picsum.photos/400/400?random=8",
                country: "이탈리아",
                createdAt: "2024-01-08",
                updatedAt: "2024-01-08"
            ),
        ]
    }
}
