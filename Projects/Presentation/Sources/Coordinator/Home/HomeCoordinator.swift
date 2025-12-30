import UIKit

final class HomeCoordinator: BaseCoordinator<HomeRoute, TabRoute> {
    private let factory: PresentationHomeFactory

    init(nav: UINavigationController, factory: PresentationHomeFactory) {
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
        let scene = factory.makeGlobeScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: true)
    }
}
