import Domain
import UIKit

protocol PresentationFactory: AnyObject {
    func makeSplashScene() -> RoutedScene<AuthRoute>
    func makeLoginScene() -> RoutedScene<AuthRoute>
    func makeTermsScene() -> RoutedScene<AuthRoute>
    func makeProfileScene() -> RoutedScene<AuthRoute>
}

final class DefaultPresentationFactory: PresentationFactory {
    private let domainFactory: DomainFactory

    init(domainFactory: DomainFactory) {
        self.domainFactory = domainFactory
    }

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
        let vm = TermsViewModel()
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
            validateNickname: domainFactory.makeValidateNicknameUseCase()
        )
        let view = ProfileView()
        let vc = ProfileViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
