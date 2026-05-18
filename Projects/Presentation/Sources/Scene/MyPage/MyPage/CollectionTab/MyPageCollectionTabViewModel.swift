import Domain

final class MyPageCollectionTabViewModel: BaseViewModel<
    MyPageCollectionTabState,
    MyPageCollectionTabAction,
    MyPageCollectionTabEvent,
    MyPageRoute
> {
    init() {
        super.init(initialState: MyPageCollectionTabState())
    }

    override func handleAction(_ action: Action) {
        switch action {
        case let .tapCountry(countryItem):
            let country = countryItem.name == "전체" ? nil : countryItem.name
            mutate { $0.selectedCountry = country }

        case let .tapSouvenir(souvenir):
            navigate(to: .souvenirRoute(.detail(id: souvenir.id)))

        case .tapCreateSouvenir:
            navigate(to: .souvenirRoute(.create))
        }
    }

    /// 부모 `MyPageViewModel`에서 로드 결과를 주입
    func syncSouvenirs(_ souvenirs: [SouvenirThumbnail]) {
        mutate { state in
            state.collectionSouvenirs = souvenirs
            if souvenirs.isEmpty {
                state.selectedCountry = nil
            }
        }
    }
}
