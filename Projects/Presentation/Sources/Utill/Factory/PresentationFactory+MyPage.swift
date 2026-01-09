protocol PresentationMyPageFactory: AnyObject {
    func makeMyPageScene() -> RoutedScene<MyPageRoute>
    func makeSetting() -> RoutedScene<MyPageRoute>
}

extension DefaultPresentationFactory {
    func makeMyPageScene() -> RoutedScene<MyPageRoute> {
        let vm = MyPageViewModel(
            userRepo: domainFactory.makeUserRepository(),
            souvenirRepo: domainFactory.makeSouvenirRepository(),
            countryRepo: domainFactory.makeCountryRepository()
        )
        let view = MyPageView()
        let vc = MyPageViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeSetting() -> RoutedScene<MyPageRoute> {
        let vm = SettingViewModel(
            authRepo: domainFactory.makeAuthRepository()
        )
        let view = SettingView()
        let vc = SettingViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
