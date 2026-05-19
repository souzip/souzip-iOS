protocol PresentationDiscoveryFactory: AnyObject {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute>
    func makeRecommendScene() -> RoutedScene<DiscoveryRoute>
}

extension DefaultPresentationFactory {
    func makeDiscoveryScene() -> RoutedScene<DiscoveryRoute> {
        let vm = DiscoveryViewModel(
            loadCountryTopSouvenirs: domainFactory.makeLoadCountryTopSouvenirsUseCase(),
            loadTopSouvenirsByCategory: domainFactory.makeLoadTopSouvenirsByCategoryUseCase(),
            loadCountryDetail: domainFactory.makeLoadCountryDetailUseCase(),
            authSessionStore: authSessionStore,
            wishlistToggleExecutor: wishlistToggleExecutor
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
            loadAIRecommendationsForCategory: domainFactory.makeLoadAIRecommendationsForCategoryUseCase(),
            loadAIRecommendationsForUpload: domainFactory.makeLoadAIRecommendationsForUploadUseCase(),
            loadCountryDetail: domainFactory.makeLoadCountryDetailUseCase(),
            authSessionStore: authSessionStore,
            wishlistToggleExecutor: wishlistToggleExecutor
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
