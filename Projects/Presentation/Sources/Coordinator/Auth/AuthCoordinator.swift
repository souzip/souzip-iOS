import UIKit

final class AuthCoordinator: BaseCoordinator<AuthRoute, RootRoute> {
    private let factory: PresentationAuthFactory

    init(
        nav: UINavigationController,
        factory: PresentationAuthFactory
    ) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.splash)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .splash:
            showSplash()

        case .login:
            showLogin()

        case .terms:
            showTerms()

        case .profile:
            showProfile()

        case .category:
            showCategory()

        case .main:
            showMain()

        case .back:
            nav.popViewController(animated: true)
        }
    }
}

private extension AuthCoordinator {
    func showSplash() {
        let scene = factory.makeSplashScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: false)
    }

    func showLogin() {
        let scene = factory.makeLoginScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: false)
    }

    func showTerms() {
        let scene = factory.makeTermsScene()
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showProfile() {
        let scene = factory.makeProfileScene()
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showCategory() {
        let scene = factory.makeCategoryScene()
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showMain() {
        navigateToParent(.main)
    }
}
