import UIKit

final class HomeCoordinator: BaseCoordinator<HomeRoute, TabRoute> {
    private let factory: PresentationFactory

    init(nav: UINavigationController, factory: PresentationFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.globe)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .globe:
            showGlobe()
        }
    }
}

private extension HomeCoordinator {
    func showGlobe() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        nav.setViewControllers([vc], animated: false)
    }
}
