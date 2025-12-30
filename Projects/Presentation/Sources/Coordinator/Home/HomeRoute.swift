enum HomeRoute {
    case globe
    case search(onResult: (SearchResultItem) -> Void)

    case pop
}
