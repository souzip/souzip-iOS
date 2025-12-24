import UIKit

final class DiscoveryCoordinator: BaseCoordinator<DiscoveryRoute, TabRoute> {
    private let factory: PresentationFactory

    init(nav: UINavigationController, factory: PresentationFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.discovery)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .discovery:
            showDiscovery()
        }
    }
}

private extension DiscoveryCoordinator {
    func showDiscovery() {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        nav.setViewControllers([vc], animated: false)
    }
}
