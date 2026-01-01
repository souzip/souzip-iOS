enum HomeRoute {
    case globe
    case createSouvenir
    case searchCountry(onResult: (SearchResultItem) -> Void)

    case pop
    case dismiss
}
