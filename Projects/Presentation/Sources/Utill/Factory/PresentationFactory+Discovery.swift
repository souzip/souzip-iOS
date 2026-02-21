protocol PresentationDiscoveryFactory: AnyObject {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute>
    func makeRecommendScene() -> RoutedScene<DiscoveryRoute>
}

extension DefaultPresentationFactory {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute> {
        let vm = DiscoveryViewModel(
            discoveryRepo: domainFactory.makeDiscoveryRepository(),
            countryRepo: domainFactory.makeCountryRepository(),
            authRepo: domainFactory.makeAuthRepository()
        )
        let view = DiscoveryView()
        let vc = DiscoveryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeRecommendScene() -> RoutedScene<DiscoveryRoute> {
        let vm = RecommendViewModel(
            discoveryRepo: domainFactory.makeDiscoveryRepository(),
            countryRepo: domainFactory.makeCountryRepository()
        )
        let view = RecommendView()
        let vc = RecommendViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
