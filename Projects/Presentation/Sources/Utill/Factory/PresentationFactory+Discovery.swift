protocol PresentationDiscoveryFactory: AnyObject {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute>
}

extension DefaultPresentationFactory {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute> {
        let vm = DiscoveryViewModel(
            discoveryRepo: domainFactory.makeDiscoveryRepository(),
            countryRepo: domainFactory.makeCountryRepository()
        )
        let view = DiscoveryView()
        let vc = DiscoveryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
