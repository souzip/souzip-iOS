protocol PresentationDiscoveryFactory: AnyObject {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute>
}

extension DefaultPresentationFactory {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute> {
        let vm = DiscoveryViewModel()
        let view = DiscoveryView()
        let vc = DiscoveryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
