import Domain

struct SearchCountryContext {
    let initialQuery: String
    let onResult: (SearchResultItem) -> Void
}
