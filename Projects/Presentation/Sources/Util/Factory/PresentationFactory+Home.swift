protocol PresentationHomeFactory: AnyObject {
    func makeGlobeScene() -> RoutedScene<HomeRoute>
}

extension DefaultPresentationFactory {
    func makeGlobeScene() -> RoutedScene<HomeRoute> {
        let vm = GlobeViewModel(
            loadPopularCountries: domainFactory.makeLoadPopularCountriesUseCase(),
            loadNearbySouvenirs: domainFactory.makeLoadNearbySouvenirsUseCase(),
            checkFullAuthentication: domainFactory.makeCheckFullAuthenticationUseCase()
        )
        let view = GlobeView()
        let vc = GlobeViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
