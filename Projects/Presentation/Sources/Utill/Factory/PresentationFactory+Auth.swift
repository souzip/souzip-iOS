protocol PresentationAuthFactory: AnyObject {
    func makeSplashScene() -> RoutedScene<AuthRoute>
    func makeLoginScene() -> RoutedScene<AuthRoute>
    func makeTermsScene() -> RoutedScene<AuthRoute>
    func makeProfileScene() -> RoutedScene<AuthRoute>
    func makeCategoryScene() -> RoutedScene<AuthRoute>

    func makeLoginBottomSheetScene() -> RoutedScene<LoginBottomSheetRoute>
}

extension DefaultPresentationFactory {
    func makeSplashScene() -> RoutedScene<AuthRoute> {
        let vm = SplashViewModel(
            autoLogin: domainFactory.makeAutoLoginUseCase()
        )
        let view = SplashView()
        let vc = SplashViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeLoginScene() -> RoutedScene<AuthRoute> {
        let vm = LoginViewModel(
            loadRecentAuthProvider: domainFactory.makeLoadRecentAuthProviderUseCase(),
            login: domainFactory.makeLoginUseCase()
        )
        let view = LoginView()
        let vc = LoginViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeTermsScene() -> RoutedScene<AuthRoute> {
        let vm = TermsViewModel(
            saveMarketingConsent: domainFactory.makeSaveMarketingConsentUseCase()
        )
        let view = TermsView()
        let vc = TermsViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeProfileScene() -> RoutedScene<AuthRoute> {
        let vm = ProfileViewModel(
            validateNickname: domainFactory.makeValidateNicknameUseCase(),
            saveNickname: domainFactory.makeSaveNicknameUseCase(),
            saveProfileImageColor: domainFactory.makeSaveProfileImageColorUseCase()
        )
        let view = ProfileView()
        let vc = ProfileViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeCategoryScene() -> RoutedScene<AuthRoute> {
        let vm = CategoryViewModel(
            saveCategories: domainFactory.makeSaveCategoriesUseCase(),
            completeOnboarding: domainFactory.makeCompleteOnboardingUseCase()
        )
        let view = CategoryView()
        let vc = CategoryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    // MARK: - LoginBottomSheet

    func makeLoginBottomSheetScene() -> RoutedScene<LoginBottomSheetRoute> {
        let viewModel = LoginBottomSheetViewModel(
            login: domainFactory.makeLoginUseCase()
        )
        let contentView = LoginBottomSheetView()
        let vc = LoginBottomSheetViewController(viewModel: viewModel, contentView: contentView)

        return RoutedScene(
            vc: vc,
            route: viewModel.route,
            disposeBag: vc.disposeBag
        )
    }
}
