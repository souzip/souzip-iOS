protocol PresentationMyPageFactory: AnyObject {
    func makeMyPageScene() -> RoutedScene<MyPageRoute>
}

extension DefaultPresentationFactory {
    func makeMyPageScene() -> RoutedScene<MyPageRoute> {
        let vm = MyPageViewModel(
            userRepo: domainFactory.makeUserRepository()
        )
        let view = MyPageView()
        let vc = MyPageViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
