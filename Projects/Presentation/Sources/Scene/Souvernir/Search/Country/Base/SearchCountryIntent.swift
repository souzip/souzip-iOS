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
}

// MARK: - Event

enum SearchCountryEvent {
    case showAlert(message: String)
    case loading(Bool)
}
