import UIKit

public final class AuthCoordinator: Coordinator {
    public typealias Route = AuthRoute

    public let nav: UINavigationController
    public var children: [any Coordinator] = []
    public weak var parent: (any Coordinator)?

    private let factory: PresentationFactory

    public init(
        nav: UINavigationController,
        factory: PresentationFactory
    ) {
        self.nav = nav
        self.factory = factory
    }

    public func navigate(_ route: Route, animated: Bool = true) {
        switch route {
        case .login:
            showLogin()
        }
    }
}

private extension AuthCoordinator {
    func showLogin() {}
}
