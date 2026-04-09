import Domain

// MARK: - Main pane

enum SearchCountryMainPane: Equatable {
    /// 검색어 없음 — 캐릭터 온보딩
    case onboarding
    /// 검색 완료 후 결과 0건
    case noResults
    /// 리스트 표시(API 대기 중 빈 리스트 포함)
    case results
}

// MARK: - State

struct SearchCountryState {
    var searchText: String
    var items: [SearchResultItem] = []
    /// 검색어가 있는데 아직 API 응답 전이면 true → 노결과 화면 대신 빈 컬렉션(+로딩)
    var isSearchInFlight: Bool

    init(initialSearchText: String = "") {
        searchText = initialSearchText
        isSearchInFlight = !initialSearchText.isEmpty
    }
}

// MARK: - Action

enum SearchCountryAction {
    case back
    case searchTextChangedUI(String)
    case searchTextChangedAPI(String)
    case clearSearch
    case selectItem(SearchResultItem)
    case returnKeyTapped
    /// 위치 검색 결과에서 pop(무애니) 후 검색 필드·목록 동기화
    case resumeFromLocationResult(query: String?)
}

// MARK: - Event

enum SearchCountryEvent {
    case showAlert(message: String)
    case loading(Bool)
}
