import Logger
import Presentation
import UIKit

final class AppCoordinator: Coordinator {
    typealias Route = AppRoute

    let nav: UINavigationController
    weak var parent: (any Coordinator)?
    var children: [any Coordinator] = []

    private let factory: PresentationFactory

    init(
        nav: UINavigationController,
        factory: PresentationFactory
    ) {
        Logger.shared.logLifecycle()
        self.nav = nav
        self.factory = factory
    }

    deinit {
        Logger.shared.logLifecycle()
    }

    func navigate(_ route: Route, animated: Bool = true) {
        Logger.shared.logAction(route)

        switch route {
        case .splash:
            showSplash(animated)

        case .auth:
            showAuth(animated)

        case .main:
            showMain(animated)
        }
    }
}

private extension AppCoordinator {
    func showSplash(_ animated: Bool) {}

    func showAuth(_ animated: Bool) {}

    func showMain(_ animated: Bool) {}
}
