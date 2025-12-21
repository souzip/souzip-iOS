import UIKit

final class AuthCoordinator: BaseCoordinator<AuthRoute, RootRoute> {
    private let factory: PresentationFactory

    init(
        nav: UINavigationController,
        factory: PresentationFactory
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

        case .profile:
            showProfile()

        case .category:
            break

        case .main:
            showMain()
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

    func showProfile() {}

    func showMain() {
        navigateToParent(.main)
    }
}
