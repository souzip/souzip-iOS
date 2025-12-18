import UIKit

public final class AuthCoordinator: BaseCoordinator<AuthRoute> {
    private let factory: PresentationFactory

    public init(
        nav: UINavigationController,
        factory: PresentationFactory
    ) {
        self.factory = factory
        super.init(nav: nav)
    }

    override public func start() {
        navigate(.login)
    }

    override public func navigate(_ route: Route) {
        switch route {
        case .login:
            showLogin()
        }
    }
}

private extension AuthCoordinator {
    func showLogin() {
        let vc = factory.makeLoginVC()
        nav.setViewControllers([vc], animated: true)
    }
}
