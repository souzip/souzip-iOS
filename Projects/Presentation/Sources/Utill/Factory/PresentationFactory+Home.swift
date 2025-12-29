protocol PresentationHomeFactory: AnyObject {
    func makeGlobeScene() -> RoutedScene<HomeRoute>
    func makeSearchScene(
        onResult: @escaping (SearchResultItem) -> Void
    ) -> RoutedScene<HomeRoute>
}

extension DefaultPresentationFactory {
    func makeGlobeScene() -> RoutedScene<HomeRoute> {
        let vm = GlobeViewModel(
            countryRepo: domainFactory.makeCountryRepository()
        )
        let view = GlobeView()
        let vc = GlobeViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeSearchScene(
        onResult: @escaping (SearchResultItem) -> Void
    ) -> RoutedScene<HomeRoute> {
        let vm = SearchCountryViewModel(onResult: onResult)
        let view = SearchCountryView()
        let vc = SearchCountryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
