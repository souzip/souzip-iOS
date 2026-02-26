import Domain

struct SearchCountryContext {
    let initialQuery: String
    let mode: SearchCountryMode
    let onResult: (SearchResultItem) -> Void
}

enum SearchCountryMode {
    case country
    case store
}
