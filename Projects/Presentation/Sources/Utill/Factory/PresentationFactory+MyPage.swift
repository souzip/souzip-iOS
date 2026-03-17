protocol PresentationMyPageFactory: AnyObject {
    func makeMyPageScene() -> RoutedScene<MyPageRoute>
    func makeSetting() -> RoutedScene<MyPageRoute>
    func makeNoticeList() -> RoutedScene<MyPageRoute>
}

extension DefaultPresentationFactory {
    func makeMyPageScene() -> RoutedScene<MyPageRoute> {
        let vm = MyPageViewModel(
            userRepo: domainFactory.makeUserRepository(),
            souvenirRepo: domainFactory.makeSouvenirRepository(),
            countryRepo: domainFactory.makeCountryRepository(),
            authRepo: domainFactory.makeAuthRepository()
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

    func makeNoticeList() -> RoutedScene<MyPageRoute> {
        let vm = NoticeListViewModel(
            noticeRepo: domainFactory.makeNoticeRepository()
        )
        let view = NoticeListView()
        let vc = NoticeListViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
