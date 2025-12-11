import Logger
import Presentation
import UIKit

final class AppCoordinator: BaseCoordinator<AppRoute> {
    private let factory: PresentationFactory

    init(
        nav: UINavigationController,
        factory: PresentationFactory
    ) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.main)
    }

    override func navigate(_ route: Route) {
        Logger.shared.logAction(route)

        switch route {
        case .splash:
            showSplash()

        case .auth:
            showAuth()

        case .main:
            showMain()
        }
    }
}

private extension AppCoordinator {
    func showSplash() {
        let vc = SplashViewController()
        vc.onFinish = { _ in }
        nav.setViewControllers([vc], animated: false)
    }

    func showAuth() {
        children.removeAll()

        let coordinator = AuthCoordinator(
            nav: nav,
            factory: factory
        )
        addChild(coordinator)
        coordinator.start()
    }

    func showMain() {
        children.removeAll()

        let coordinator = TabBarCoordinator(
            nav: nav,
            factory: factory
        )
        addChild(coordinator)
        coordinator.start()
    }
}
