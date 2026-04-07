import Domain

struct SearchCountryContext {
    let initialQuery: String
    let mode: SearchCountryMode
    let onResult: ([SearchResultItem], SearchResultItem, String) -> Void
}

enum SearchCountryMode {
    case country
    case store
}
