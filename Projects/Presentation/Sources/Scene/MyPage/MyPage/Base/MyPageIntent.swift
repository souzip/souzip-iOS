enum MyPageAction {
    case tapSetting
    case tapSegmentTab(CollectionTab)

    case tapLogin

    /// FAB — 부모에서 라우팅 (탭 VM과 동일 목적지)
    case tapCreateSouvenir
}

struct MyPageState: Equatable {
    var profile: ProfileData?
    var selectedTab: CollectionTab = .collection
    var isGuest: Bool = true
}

enum MyPageEvent {
    case showErrorAlert(String)
}
