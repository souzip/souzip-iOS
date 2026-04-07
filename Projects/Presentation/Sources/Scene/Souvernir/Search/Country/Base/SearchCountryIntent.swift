import Domain

// MARK: - State

struct SearchCountryState {
    var searchText: String
    var items: [SearchResultItem] = []
    var isEmpty: Bool

    init(initialSearchText: String = "") {
        searchText = initialSearchText
        isEmpty = initialSearchText.isEmpty
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
