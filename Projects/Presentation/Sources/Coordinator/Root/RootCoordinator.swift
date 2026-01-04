import Domain
import UIKit

public final class RootCoordinator: BaseCoordinator<RootRoute, Never> {
    private let factory: PresentationFactory

    public init(
        nav: UINavigationController,
        factory: DomainFactory
    ) {
        self.factory = DefaultPresentationFactory(domainFactory: factory)
        super.init(nav: nav)
    }

    override public func start() {
        navigate(.auth)
    }

    override public func navigate(_ route: Route) {
        switch route {
        case .auth:
            showAuth()

        case .main:
            showMain()

        case .login:
            showLogin()
        }
    }
}

private extension RootCoordinator {
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

    func showLogin() {
        children.removeAll()

        let coordinator = AuthCoordinator(
            nav: nav,
            factory: factory
        )
        addChild(coordinator)
        coordinator.navigate(.login)
    }
}
